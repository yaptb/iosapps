import 'package:flutter/services.dart';
import '../../domain/services/i_cloud_sync_service.dart';

class CloudKitSyncService implements ICloudSyncService {
  static const platform = MethodChannel('com.parsecxr.todoredo/cloudkit');

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
  Future<BatchResult> pushRecordsBatch(
      String recordType, List<Map<String, dynamic>> records) async {
    try {
      final result = await platform.invokeMethod<Map<dynamic, dynamic>>(
        'pushRecordsBatch',
        {
          'recordType': recordType,
          'records': records,
        },
      );

      if (result == null) {
        return BatchResult(
          totalRecords: records.length,
          successCount: 0,
          failureCount: records.length,
          errors: ['No result from platform'],
        );
      }

      return BatchResult(
        totalRecords: result['totalRecords'] as int,
        successCount: result['successCount'] as int,
        failureCount: result['failureCount'] as int,
        failedRecordIds: List<String>.from(result['failedRecordIds'] ?? []),
        errors: List<String>.from(result['errors'] ?? []),
      );
    } on PlatformException catch (e) {
      print('CloudKit push records batch error: ${e.message}');
      return BatchResult(
        totalRecords: records.length,
        successCount: 0,
        failureCount: records.length,
        errors: [e.message ?? 'Unknown error'],
      );
    }
  }

  @override
  Future<List<CloudRecord>> fetchRecordsSince(
      String recordType, DateTime? since) async {
    try {
      final result = await platform.invokeMethod<List<dynamic>>(
        'fetchRecordsSince',
        {
          'recordType': recordType,
          'since': since?.millisecondsSinceEpoch,
        },
      );

      if (result == null) return [];

      return result
          .map((json) => CloudRecord.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } on PlatformException catch (e) {
      print('CloudKit fetch records error: ${e.message}');
      return [];
    }
  }

  @override
  Future<CloudRecord?> fetchRecord(String recordType, String id) async {
    try {
      final result = await platform.invokeMethod<Map<dynamic, dynamic>>(
        'fetchRecord',
        {
          'recordType': recordType,
          'id': id,
        },
      );

      if (result == null) return null;

      return CloudRecord.fromJson(Map<String, dynamic>.from(result));
    } on PlatformException catch (e) {
      print('CloudKit fetch record error: ${e.message}');
      return null;
    }
  }

  @override
  Future<bool> deleteRecord(String recordType, String id) async {
    try {
      final result = await platform.invokeMethod<bool>(
        'deleteRecord',
        {
          'recordType': recordType,
          'id': id,
        },
      );
      return result ?? false;
    } on PlatformException catch (e) {
      print('CloudKit delete record error: ${e.message}');
      return false;
    }
  }

  @override
  Future<bool> subscribeToChanges(String recordType) async {
    try {
      final result = await platform.invokeMethod<bool>(
        'subscribeToChanges',
        {'recordType': recordType},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      print('CloudKit subscribe error: ${e.message}');
      return false;
    }
  }

  @override
  Future<bool> unsubscribeFromChanges(String recordType) async {
    try {
      final result = await platform.invokeMethod<bool>(
        'unsubscribeFromChanges',
        {'recordType': recordType},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      print('CloudKit unsubscribe error: ${e.message}');
      return false;
    }
  }

  @override
  Future<List<String>> getPendingChanges() async {
    try {
      final result = await platform.invokeMethod<List<dynamic>>(
        'getPendingChanges',
      );
      return result?.map((e) => e.toString()).toList() ?? [];
    } on PlatformException catch (e) {
      print('CloudKit get pending changes error: ${e.message}');
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
