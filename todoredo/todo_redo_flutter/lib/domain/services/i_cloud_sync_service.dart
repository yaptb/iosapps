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
  Future<BatchResult> pushRecordsBatch(
      String recordType, List<Map<String, dynamic>> records);

  /// Fetch all records of a type modified since a date
  Future<List<CloudRecord>> fetchRecordsSince(
      String recordType, DateTime? since);

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
  available, // Signed in, ready to sync
  noAccount, // Not signed into iCloud
  restricted, // Parental controls or restrictions
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recordType': recordType,
      'fields': fields,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isDeleted': isDeleted,
    };
  }

  factory CloudRecord.fromJson(Map<String, dynamic> json) {
    return CloudRecord(
      id: json['id'] as String,
      recordType: json['recordType'] as String,
      fields: Map<String, dynamic>.from(json['fields'] as Map),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
      isDeleted: json['isDeleted'] as bool? ?? false,
    );
  }
}

/// Result from batch operations
class BatchResult {
  final int totalRecords;
  final int successCount;
  final int failureCount;
  final List<String> failedRecordIds;
  final List<String> errors;

  BatchResult({
    required this.totalRecords,
    required this.successCount,
    required this.failureCount,
    this.failedRecordIds = const [],
    this.errors = const [],
  });

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

  @override
  String toString() {
    return 'SyncResult{success: $success, pushed: $recordsPushed, pulled: $recordsPulled, conflicts: $conflicts, errors: ${errors.length}}';
  }
}
