/// Abstract interface for notification services
///
/// Defines the contract for scheduling and managing local notifications.
/// Implementations should handle platform-specific notification behavior.
abstract class INotificationService {
  /// Initialize the notification service
  ///
  /// Should be called once when the app starts.
  /// Returns true if initialization successful, false otherwise.
  Future<bool> initialize();

  /// Check if notification permissions are granted
  ///
  /// Returns true if the app has permission to show notifications.
  Future<bool> hasPermission();

  /// Request notification permissions from the user
  ///
  /// On iOS, this will show the system permission dialog.
  /// On Android API 33+, this will also show a permission dialog.
  /// Returns true if permissions are granted, false otherwise.
  Future<bool> requestPermissions();

  /// Schedule a notification to be shown at a specific time
  ///
  /// [id] - Unique identifier for the notification
  /// [title] - The notification title
  /// [body] - The notification body/content
  /// [scheduledDate] - When to show the notification
  /// [payload] - Optional data to pass when notification is tapped
  ///
  /// Returns true if scheduling successful, false otherwise.
  /// Will fail if permissions are not granted.
  Future<bool> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  });

  /// Cancel a scheduled notification
  ///
  /// [id] - The unique identifier of the notification to cancel
  Future<void> cancelNotification(int id);

  /// Cancel all scheduled notifications
  Future<void> cancelAllNotifications();
}
