import Flutter
import CloudKit

class CloudKitHandler: NSObject, FlutterPlugin {
    private let container: CKContainer
    private let privateDatabase: CKDatabase

    init(container: CKContainer = CKContainer.default()) {
        self.container = container
        self.privateDatabase = container.privateCloudDatabase
        super.init()
    }

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.parsecxr.todoredo/cloudkit",
            binaryMessenger: registrar.messenger()
        )
        let instance = CloudKitHandler()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            initialize(result: result)
        case "getAccountStatus":
            getAccountStatus(result: result)
        case "pushRecord":
            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
                return
            }
            pushRecord(args: args, result: result)
        case "pushRecordsBatch":
            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
                return
            }
            pushRecordsBatch(args: args, result: result)
        case "fetchRecordsSince":
            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
                return
            }
            fetchRecordsSince(args: args, result: result)
        case "fetchRecord":
            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
                return
            }
            fetchRecord(args: args, result: result)
        case "deleteRecord":
            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
                return
            }
            deleteRecord(args: args, result: result)
        case "subscribeToChanges":
            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
                return
            }
            subscribeToChanges(args: args, result: result)
        case "unsubscribeFromChanges":
            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
                return
            }
            unsubscribeFromChanges(args: args, result: result)
        case "getPendingChanges":
            getPendingChanges(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func initialize(result: @escaping FlutterResult) {
        // Check if CloudKit is available
        container.accountStatus { status, error in
            if let error = error {
                result(FlutterError(
                    code: "CLOUDKIT_ERROR",
                    message: error.localizedDescription,
                    details: nil
                ))
                return
            }
            result(status == .available)
        }
    }

    private func getAccountStatus(result: @escaping FlutterResult) {
        container.accountStatus { status, error in
            if let error = error {
                print("CloudKit account status error: \(error.localizedDescription)")
                result("couldNotDetermine")
                return
            }

            let statusString: String
            switch status {
            case .available:
                statusString = "available"
            case .noAccount:
                statusString = "noAccount"
            case .restricted:
                statusString = "restricted"
            case .couldNotDetermine:
                statusString = "couldNotDetermine"
            case .temporarilyUnavailable:
                statusString = "temporarilyUnavailable"
            @unknown default:
                statusString = "couldNotDetermine"
            }

            result(statusString)
        }
    }

    private func pushRecord(args: [String: Any], result: @escaping FlutterResult) {
        guard let recordType = args["recordType"] as? String,
              let data = args["data"] as? [String: Any],
              let id = data["id"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing required fields", details: nil))
            return
        }

        let recordID = CKRecord.ID(recordName: id)
        let record = CKRecord(recordType: recordType, recordID: recordID)

        // Map data to CloudKit fields
        mapDataToRecord(data: data, record: record)

        privateDatabase.save(record) { savedRecord, error in
            if let error = error {
                print("CloudKit save error: \(error.localizedDescription)")
                result(FlutterError(
                    code: "CLOUDKIT_ERROR",
                    message: error.localizedDescription,
                    details: nil
                ))
                return
            }
            result(true)
        }
    }

    private func pushRecordsBatch(args: [String: Any], result: @escaping FlutterResult) {
        guard let recordType = args["recordType"] as? String,
              let records = args["records"] as? [[String: Any]] else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing required fields", details: nil))
            return
        }

        var ckRecords: [CKRecord] = []
        for data in records {
            guard let id = data["id"] as? String else { continue }
            let recordID = CKRecord.ID(recordName: id)
            let record = CKRecord(recordType: recordType, recordID: recordID)
            mapDataToRecord(data: data, record: record)
            ckRecords.append(record)
        }

        let operation = CKModifyRecordsOperation(recordsToSave: ckRecords, recordIDsToDelete: nil)
        var successCount = 0
        var failureCount = 0
        var failedRecordIds: [String] = []
        var errors: [String] = []

        operation.perRecordCompletionBlock = { record, error in
            if let error = error {
                failureCount += 1
                failedRecordIds.append(record.recordID.recordName)
                errors.append(error.localizedDescription)
            } else {
                successCount += 1
            }
        }

        operation.modifyRecordsCompletionBlock = { _, _, error in
            let resultDict: [String: Any] = [
                "totalRecords": records.count,
                "successCount": successCount,
                "failureCount": failureCount,
                "failedRecordIds": failedRecordIds,
                "errors": errors
            ]
            result(resultDict)
        }

        privateDatabase.add(operation)
    }

    private func fetchRecordsSince(args: [String: Any], result: @escaping FlutterResult) {
        guard let recordType = args["recordType"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing recordType", details: nil))
            return
        }

        let predicate: NSPredicate
        if let sinceMs = args["since"] as? Int64 {
            let sinceDate = Date(timeIntervalSince1970: Double(sinceMs) / 1000.0)
            predicate = NSPredicate(format: "modificationDate > %@", sinceDate as NSDate)
        } else {
            predicate = NSPredicate(value: true)
        }

        let query = CKQuery(recordType: recordType, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: true)]

        privateDatabase.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("CloudKit fetch error: \(error.localizedDescription)")
                result(FlutterError(
                    code: "CLOUDKIT_ERROR",
                    message: error.localizedDescription,
                    details: nil
                ))
                return
            }

            let recordsData = records?.map { record in
                self.mapRecordToData(record: record)
            } ?? []

            result(recordsData)
        }
    }

    private func fetchRecord(args: [String: Any], result: @escaping FlutterResult) {
        guard let recordType = args["recordType"] as? String,
              let id = args["id"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing required fields", details: nil))
            return
        }

        let recordID = CKRecord.ID(recordName: id)
        privateDatabase.fetch(withRecordID: recordID) { record, error in
            if let error = error {
                print("CloudKit fetch record error: \(error.localizedDescription)")
                result(nil)
                return
            }

            if let record = record {
                result(self.mapRecordToData(record: record))
            } else {
                result(nil)
            }
        }
    }

    private func deleteRecord(args: [String: Any], result: @escaping FlutterResult) {
        guard let recordType = args["recordType"] as? String,
              let id = args["id"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing required fields", details: nil))
            return
        }

        let recordID = CKRecord.ID(recordName: id)
        privateDatabase.delete(withRecordID: recordID) { _, error in
            if let error = error {
                print("CloudKit delete error: \(error.localizedDescription)")
                result(false)
                return
            }
            result(true)
        }
    }

    private func subscribeToChanges(args: [String: Any], result: @escaping FlutterResult) {
        guard let recordType = args["recordType"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing recordType", details: nil))
            return
        }

        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: recordType, predicate: predicate, options: [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion])

        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo

        privateDatabase.save(subscription) { _, error in
            if let error = error {
                print("CloudKit subscription error: \(error.localizedDescription)")
                result(false)
                return
            }
            result(true)
        }
    }

    private func unsubscribeFromChanges(args: [String: Any], result: @escaping FlutterResult) {
        guard let recordType = args["recordType"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing recordType", details: nil))
            return
        }

        // Fetch all subscriptions and delete matching ones
        privateDatabase.fetchAllSubscriptions { subscriptions, error in
            if let error = error {
                print("CloudKit fetch subscriptions error: \(error.localizedDescription)")
                result(false)
                return
            }

            guard let subscriptions = subscriptions else {
                result(false)
                return
            }

            let matchingSubscriptions = subscriptions.filter { subscription in
                if let querySubscription = subscription as? CKQuerySubscription {
                    return querySubscription.recordType == recordType
                }
                return false
            }

            if matchingSubscriptions.isEmpty {
                result(true)
                return
            }

            let subscriptionIDs = matchingSubscriptions.map { $0.subscriptionID }
            let operation = CKModifySubscriptionsOperation(subscriptionsToSave: nil, subscriptionIDsToDelete: subscriptionIDs)

            operation.modifySubscriptionsCompletionBlock = { _, _, error in
                if let error = error {
                    print("CloudKit unsubscribe error: \(error.localizedDescription)")
                    result(false)
                    return
                }
                result(true)
            }

            self.privateDatabase.add(operation)
        }
    }

    private func getPendingChanges(result: @escaping FlutterResult) {
        // For simplicity, return empty list
        // In a real implementation, you'd track pending changes from notifications
        result([])
    }

    private func mapDataToRecord(data: [String: Any], record: CKRecord) {
        // Map common fields
        if let title = data["title"] as? String {
            record["title"] = title as CKRecordValue
        }
        if let description = data["description"] as? String {
            record["description"] = description as CKRecordValue
        }
        if let isCompleted = data["isCompleted"] as? Bool {
            record["isCompleted"] = isCompleted as CKRecordValue
        }
        if let isDeleted = data["isDeleted"] as? Bool {
            record["isDeleted"] = isDeleted as CKRecordValue
        }
        if let dueDateMs = data["dueDate"] as? Int64 {
            let dueDate = Date(timeIntervalSince1970: Double(dueDateMs) / 1000.0)
            record["dueDate"] = dueDate as CKRecordValue
        }
        if let completedAtMs = data["completedAt"] as? Int64 {
            let completedAt = Date(timeIntervalSince1970: Double(completedAtMs) / 1000.0)
            record["completedAt"] = completedAt as CKRecordValue
        }
        if let deletedAtMs = data["deletedAt"] as? Int64 {
            let deletedAt = Date(timeIntervalSince1970: Double(deletedAtMs) / 1000.0)
            record["deletedAt"] = deletedAt as CKRecordValue
        }
        if let createdAtMs = data["createdAt"] as? Int64 {
            let createdAt = Date(timeIntervalSince1970: Double(createdAtMs) / 1000.0)
            record["createdAt"] = createdAt as CKRecordValue
        }
        if let updatedAtMs = data["updatedAt"] as? Int64 {
            let updatedAt = Date(timeIntervalSince1970: Double(updatedAtMs) / 1000.0)
            record["updatedAt"] = updatedAt as CKRecordValue
        }
        if let listId = data["listId"] as? String {
            record["listId"] = listId as CKRecordValue
        }
        if let reminderEnabled = data["reminderEnabled"] as? Bool {
            record["reminderEnabled"] = reminderEnabled as CKRecordValue
        }
        if let reminderOffset = data["reminderOffset"] as? Int64 {
            record["reminderOffset"] = reminderOffset as CKRecordValue
        }
        if let reminderUnit = data["reminderUnit"] as? String {
            record["reminderUnit"] = reminderUnit as CKRecordValue
        }
        if let recurrenceEnabled = data["recurrenceEnabled"] as? Bool {
            record["recurrenceEnabled"] = recurrenceEnabled as CKRecordValue
        }
        if let recurrenceInterval = data["recurrenceInterval"] as? Int64 {
            record["recurrenceInterval"] = recurrenceInterval as CKRecordValue
        }
        if let recurrenceUnit = data["recurrenceUnit"] as? String {
            record["recurrenceUnit"] = recurrenceUnit as CKRecordValue
        }
        if let originalTodoId = data["originalTodoId"] as? String {
            record["originalTodoId"] = originalTodoId as CKRecordValue
        }
        if let deviceId = data["deviceId"] as? String {
            record["deviceId"] = deviceId as CKRecordValue
        }

        // TodoList fields
        if let name = data["name"] as? String {
            record["name"] = name as CKRecordValue
        }
        if let colorValue = data["colorValue"] as? Int64 {
            record["colorValue"] = colorValue as CKRecordValue
        }
        if let icon = data["icon"] as? String {
            record["icon"] = icon as CKRecordValue
        }

        // Reminder fields
        if let todoId = data["todoId"] as? String {
            record["todoId"] = todoId as CKRecordValue
        }
        if let reminderTimeMs = data["reminderTime"] as? Int64 {
            let reminderTime = Date(timeIntervalSince1970: Double(reminderTimeMs) / 1000.0)
            record["reminderTime"] = reminderTime as CKRecordValue
        }
        if let isTriggered = data["isTriggered"] as? Bool {
            record["isTriggered"] = isTriggered as CKRecordValue
        }
        if let isDismissed = data["isDismissed"] as? Bool {
            record["isDismissed"] = isDismissed as CKRecordValue
        }
        if let isSnoozed = data["isSnoozed"] as? Bool {
            record["isSnoozed"] = isSnoozed as CKRecordValue
        }
        if let snoozeUntilMs = data["snoozeUntil"] as? Int64 {
            let snoozeUntil = Date(timeIntervalSince1970: Double(snoozeUntilMs) / 1000.0)
            record["snoozeUntil"] = snoozeUntil as CKRecordValue
        }
    }

    private func mapRecordToData(record: CKRecord) -> [String: Any] {
        var data: [String: Any] = [:]

        data["id"] = record.recordID.recordName
        data["recordType"] = record.recordType
        data["createdAt"] = Int64((record.creationDate?.timeIntervalSince1970 ?? 0) * 1000)
        data["updatedAt"] = Int64((record.modificationDate?.timeIntervalSince1970 ?? 0) * 1000)

        var fields: [String: Any] = [:]
        // Extract all fields from CKRecord
        for key in record.allKeys() {
            if let value = record[key] {
                fields[key] = convertCKValue(value)
            }
        }
        data["fields"] = fields
        data["isDeleted"] = fields["isDeleted"] as? Bool ?? false

        return data
    }

    private func convertCKValue(_ value: Any) -> Any {
        if let date = value as? Date {
            return Int64(date.timeIntervalSince1970 * 1000)
        }
        return value
    }
}
