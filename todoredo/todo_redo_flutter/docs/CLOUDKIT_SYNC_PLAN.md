# CloudKit Sync Implementation Plan

## Overview

Implement iCloud sync using CloudKit while maintaining the existing Drift-based local storage architecture. This enables seamless data synchronization across iOS devices using the user's iCloud account.

## Architecture

```
┌─────────────────────────────────────────────────┐
│                  UI Layer                        │
│         (No changes required)                    │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────┐
│    Service Layer (TodoService, etc.)             │
│         (Minor changes for sync triggers)        │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────┐
│    Repository Layer (ITodoRepository)            │
│    (Interface remains unchanged)                 │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────┐
│   DriftTodoRepository (Local SQLite)             │
│   (Add soft delete, sync tracking)               │
│   Source of truth for local data                 │
└──────────────────┬──────────────────────────────┘
                   │
                   │  Coordinated by:
                   │
┌──────────────────▼──────────────────────────────┐
│         SyncCoordinatorService                   │
│   (Orchestrates bidirectional sync)              │
│   Drift ↔ CloudKit                               │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────┐
│         CloudKitSyncService                      │
│   (Platform channel to native iOS)               │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────┐
│         CloudKit (CKDatabase)                    │
│   (iCloud storage + sync)                        │
└──────────────────────────────────────────────────┘
```

## Key Principles

1. **Local-First**: Drift is the source of truth. App works offline.
2. **Soft Deletes**: Never hard delete - use tombstones for sync
3. **Last-Write-Wins**: Use timestamps for conflict resolution
4. **Transparent Sync**: UI doesn't need to know about CloudKit
5. **Graceful Degradation**: App works without iCloud account

## Phase 1: Soft Delete Support

### Goals
- Add soft delete fields to all entities
- Update Drift schema with sync tracking
- Modify repositories to use soft deletes
- Update queries to filter deleted items

### Schema Changes

**New fields for all tables (Todos, TodoLists, Reminders):**

```dart
// Soft delete tracking
BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
DateTimeColumn get deletedAt => dateTime().nullable()();

// Sync tracking
BoolColumn get needsSync => boolean().withDefault(const Constant(true))();
DateTimeColumn get lastSyncedAt => dateTime().nullable()();

// Device tracking (optional, useful for debugging)
TextColumn get deviceId => text().nullable()();
```

### Entity Updates

**Add fields to domain entities:**

```dart
class Todo {
  // ... existing fields ...

  final bool isDeleted;
  final DateTime? deletedAt;
  final bool needsSync;
  final DateTime? lastSyncedAt;
  final String? deviceId;

  // Update copyWith to include new fields
  // Update toJson/fromJson for serialization
}
```

### Repository Changes

**Add new methods to ITodoRepository:**

```dart
abstract class ITodoRepository {
  // ... existing methods ...

  // Soft delete instead of hard delete
  Future<void> softDeleteTodo(String id);

  // Get items needing sync
  Future<List<Todo>> getTodosNeedingSync();

  // Mark item as synced
  Future<void> markTodoAsSynced(String id, DateTime syncTime);

  // Mark item as needing sync
  Future<void> markTodoAsNeedsSync(String id);

  // Hard delete (for cleanup only, not exposed to services)
  Future<void> hardDeleteTodo(String id);

  // Cleanup old tombstones (deleted > 90 days ago)
  Future<int> cleanupOldTombstones({int daysOld = 90});

  // Get deleted items (for debugging)
  Future<List<Todo>> getDeletedTodos();
}
```

**Implementation in DriftTodoRepository:**

```dart
@override
Future<void> softDeleteTodo(String id) async {
  final now = DateTime.now();
  await (update(todos)..where((t) => t.id.equals(id))).write(
    TodosCompanion(
      isDeleted: Value(true),
      deletedAt: Value(now),
      updatedAt: Value(now),
      needsSync: Value(true),
    ),
  );
}

@override
Future<List<Todo>> getTodosNeedingSync() {
  return (select(todos)
    ..where((t) => t.needsSync.equals(true))
    ..orderBy([
      (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.asc)
    ])
  ).get();
}

@override
Future<void> markTodoAsSynced(String id, DateTime syncTime) async {
  await (update(todos)..where((t) => t.id.equals(id))).write(
    TodosCompanion(
      needsSync: Value(false),
      lastSyncedAt: Value(syncTime),
    ),
  );
}

// All queries must filter out deleted items
@override
Future<List<Todo>> getAllTodos() {
  return (select(todos)
    ..where((t) => t.isDeleted.equals(false))  // <-- Added
    ..orderBy([
      (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
    ])
  ).get();
}
```

