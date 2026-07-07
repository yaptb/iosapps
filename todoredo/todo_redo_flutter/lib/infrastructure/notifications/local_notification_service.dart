import 'dart:developer' as developer;
import 'package:flutter/services.dart';
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

  // flutter_local_notifications has no API to set the app icon badge count
  // independently of showing/scheduling a notification, so this uses a
  // small dedicated platform channel handled natively in AppDelegate.swift.
  static const MethodChannel _badgeChannel =
      MethodChannel('com.parsecxr.todoredo/badge');

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

      // Initialize the plugin.
      //
      // Note: on iOS, this call's own boolean result reflects whether the
      // plugin's *internal* permission request succeeded — but since we
      // deliberately pass requestAlertPermission/Badge/Sound: false above
      // (the actual permission prompt is requested separately via
      // requestPermissions()), the plugin's native implementation takes an
      // early "no permissions requested" branch that unconditionally
      // returns false, regardless of the app's real permission state. That
      // boolean is therefore not a meaningful success/failure signal here —
      // if this call doesn't throw, initialization succeeded.
      await _plugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Create Android notification channel
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_androidChannel);

      _isInitialized = true;
      developer.log('LocalNotificationService initialized successfully');
      return true;
    } catch (e, stackTrace) {
      developer.log(
        'Error initializing notification service',
        error: e,
        stackTrace: stackTrace,
      );
      // Rethrow (rather than swallowing into a bare `false`) so callers can
      // see and surface the real failure reason.
      rethrow;
    }
  }

  @override
  Future<bool> hasPermission() async {
    try {
      // Check iOS permissions
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosPlugin != null) {
        final options = await iosPlugin.checkPermissions();
        return options?.isEnabled ?? false;
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
    // Ensure service is initialized. initialize() now either succeeds or
    // throws a descriptive error (never a silent false), so a failure here
    // propagates naturally to the caller.
    if (!_isInitialized) {
      await initialize();
    }

    // Check permissions before scheduling
    final hasPerms = await hasPermission();
    if (!hasPerms) {
      const message = 'Cannot schedule notification: permissions not granted '
          '(checked internally at schedule time)';
      developer.log(message);
      throw StateError(message);
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

      // presentBanner/presentList (not presentAlert) control whether a
      // notification is shown while the app is in the foreground on iOS
      // 14+ — without these, foreground notifications fire "silently"
      // (no visible banner) while backgrounded ones still show normally,
      // since the foreground-presentation delegate isn't consulted then.
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        presentBanner: true,
        presentList: true,
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
      // Rethrow (rather than swallowing into a bare `false`) so callers can
      // see and surface the real failure reason instead of it only ever
      // being visible in device logs.
      rethrow;
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

  @override
  Future<List<PendingNotificationInfo>> getPendingNotifications() async {
    try {
      final pending = await _plugin.pendingNotificationRequests();
      return pending
          .map((request) => PendingNotificationInfo(
                id: request.id,
                title: request.title,
                body: request.body,
                payload: request.payload,
              ))
          .toList();
    } catch (e) {
      developer.log('Error fetching pending notifications: $e');
      return [];
    }
  }

  @override
  Future<void> setBadgeCount(int count) async {
    try {
      await _badgeChannel.invokeMethod('setBadgeCount', {'count': count});
    } catch (e, stackTrace) {
      developer.log(
        'Error setting badge count',
        error: e,
        stackTrace: stackTrace,
      );
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
