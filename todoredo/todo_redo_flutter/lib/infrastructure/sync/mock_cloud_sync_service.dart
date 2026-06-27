import '../../domain/services/i_cloud_sync_service.dart';

/// Mock CloudKit sync service for testing or when CloudKit is disabled
///
/// This service returns safe default values and doesn't actually communicate
/// with CloudKit. Use this when:
/// - Testing in simulator (CloudKit doesn't work in simulator)
/// - Development mode with CloudKit disabled
/// - Running on non-iOS platforms
class MockCloudSyncService implements ICloudSyncService {
  @override
  Future<bool> initialize() async {
    // Mock: Always returns false (not available)
    return false;
  }

  @override
  Future<bool> isSignedIn() async {
    // Mock: Always returns false (not signed in)
    return false;
  }

  @override
  Future<CloudAccountStatus> getAccountStatus() async {
    // Mock: Always returns noAccount
    return CloudAccountStatus.noAccount;
  }

  @override
  Future<bool> pushRecord(String recordType, Map<String, dynamic> data) async {
    // Mock: Pretend success but don't actually push
    return true;
  }

  @override
  Future<BatchResult> pushRecordsBatch(
      String recordType, List<Map<String, dynamic>> records) async {
    // Mock: Return success for all records
    return BatchResult(
      totalRecords: records.length,
      successCount: records.length,
      failureCount: 0,
    );
  }

  @override
  Future<List<CloudRecord>> fetchRecordsSince(
      String recordType, DateTime? since) async {
    // Mock: Return empty list (no records)
    return [];
  }

  @override
  Future<CloudRecord?> fetchRecord(String recordType, String id) async {
    // Mock: Return null (record not found)
    return null;
  }

  @override
  Future<bool> deleteRecord(String recordType, String id) async {
    // Mock: Pretend success
    return true;
  }

  @override
  Future<bool> subscribeToChanges(String recordType) async {
    // Mock: Pretend success
    return true;
  }

  @override
  Future<bool> unsubscribeFromChanges(String recordType) async {
    // Mock: Pretend success
    return true;
  }

  @override
  Future<List<String>> getPendingChanges() async {
    // Mock: Return empty list (no pending changes)
    return [];
  }
}