### Service Updates

**TodoService needs to use soft delete:**

```dart
class TodoService {
  // Change deleteTodo to use softDeleteTodo
  Future<void> deleteTodo(String id) async {
    // Cancel reminders first
    await _reminderService.deleteRemindersForTodo(id);

    // Soft delete instead of hard delete
    await _repository.softDeleteTodo(id);
  }
}
```

### Migration Strategy

**Database migration steps:**

1. Run `flutter pub run build_runner build` to generate migration
2. Drift will auto-create migration from schema changes
3. Existing data gets default values (isDeleted=false, needsSync=true)
4. All existing records marked as needing sync (initial CloudKit push)

### Testing Checklist

- [ ] Create new todo → appears in list
- [ ] Delete todo → disappears from list but still in DB
- [ ] Deleted todo has isDeleted=true, deletedAt set
- [ ] getAllTodos excludes deleted items
- [ ] getTodosNeedingSync returns new/modified items
- [ ] markAsSynced clears needsSync flag
- [ ] Cleanup removes tombstones older than 90 days

## Phase 2: CloudKit Service Interface

### Goals
- Create platform-agnostic interface for sync operations
- Define data structures for sync results
- Prepare for iOS platform channel integration

### Interface Definition

**File: `lib/domain/services/i_cloud_sync_service.dart`**

```dart
/// Platform-agnostic interface for CloudKit sync operations
abstract class ICloudSyncService {
  /// Initialize CloudKit connection and containers
  Future<bool> initialize();

  /// Check if user is signed into iCloud
  Future<bool> isSignedIn();

  /// Check CloudKit account status
  Future<CloudAccountStatus> getAccountStatus();

  /// Push a single record to CloudKit
  Future<bool> pushRecord(String recordType, Map<String, dynamic> data);

  /// Push multiple records in batch
  Future<BatchResult> pushRecordsBatch(String recordType, List<Map<String, dynamic>> records);

  /// Fetch all records of a type modified since a date
  Future<List<CloudRecord>> fetchRecordsSince(String recordType, DateTime? since);

  /// Fetch a single record by ID
  Future<CloudRecord?> fetchRecord(String recordType, String id);

  /// Delete a record from CloudKit (soft delete - pushes deletion marker)
  Future<bool> deleteRecord(String recordType, String id);

  /// Subscribe to CloudKit push notifications for changes
  Future<bool> subscribeToChanges(String recordType);

  /// Unsubscribe from push notifications
  Future<bool> unsubscribeFromChanges(String recordType);

  /// Get list of pending changes (from CloudKit subscriptions)
  Future<List<String>> getPendingChanges();
}

/// CloudKit account status
enum CloudAccountStatus {
  available,        // Signed in, ready to sync
  noAccount,        // Not signed into iCloud
  restricted,       // Parental controls or restrictions
  couldNotDetermine, // Unable to check status
  temporarilyUnavailable, // Network issues
}

/// Result from CloudKit sync operation
class CloudRecord {
  final String id;
  final String recordType;
  final Map<String, dynamic> fields;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;

  CloudRecord({
    required this.id,
    required this.recordType,
    required this.fields,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });
}

/// Result from batch operations
class BatchResult {
  final int totalRecords;
  final int successCount;
  final int failureCount;
  final List<String> failedRecordIds;
  final List<String> errors;

  bool get allSucceeded => failureCount == 0;
  bool get anyFailed => failureCount > 0;
}

/// Sync operation result
class SyncResult {
  final bool success;
  final int recordsPushed;
  final int recordsPulled;
  final int conflicts;
  final List<String> errors;
  final DateTime syncTime;

  SyncResult({
    required this.success,
    this.recordsPushed = 0,
    this.recordsPulled = 0,
    this.conflicts = 0,
    this.errors = const [],
    required this.syncTime,
  });
}
```

