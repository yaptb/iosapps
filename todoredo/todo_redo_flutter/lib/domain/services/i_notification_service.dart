/// A notification currently scheduled with the OS, as reported by the
/// underlying notification plugin.
class PendingNotificationInfo {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  const PendingNotificationInfo({
    required this.id,
    this.title,
    this.body,
    this.payload,
  });
}

/// Abstract interface for notification services
///
/// Defines the contract for scheduling and managing local notifications.
/// Implementations should handle platform-specific notification behavior.
abstract class INotificationService {
  /// Initialize the notification service
  ///
  /// Should be called once when the app starts.
  /// Returns true on success; throws a descriptive error on failure rather
  /// than returning false, so callers can surface the real reason.
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
  /// Returns true on success; throws a descriptive error on failure
  /// (e.g. permission not granted, or a native scheduling error) rather
  /// than returning false, so callers can surface the real reason.
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

  /// List all notifications currently scheduled with the OS.
  ///
  /// Used for diagnostics — comparing this against what the app believes
  /// should be scheduled is how a silent scheduling failure gets caught.
  Future<List<PendingNotificationInfo>> getPendingNotifications();

  /// Set the app's home-screen icon badge count directly, independent of
  /// showing/scheduling any notification. Best-effort: failures are logged
  /// but never thrown, since a badge-count mismatch should never block or
  /// crash anything else in the app.
  Future<void> setBadgeCount(int count);
}
