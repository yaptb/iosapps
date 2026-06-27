import 'dart:developer' as developer;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../domain/services/i_notification_service.dart';

/// Local notification service implementation using flutter_local_notifications
///
/// Handles scheduling and managing local notifications for both iOS and Android.
/// Includes comprehensive error handling to gracefully degrade if permissions denied.
class LocalNotificationService implements INotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Android notification channel for reminders
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'todo_reminders',
    'Todo Reminders',
    description: 'Notifications for todo item reminders',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  @override
  Future<bool> initialize() async {
    if (_isInitialized) {
      return true;
    }

    try {
      // Android initialization settings
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      final iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false, // We'll request permissions separately
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
      );

      final initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize the plugin
      final result = await _plugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (result == true) {
        // Create Android notification channel
        await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(_androidChannel);

        _isInitialized = true;
        developer.log('LocalNotificationService initialized successfully');
        return true;
      } else {
        developer.log('LocalNotificationService initialization failed');
        return false;
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error initializing notification service',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  @override
  Future<bool> hasPermission() async {
    try {
      // Check iOS permissions
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosPlugin != null) {
        final granted = await iosPlugin.requestPermissions(
          alert: false,
          badge: false,
          sound: false,
        );
        return granted ?? false;
      }

      // Check Android permissions (API 33+)
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final granted = await androidPlugin.areNotificationsEnabled();
        return granted ?? false;
      }

      // Default to true for older Android versions
      return true;
    } catch (e) {
      developer.log('Error checking notification permissions: $e');
      return false;
    }
  }

  @override
  Future<bool> requestPermissions() async {
    try {
      // Request iOS permissions
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosPlugin != null) {
        final granted = await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        developer.log('iOS notification permissions granted: $granted');
        return granted ?? false;
      }

      // Request Android permissions (API 33+)
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final granted = await androidPlugin.requestNotificationsPermission();
        developer.log('Android notification permissions granted: $granted');
        return granted ?? true; // Default to true for older Android
      }

      return true;
    } catch (e) {
      developer.log('Error requesting notification permissions: $e');
      return false;
    }
  }

  @override
  Future<bool> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    // Ensure service is initialized
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        developer.log('Cannot schedule notification: service not initialized');
        return false;
      }
    }

    // Check permissions before scheduling
    final hasPerms = await hasPermission();
    if (!hasPerms) {
      developer.log(
        'Cannot schedule notification: permissions not granted',
      );
      return false;
    }

    try {
      // Convert to timezone-aware datetime
      final tz.TZDateTime scheduledTZ = tz.TZDateTime.from(
        scheduledDate,
        tz.local,
      );

      // Create notification details
      final androidDetails = AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Schedule the notification
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTZ,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );

      developer.log(
        'Scheduled notification $id for ${scheduledTZ.toString()}',
      );
      return true;
    } catch (e, stackTrace) {
      developer.log(
        'Error scheduling notification $id',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  @override
  Future<void> cancelNotification(int id) async {
    try {
      await _plugin.cancel(id);
      developer.log('Cancelled notification $id');
    } catch (e) {
      developer.log('Error cancelling notification $id: $e');
    }
  }

  @override
  Future<void> cancelAllNotifications() async {
    try {
      await _plugin.cancelAll();
      developer.log('Cancelled all notifications');
    } catch (e) {
      developer.log('Error cancelling all notifications: $e');
    }
  }

  /// Handle iOS foreground notification (iOS <10)
  void _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    developer.log('Received iOS foreground notification: $id');
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    developer.log(
      'Notification tapped: ${response.id}, payload: ${response.payload}',
    );
    // TODO: Add navigation logic when user taps notification
    // This will be implemented later to navigate to the specific todo detail
  }
}