### CloudKit Record Schema

**CloudKit record types (created in iCloud Dashboard):**

**Todo Record:**
```
RecordType: "Todo"
Fields:
  - id: String (indexed)
  - title: String
  - description: String
  - dueDate: Date
  - isCompleted: Boolean
  - completedAt: Date
  - listId: String (reference to TodoList)
  - recurrenceRule: String (JSON serialized)
  - reminderEnabled: Boolean
  - reminderOffset: Int
  - reminderUnit: String
  - originalTodoId: String
  - isDeleted: Boolean (indexed)
  - deletedAt: Date
  - createdAt: Date (indexed)
  - updatedAt: Date (indexed)
  - deviceId: String
```

**TodoList Record:**
```
RecordType: "TodoList"
Fields:
  - id: String (indexed)
  - name: String
  - color: Int (Color.value)
  - icon: String
  - isDeleted: Boolean (indexed)
  - deletedAt: Date
  - createdAt: Date (indexed)
  - updatedAt: Date (indexed)
  - deviceId: String
```

**Reminder Record:**
```
RecordType: "Reminder"
Fields:
  - id: String (indexed)
  - todoId: String (reference to Todo)
  - reminderTime: Date
  - isTriggered: Boolean
  - isDismissed: Boolean
  - isSnoozed: Boolean
  - snoozeUntil: Date
  - isDeleted: Boolean (indexed)
  - deletedAt: Date
  - createdAt: Date (indexed)
  - updatedAt: Date (indexed)
```

### Testing Checklist

- [ ] Interface compiles without errors
- [ ] All return types properly defined
- [ ] CloudRecord can serialize/deserialize
- [ ] SyncResult provides useful information
- [ ] BatchResult tracks successes and failures

## Phase 3: iOS Platform Channel Implementation

### Goals
- Create Flutter platform channel for CloudKit
- Implement iOS native CloudKit handler in Swift
- Handle account status, records, and subscriptions

### Flutter Platform Channel

**File: `lib/infrastructure/sync/cloudkit_sync_service.dart`**

```dart
import 'package:flutter/services.dart';
import '../../domain/services/i_cloud_sync_service.dart';

class CloudKitSyncService implements ICloudSyncService {
  static const platform = MethodChannel('com.yourapp.todo/cloudkit');

  @override
  Future<bool> initialize() async {
    try {
      final result = await platform.invokeMethod<bool>('initialize');
      return result ?? false;
    } on PlatformException catch (e) {
      print('CloudKit initialize error: ${e.message}');
      return false;
    }
  }

  @override
  Future<bool> isSignedIn() async {
    final status = await getAccountStatus();
    return status == CloudAccountStatus.available;
  }

  @override
  Future<CloudAccountStatus> getAccountStatus() async {
    try {
      final result = await platform.invokeMethod<String>('getAccountStatus');
      return _parseAccountStatus(result ?? 'couldNotDetermine');
    } on PlatformException catch (e) {
      print('CloudKit account status error: ${e.message}');
      return CloudAccountStatus.couldNotDetermine;
    }
  }

  @override
  Future<bool> pushRecord(String recordType, Map<String, dynamic> data) async {
    try {
      final result = await platform.invokeMethod<bool>(
        'pushRecord',
        {
          'recordType': recordType,
          'data': data,
        },
      );
      return result ?? false;
    } on PlatformException catch (e) {
      print('CloudKit push record error: ${e.message}');
      return false;
    }
  }

  @override
  Future<List<CloudRecord>> fetchRecordsSince(String recordType, DateTime? since) async {
    try {
      final result = await platform.invokeMethod<List<dynamic>>(
        'fetchRecordsSince',
        {
          'recordType': recordType,
          'since': since?.millisecondsSinceEpoch,
        },
      );

      if (result == null) return [];

      return result.map((json) => CloudRecord(
        id: json['id'] as String,
        recordType: json['recordType'] as String,
        fields: Map<String, dynamic>.from(json['fields']),
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
        isDeleted: json['isDeleted'] ?? false,
      )).toList();
    } on PlatformException catch (e) {
      print('CloudKit fetch records error: ${e.message}');
      return [];
    }
  }

  CloudAccountStatus _parseAccountStatus(String status) {
    switch (status) {
      case 'available':
        return CloudAccountStatus.available;
      case 'noAccount':
        return CloudAccountStatus.noAccount;
      case 'restricted':
        return CloudAccountStatus.restricted;
      case 'temporarilyUnavailable':
        return CloudAccountStatus.temporarilyUnavailable;
      default:
        return CloudAccountStatus.couldNotDetermine;
    }
  }
}
```

