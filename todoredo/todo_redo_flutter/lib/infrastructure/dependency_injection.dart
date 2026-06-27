import 'package:riverpod/riverpod.dart';
import '../application/services/recurrence_service.dart';
import '../application/services/reminder_service.dart';
import '../application/services/sync_coordinator_service.dart';
import '../application/services/todo_list_service.dart';
import '../application/services/todo_service.dart';
import '../domain/repositories/i_reminder_repository.dart';
import '../domain/repositories/i_todo_list_repository.dart';
import '../domain/repositories/i_todo_repository.dart';
import '../domain/services/i_cloud_sync_service.dart';
import '../domain/services/i_notification_service.dart';
import 'config/debug_config.dart';
import 'notifications/local_notification_service.dart';
import 'persistence/drift/database.dart';
import 'persistence/drift_reminder_repository.dart';
import 'persistence/drift_todo_list_repository.dart';
import 'persistence/drift_todo_repository.dart';
import 'sync/cloudkit_sync_service.dart';
import 'sync/mock_cloud_sync_service.dart';

/// Provider for the Drift database
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// Provider for the todo repository
final todoRepositoryProvider = Provider<ITodoRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return DriftTodoRepository(database);
});

/// Provider for the reminder repository
final reminderRepositoryProvider = Provider<IReminderRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return DriftReminderRepository(database);
});

/// Provider for the notification service
final notificationServiceProvider = Provider<INotificationService>((ref) {
  return LocalNotificationService();
});

/// Provider for the reminder service
final reminderServiceProvider = Provider<ReminderService>((ref) {
  final repository = ref.watch(reminderRepositoryProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  return ReminderService(repository, notificationService);
});

/// Provider for the recurrence service
final recurrenceServiceProvider = Provider<RecurrenceService>((ref) {
  return RecurrenceService();
});

/// Provider for the todo service
final todoServiceProvider = Provider<TodoService>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  final reminderService = ref.watch(reminderServiceProvider);
  final recurrenceService = ref.watch(recurrenceServiceProvider);
  return TodoService(repository, reminderService, recurrenceService);
});

/// Provider for the todo list repository
final todoListRepositoryProvider = Provider<ITodoListRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return DriftTodoListRepository(database);
});

/// Provider for the todo list service
final todoListServiceProvider = Provider<TodoListService>((ref) {
  final repository = ref.watch(todoListRepositoryProvider);
  final todoRepository = ref.watch(todoRepositoryProvider);
  final reminderService = ref.watch(reminderServiceProvider);
  return TodoListService(repository, todoRepository, reminderService);
});

/// Provider for CloudKit sync service
///
/// Returns MockCloudSyncService when CloudKit is disabled in debug config,
/// otherwise returns the real CloudKitSyncService.
final cloudSyncServiceProvider = Provider<ICloudSyncService>((ref) {
  if (DebugConfig.kEnableCloudKitSync) {
    return CloudKitSyncService();
  } else {
    return MockCloudSyncService();
  }
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
