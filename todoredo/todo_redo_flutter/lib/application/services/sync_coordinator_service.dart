import '../../domain/entities/todo.dart';
import '../../domain/entities/todo_list.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/repositories/i_todo_repository.dart';
import '../../domain/repositories/i_todo_list_repository.dart';
import '../../domain/repositories/i_reminder_repository.dart';
import '../../domain/services/i_cloud_sync_service.dart';
import '../../infrastructure/config/debug_config.dart';
import 'dart:io' show Platform;

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

  /// Check if sync is available (user signed into iCloud and on iOS)
  Future<bool> isSyncAvailable() async {
    // Check debug flag first
    if (!DebugConfig.kEnableCloudKitSync) {
      return false;
    }

    // CloudKit is iOS-only
    if (!Platform.isIOS) {
      return false;
    }

    return await _cloudSync.isSignedIn();
  }

  /// Get account status
  Future<CloudAccountStatus> getAccountStatus() async {
    // Check debug flag first
    if (!DebugConfig.kEnableCloudKitSync) {
      return CloudAccountStatus.noAccount;
    }

    if (!Platform.isIOS) {
      return CloudAccountStatus.noAccount;
    }

    return await _cloudSync.getAccountStatus();
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
      List<String> errors = [];

      // Step 1: Pull changes from CloudKit first
      final pullResult = await _pullAllChanges();
      pulled = pullResult.recordCount;
      conflicts = pullResult.conflicts;
      errors.addAll(pullResult.errors);

      // Step 2: Push local changes to CloudKit
      final pushResult = await _pushAllChanges();
      pushed = pushResult.recordCount;
      errors.addAll(pushResult.errors);

      _lastSyncTime = DateTime.now();

      return SyncResult(
        success: errors.isEmpty,
        recordsPulled: pulled,
        recordsPushed: pushed,
        conflicts: conflicts,
        errors: errors,
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
    List<String> errors = [];

    try {
      // Pull TodoLists first (todos reference them)
      final cloudLists =
          await _cloudSync.fetchRecordsSince('TodoList', _lastSyncTime);
      for (final cloudList in cloudLists) {
        try {
          final resolved = await _syncTodoList(cloudList);
          recordCount++;
          if (resolved == _SyncAction.conflict) conflicts++;
        } catch (e) {
          errors.add('TodoList sync error: ${e.toString()}');
        }
      }

      // Pull Todos
      final cloudTodos =
          await _cloudSync.fetchRecordsSince('Todo', _lastSyncTime);
      for (final cloudTodo in cloudTodos) {
        try {
          final resolved = await _syncTodo(cloudTodo);
          recordCount++;
          if (resolved == _SyncAction.conflict) conflicts++;
        } catch (e) {
          errors.add('Todo sync error: ${e.toString()}');
        }
      }

      // Pull Reminders
      final cloudReminders =
          await _cloudSync.fetchRecordsSince('Reminder', _lastSyncTime);
      for (final cloudReminder in cloudReminders) {
        try {
          final resolved = await _syncReminder(cloudReminder);
          recordCount++;
          if (resolved == _SyncAction.conflict) conflicts++;
        } catch (e) {
          errors.add('Reminder sync error: ${e.toString()}');
        }
      }
    } catch (e) {
      errors.add('Pull error: ${e.toString()}');
    }

    return _PullResult(
        recordCount: recordCount, conflicts: conflicts, errors: errors);
  }

  /// Push local changes to CloudKit
  Future<_PushResult> _pushAllChanges() async {
    int recordCount = 0;
    List<String> errors = [];

    try {
      // Push TodoLists
      final listsToSync = await _todoListRepository.getTodoListsNeedingSync();
      for (final list in listsToSync) {
        try {
          final success = await _cloudSync.pushRecord('TodoList', list.toMap());
          if (success) {
            await _todoListRepository.markTodoListAsSynced(
                list.id, DateTime.now(), Platform.operatingSystem);
            recordCount++;
          } else {
            errors.add('Failed to push TodoList: ${list.id}');
          }
        } catch (e) {
          errors.add('TodoList push error: ${e.toString()}');
        }
      }

      // Push Todos
      final todosToSync = await _todoRepository.getTodosNeedingSync();
      for (final todo in todosToSync) {
        try {
          final success = await _cloudSync.pushRecord('Todo', todo.toMap());
          if (success) {
            await _todoRepository.markTodoAsSynced(
                todo.id, DateTime.now(), Platform.operatingSystem);
            recordCount++;
          } else {
            errors.add('Failed to push Todo: ${todo.id}');
          }
        } catch (e) {
          errors.add('Todo push error: ${e.toString()}');
        }
      }

      // Push Reminders
      final remindersToSync =
          await _reminderRepository.getRemindersNeedingSync();
      for (final reminder in remindersToSync) {
        try {
          final success =
              await _cloudSync.pushRecord('Reminder', reminder.toMap());
          if (success) {
            await _reminderRepository.markReminderAsSynced(
                reminder.id, DateTime.now(), Platform.operatingSystem);
            recordCount++;
          } else {
            errors.add('Failed to push Reminder: ${reminder.id}');
          }
        } catch (e) {
          errors.add('Reminder push error: ${e.toString()}');
        }
      }
    } catch (e) {
      errors.add('Push error: ${e.toString()}');
    }

    return _PushResult(recordCount: recordCount, errors: errors);
  }

  /// Sync a single todo (conflict resolution)
  Future<_SyncAction> _syncTodo(CloudRecord cloudRecord) async {
    final fields = cloudRecord.fields;
    final cloudTodo = Todo.fromMap(fields);

    // Check if exists locally
    final localTodo = await _todoRepository.getTodoById(cloudTodo.id);

    if (localTodo == null) {
      // New record from cloud → insert locally
      await _todoRepository.createTodo(
        cloudTodo.copyWith(needsSync: false), // Already synced
      );
      return _SyncAction.inserted;
    }

    // Exists locally → check for conflicts
    if (cloudTodo.updatedAt.isAfter(localTodo.updatedAt)) {
      // Cloud is newer → update local
      await _todoRepository.updateTodo(
        cloudTodo.copyWith(needsSync: false), // Already synced
      );
      return _SyncAction.updated;
    } else if (localTodo.updatedAt.isAfter(cloudTodo.updatedAt)) {
      // Local is newer → will be pushed in next phase
      return _SyncAction.localNewer;
    } else {
      // Same timestamp → conflict (prefer local, will sync on next push)
      return _SyncAction.conflict;
    }
  }

  /// Sync a single todo list
  Future<_SyncAction> _syncTodoList(CloudRecord cloudRecord) async {
    final fields = cloudRecord.fields;
    final cloudList = TodoList.fromMap(fields);

    final localList = await _todoListRepository.getTodoListById(cloudList.id);

    if (localList == null) {
      await _todoListRepository.createTodoList(
        cloudList.copyWith(needsSync: false),
      );
      return _SyncAction.inserted;
    }

    if (cloudList.updatedAt.isAfter(localList.updatedAt)) {
      await _todoListRepository.updateTodoList(
        cloudList.copyWith(needsSync: false),
      );
      return _SyncAction.updated;
    } else if (localList.updatedAt.isAfter(cloudList.updatedAt)) {
      return _SyncAction.localNewer;
    } else {
      return _SyncAction.conflict;
    }
  }

  /// Sync a single reminder
  Future<_SyncAction> _syncReminder(CloudRecord cloudRecord) async {
    final fields = cloudRecord.fields;
    final cloudReminder = Reminder.fromMap(fields);

    // For simplicity, we'll always accept cloud reminders
    // In a real app, you'd check if it exists and resolve conflicts
    await _reminderRepository.createReminder(
      cloudReminder.copyWith(needsSync: false),
    );
    return _SyncAction.inserted;
  }

  /// Get last sync time
  DateTime? get lastSyncTime => _lastSyncTime;

  /// Check if currently syncing
  bool get isSyncing => _isSyncing;
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
  final List<String> errors;
  _PullResult({
    required this.recordCount,
    required this.conflicts,
    this.errors = const [],
  });
}

class _PushResult {
  final int recordCount;
  final List<String> errors;
  _PushResult({
    required this.recordCount,
    this.errors = const [],
  });
}