### iOS Native Implementation

**File: `ios/Runner/CloudKitHandler.swift`**

```swift
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
            name: "com.yourapp.todo/cloudkit",
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
        case "fetchRecordsSince":
            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
                return
            }
            fetchRecordsSince(args: args, result: result)
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
        // ... map all other fields
    }

    private func mapRecordToData(record: CKRecord) -> [String: Any] {
        var data: [String: Any] = [:]

        data["id"] = record.recordID.recordName
        data["recordType"] = record.recordType
        data["createdAt"] = Int64(record.creationDate?.timeIntervalSince1970 ?? 0) * 1000
        data["updatedAt"] = Int64(record.modificationDate?.timeIntervalSince1970 ?? 0) * 1000

        var fields: [String: Any] = [:]
        // Extract all fields from CKRecord
        for key in record.allKeys() {
            if let value = record[key] {
                fields[key] = convertCKValue(value)
            }
        }
        data["fields"] = fields

        return data
    }

    private func convertCKValue(_ value: Any) -> Any {
        if let date = value as? Date {
            return Int64(date.timeIntervalSince1970 * 1000)
        }
        return value
    }
}
```

**Register plugin in AppDelegate:**

```swift
// ios/Runner/AppDelegate.swift
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Register CloudKit handler
    CloudKitHandler.register(with: registrar(forPlugin: "CloudKitHandler")!)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### Xcode Configuration

**Required capabilities in Xcode:**
1. Open `ios/Runner.xcworkspace`
2. Select Runner target → Signing & Capabilities
3. Add capability: "iCloud"
4. Enable: "CloudKit"
5. Select or create container: `iCloud.com.yourapp.todo`
6. Add capability: "Background Modes"
7. Enable: "Remote notifications"

**Info.plist additions:**
```xml
<key>NSUbiquitousContainers</key>
<dict>
    <key>iCloud.com.yourapp.todo</key>
    <dict>
        <key>NSUbiquitousContainerIsDocumentScopePublic</key>
        <false/>
        <key>NSUbiquitousContainerName</key>
        <string>Todo App</string>
        <key>NSUbiquitousContainerSupportedFolderLevels</key>
        <string>Any</string>
    </dict>
</dict>
```

### Testing Checklist

- [ ] Platform channel registered successfully
- [ ] Can check iCloud account status
- [ ] Can push a test record to CloudKit
- [ ] Can fetch records from CloudKit
- [ ] Error handling works correctly
- [ ] App doesn't crash when not signed into iCloud

## Phase 4: Sync Coordinator Service

### Goals
- Orchestrate bidirectional sync between Drift and CloudKit
- Handle conflict resolution
- Implement sync strategies (push, pull, full sync)
- Trigger sync at appropriate times

### Sync Coordinator Implementation

**File: `lib/application/services/sync_coordinator_service.dart`**

```dart
class SyncCoordinatorService {
  final ITodoRepository _todoRepository;
  final ITodoListRepository _todoListRepository;
  final IReminderRepository _reminderRepository;
  final ICloudSyncService _cloudSync;

  bool _isSyncing = false;
  DateTime? _lastSyncTime;

  SyncCoordinatorService(
    this._todoRepository,
    this._todoListRepository,
    this._reminderRepository,
    this._cloudSync,
  );

  /// Check if sync is available (user signed into iCloud)
  Future<bool> isSyncAvailable() async {
    return await _cloudSync.isSignedIn();
  }

  /// Perform full bidirectional sync
  Future<SyncResult> performFullSync() async {
    if (_isSyncing) {
      return SyncResult(
        success: false,
        errors: ['Sync already in progress'],
        syncTime: DateTime.now(),
      );
    }

    if (!await isSyncAvailable()) {
      return SyncResult(
        success: false,
        errors: ['iCloud not available'],
        syncTime: DateTime.now(),
      );
    }

    _isSyncing = true;

    try {
      int pulled = 0;
      int pushed = 0;
      int conflicts = 0;

      // Step 1: Pull changes from CloudKit first
      final pullResult = await _pullAllChanges();
      pulled = pullResult.recordCount;
      conflicts = pullResult.conflicts;

      // Step 2: Push local changes to CloudKit
      final pushResult = await _pushAllChanges();
      pushed = pushResult.recordCount;

      _lastSyncTime = DateTime.now();

      return SyncResult(
        success: true,
        recordsPulled: pulled,
        recordsPushed: pushed,
        conflicts: conflicts,
        syncTime: _lastSyncTime!,
      );
    } catch (e) {
      return SyncResult(
        success: false,
        errors: [e.toString()],
        syncTime: DateTime.now(),
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Pull changes from CloudKit
  Future<_PullResult> _pullAllChanges() async {
    int recordCount = 0;
    int conflicts = 0;

    // Pull TodoLists first (todos reference them)
    final cloudLists = await _cloudSync.fetchRecordsSince('TodoList', _lastSyncTime);
    for (final cloudList in cloudLists) {
      final resolved = await _syncTodoList(cloudList);
      recordCount++;
      if (resolved == _SyncAction.conflict) conflicts++;
    }

    // Pull Todos
    final cloudTodos = await _cloudSync.fetchRecordsSince('Todo', _lastSyncTime);
    for (final cloudTodo in cloudTodos) {
      final resolved = await _syncTodo(cloudTodo);
      recordCount++;
      if (resolved == _SyncAction.conflict) conflicts++;
    }

    // Pull Reminders
    final cloudReminders = await _cloudSync.fetchRecordsSince('Reminder', _lastSyncTime);
    for (final cloudReminder in cloudReminders) {
      final resolved = await _syncReminder(cloudReminder);
      recordCount++;
      if (resolved == _SyncAction.conflict) conflicts++;
    }

    return _PullResult(recordCount: recordCount, conflicts: conflicts);
  }

  /// Push local changes to CloudKit
  Future<_PushResult> _pushAllChanges() async {
    int recordCount = 0;

    // Push TodoLists
    final listsToSync = await _todoListRepository.getTodoListsNeedingSync();
    for (final list in listsToSync) {
      final success = await _cloudSync.pushRecord('TodoList', list.toMap());
      if (success) {
        await _todoListRepository.markTodoListAsSynced(list.id, DateTime.now());
        recordCount++;
      }
    }

    // Push Todos
    final todosToSync = await _todoRepository.getTodosNeedingSync();
    for (final todo in todosToSync) {
      final success = await _cloudSync.pushRecord('Todo', todo.toMap());
      if (success) {
        await _todoRepository.markTodoAsSynced(todo.id, DateTime.now());
        recordCount++;
      }
    }

    // Push Reminders
    final remindersToSync = await _reminderRepository.getRemindersNeedingSync();
    for (final reminder in remindersToSync) {
      final success = await _cloudSync.pushRecord('Reminder', reminder.toMap());
      if (success) {
        await _reminderRepository.markReminderAsSynced(reminder.id, DateTime.now());
        recordCount++;
      }
    }

    return _PushResult(recordCount: recordCount);
  }

  /// Sync a single todo (conflict resolution)
  Future<_SyncAction> _syncTodo(CloudRecord cloudRecord) async {
    final fields = cloudRecord.fields;
    final cloudTodo = Todo.fromMap(fields);

    // Check if exists locally
    final localTodo = await _todoRepository.getTodoById(cloudTodo.id);

    if (localTodo == null) {
      // New record from cloud → insert locally
      await _todoRepository.createTodo(cloudTodo);
      return _SyncAction.inserted;
    }

    // Exists locally → check for conflicts
    if (cloudTodo.updatedAt.isAfter(localTodo.updatedAt)) {
      // Cloud is newer → update local
      await _todoRepository.updateTodo(cloudTodo);
      return _SyncAction.updated;
    } else if (localTodo.updatedAt.isAfter(cloudTodo.updatedAt)) {
      // Local is newer → will be pushed in next phase
      return _SyncAction.localNewer;
    } else {
      // Same timestamp → conflict (prefer local)
      return _SyncAction.conflict;
    }
  }

  /// Sync a single todo list
  Future<_SyncAction> _syncTodoList(CloudRecord cloudRecord) async {
    // Similar to _syncTodo
    // ... implementation
    return _SyncAction.inserted;
  }

  /// Sync a single reminder
  Future<_SyncAction> _syncReminder(CloudRecord cloudRecord) async {
    // Similar to _syncTodo
    // ... implementation
    return _SyncAction.inserted;
  }
}

enum _SyncAction {
  inserted,
  updated,
  localNewer,
  conflict,
}

class _PullResult {
  final int recordCount;
  final int conflicts;
  _PullResult({required this.recordCount, required this.conflicts});
}

class _PushResult {
  final int recordCount;
  _PushResult({required this.recordCount});
}
```

### Sync Triggers

**When to trigger sync:**

1. **App Launch** - Initial sync
```dart
// In main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  final container = ProviderContainer();
  final syncService = container.read(syncCoordinatorServiceProvider);

  // Initial sync (don't block app startup)
  syncService.performFullSync();

  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
}
```

2. **App Foreground** - Catch up on changes
```dart
class AppLifecycleObserver extends WidgetsBindingObserver {
  final SyncCoordinatorService _syncService;

  AppLifecycleObserver(this._syncService);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncService.performFullSync();
    }
  }
}
```

3. **After Local Changes** - Immediate push
```dart
// In TodoService after create/update/delete
Future<void> createTodo(Todo todo) async {
  await _repository.createTodo(todo);

  // Trigger sync (non-blocking)
  _syncCoordinator.performFullSync();
}
```

4. **Periodic Background** - Every 15 minutes
```dart
class PeriodicSyncService {
  Timer? _timer;
  final SyncCoordinatorService _syncService;

  void startPeriodicSync() {
    _timer = Timer.periodic(Duration(minutes: 15), (_) {
      _syncService.performFullSync();
    });
  }

  void stopPeriodicSync() {
    _timer?.cancel();
  }
}
```

5. **Manual** - Pull to refresh
```dart
// In TodoListScreen
RefreshIndicator(
  onRefresh: () async {
    final syncService = ref.read(syncCoordinatorServiceProvider);
    await syncService.performFullSync();
  },
  child: ListView(...),
)
```

### Dependency Injection

**Update dependency_injection.dart:**

```dart
/// Provider for CloudKit sync service
final cloudSyncServiceProvider = Provider<ICloudSyncService>((ref) {
  return CloudKitSyncService();
});

/// Provider for sync coordinator
final syncCoordinatorServiceProvider = Provider<SyncCoordinatorService>((ref) {
  final todoRepo = ref.watch(todoRepositoryProvider);
  final listRepo = ref.watch(todoListRepositoryProvider);
  final reminderRepo = ref.watch(reminderRepositoryProvider);
  final cloudSync = ref.watch(cloudSyncServiceProvider);

  return SyncCoordinatorService(
    todoRepo,
    listRepo,
    reminderRepo,
    cloudSync,
  );
});
```

### Testing Checklist

- [ ] Full sync completes without errors
- [ ] Pull changes from CloudKit updates local DB
- [ ] Push changes to CloudKit succeeds
- [ ] Conflict resolution uses last-write-wins
- [ ] Soft deletes sync correctly
- [ ] Sync triggers work (app launch, foreground, manual)
- [ ] App doesn't block during sync
- [ ] Sync status visible to user

## Phase 5: CloudKit Push Notifications

### Goals
- Subscribe to CloudKit change notifications
- Handle remote notifications when other devices change data
- Trigger sync when notifications received

### Implementation

**iOS Setup:**
- Enable Remote Notifications capability
- Handle APNs token registration
- Subscribe to CloudKit record changes

**Flutter Integration:**
- Listen for remote notifications
- Trigger sync when notification received
- Show sync status to user

### Testing Checklist

- [ ] Notifications registered with APNs
- [ ] CloudKit subscriptions created
- [ ] Receive notification when other device changes data
- [ ] Sync triggered automatically
- [ ] Changes appear on device

## Phase 6: Error Handling & Edge Cases

### Scenarios to Handle

1. **No iCloud Account**
   - Detect and show message to user
   - App continues working offline-only

2. **iCloud Storage Full**
   - Detect quota exceeded error
   - Notify user gracefully

3. **Network Unavailable**
   - Queue changes for later sync
   - Don't block user operations

4. **Concurrent Modifications**
   - Last-write-wins conflict resolution
   - Consider user notification for conflicts

5. **Data Corruption**
   - Validate data before accepting from CloudKit
   - Rollback on error

6. **Partial Sync Failures**
   - Track which records failed
   - Retry on next sync

### Testing Checklist

- [ ] App works without iCloud
- [ ] Graceful degradation when offline
- [ ] Error messages are user-friendly
- [ ] No data loss scenarios
- [ ] Recovery from failures

## Phase 7: Performance Optimization

### Optimizations

1. **Batch Operations**
   - Push/pull multiple records at once
   - Reduce network round trips

2. **Incremental Sync**
   - Only sync changes since last sync
   - Use CKQueryOperation for efficient queries

3. **Background Sync**
   - Don't block UI during sync
   - Show progress indicator

4. **Throttling**
   - Batch rapid changes (e.g., typing)
   - Debounce sync triggers

### Testing Checklist

- [ ] Sync completes in reasonable time
- [ ] UI remains responsive during sync
- [ ] Network usage is efficient
- [ ] Battery usage is acceptable

## Migration Path for Existing Users

### Strategy

1. **Initial Sync**: Mark all existing records as `needsSync=true`
2. **First Launch**: Perform full push to CloudKit
3. **Subsequent Syncs**: Incremental only
4. **Conflict Resolution**: If CloudKit has data, show user option to merge or replace

### Rollout Plan

1. **Phase 1**: Test with TestFlight beta users
2. **Phase 2**: Gradual rollout (10% → 50% → 100%)
3. **Monitor**: Track sync success rates, errors
4. **Support**: Help users resolve sync issues

## Security & Privacy

### Considerations

1. **Data Encryption**: CloudKit encrypts data at rest and in transit
2. **Access Control**: Only user can access their own data
3. **Privacy**: iCloud data stays in user's account
4. **Compliance**: No data sent to third-party servers

## Future Enhancements

1. **Shared Lists**: Use CKShare for collaboration
2. **Public Todos**: Use public database for shared templates
3. **Attachments**: Store files in CloudKit assets
4. **Rich Sync Status**: Show detailed sync progress
5. **Manual Conflict Resolution**: Let user choose which version to keep

## Success Metrics

- [ ] Sync success rate > 95%
- [ ] Average sync time < 3 seconds
- [ ] No data loss scenarios
- [ ] User satisfaction with sync reliability
- [ ] Low support ticket volume for sync issues

## Timeline Estimate

- Phase 1 (Soft Deletes): 1-2 days
- Phase 2 (Interface): 1 day
- Phase 3 (iOS Platform): 2-3 days
- Phase 4 (Sync Coordinator): 2-3 days
- Phase 5 (Notifications): 1-2 days
- Phase 6 (Error Handling): 1-2 days
- Phase 7 (Optimization): 1-2 days
- **Total: 9-15 days** (depending on testing and iteration)

## Resources

- [CloudKit Documentation](https://developer.apple.com/documentation/cloudkit)
- [CloudKit Best Practices](https://developer.apple.com/videos/play/wwdc2021/10086/)
- [Platform Channels in Flutter](https://docs.flutter.dev/platform-integration/platform-channels)
- [Drift Database Migrations](https://drift.simonbinder.eu/docs/migrations/)
