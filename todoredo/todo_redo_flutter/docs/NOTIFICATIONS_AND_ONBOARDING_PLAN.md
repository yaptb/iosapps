# Notifications and Onboarding Implementation Plan

## Overview

This document outlines the plan for implementing:
1. Local notifications for todo reminders
2. First-run onboarding wizard with permission requests
3. Error handling for notification permission issues
4. Debug tooling for development

## Core Features

### 1. Onboarding Wizard
- Runs on first app launch
- Requests all required permissions upfront
- Stores completion flag in SharedPreferences
- Can be forced to show via debug flag

### 2. Local Notifications
- Schedule notifications when reminders are created
- Cancel notifications when reminders are deleted
- Handle iOS and Android notification systems
- Graceful degradation when permissions denied

### 3. Error Handling
- All notification operations wrapped in try-catch blocks
- Permission checks before scheduling notifications
- App continues working even without notification permissions
- Reminders saved to database regardless of notification status

### 4. Debug Features
- Debug flag to force onboarding wizard on every launch
- Easy toggle for development vs production

## iOS Notification Deletion - CONFIRMED ✓

**iOS notifications WILL be deleted when reminders are deleted in the app.**

When `ReminderService.regenerateRemindersForTodo()` is called with `reminderEnabled=false`:
1. Deletes reminder records from database
2. Calls `NotificationService.cancelNotification(notificationId)`
3. `flutter_local_notifications` calls `UNUserNotificationCenter.removePendingNotificationRequests(withIdentifiers:)`
4. iOS removes the scheduled notification

**Note:** This only works for pending notifications (not yet fired). Delivered notifications would need different handling.

## Architecture

### Error Handling Flow
```dart
// In ReminderService
Future<void> regenerateRemindersForTodo(Todo todo) async {
  try {
    if (todo.reminderEnabled) {
      final hasPermission = await _notificationService.hasPermission();
      if (hasPermission) {
        await _notificationService.scheduleNotification(...);
      } else {
        // Silent failure - reminder saved, notification not scheduled
        // Could optionally log or show subtle indicator
      }
    }
  } catch (e) {
    // Log error, don't propagate
    // App continues working without notifications
  }
}
```

### Debug Flag Implementation
```dart
// lib/infrastructure/config/debug_config.dart
class DebugConfig {
  static const bool kForceOnboarding = true; // Set to false for production
}

// In main.dart or onboarding check
final hasCompletedOnboarding =
    !DebugConfig.kForceOnboarding &&
    prefs.getBool('onboarding_completed') ?? false;
```

### Notification Deletion Flow
```
Delete todo → TodoService.deleteTodo
→ ReminderService.regenerateRemindersForTodo(reminderEnabled=false)
→ NotificationService.cancelNotification(id)
→ iOS/Android removes scheduled notification
```

## Folder Structure

### New Files to Create

```
lib/
├── domain/
│   └── services/
│       └── i_notification_service.dart          [NEW]
│
├── infrastructure/
│   ├── config/
│   │   └── debug_config.dart                    [NEW]
│   └── notifications/
│       ├── local_notification_service.dart      [NEW]
│       └── notification_helpers.dart            [NEW]
│
└── presentation/
    └── screens/
        └── onboarding/
            ├── onboarding_screen.dart           [NEW]
            ├── pages/
            │   ├── welcome_page.dart            [NEW]
            │   ├── permissions_info_page.dart   [NEW]
            │   ├── permissions_request_page.dart [NEW]
            │   └── completion_page.dart         [NEW]
            └── widgets/
                └── onboarding_page_indicator.dart [NEW]
```

### Files to Update

```
lib/
├── infrastructure/
│   └── dependency_injection.dart                [UPDATE]
├── application/
│   └── services/
│       └── reminder_service.dart                [UPDATE]
└── main.dart                                    [UPDATE]
```

## Onboarding Wizard Structure

### Four-Page Scaffold

1. **Welcome Page** (Step 1)
   - Placeholder app name/logo
   - Brief welcome message
   - Next button

2. **Permissions Info Page** (Step 2)
   - Explain why permissions are needed
   - List of permissions to be requested
   - Benefits explanation
   - Next button

3. **Permissions Request Page** (Step 3)
   - Actual iOS/Android permission requests
   - Request notification permissions
   - Handle granted/denied states
   - Next button (enabled after permissions handled)

4. **Completion Page** (Step 4)
   - Success message
   - "Get Started" button
   - Saves completion flag to SharedPreferences
   - Navigates to main app

### Features
- PageView for navigation between pages
- Progress indicator (dots) showing current step
- Skip functionality with confirmation dialog
- Back navigation support
- Clean, simple Material Design UI
- Comments marking enhancement locations

## INotificationService Interface

```dart
abstract class INotificationService {
  /// Initialize the notification service
  Future<void> initialize();

  /// Check if notifications are permitted
  Future<bool> hasPermission();

  /// Request notification permissions
  Future<bool> requestPermissions();

  /// Schedule a notification
  Future<bool> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  });

  /// Cancel a scheduled notification
  Future<void> cancelNotification(int id);

  /// Cancel all notifications
  Future<void> cancelAllNotifications();
}
```

## Implementation Phases

### Phase 1: Infrastructure
1. Add `shared_preferences` to pubspec.yaml
2. Create `DebugConfig` with `kForceOnboarding` flag
3. Create `INotificationService` interface in domain layer
4. Create `LocalNotificationService` implementation with error handling
5. Add notification service to dependency injection

**Files created:**
- `lib/infrastructure/config/debug_config.dart`
- `lib/domain/services/i_notification_service.dart`
- `lib/infrastructure/notifications/local_notification_service.dart`

**Files updated:**
- `pubspec.yaml` (add shared_preferences)
- `lib/infrastructure/dependency_injection.dart` (add notificationServiceProvider)

### Phase 2: Onboarding Wizard Scaffold
1. Create onboarding screen structure (4 pages)
2. Add navigation logic using PageView
3. Add progress indicator widget
4. Implement SharedPreferences check for first run
5. Wire up debug flag to force showing wizard
6. Connect "Get Started" button to save completion flag

**Files created:**
- `lib/presentation/screens/onboarding/onboarding_screen.dart`
- `lib/presentation/screens/onboarding/pages/welcome_page.dart`
- `lib/presentation/screens/onboarding/pages/permissions_info_page.dart`
- `lib/presentation/screens/onboarding/pages/permissions_request_page.dart`
- `lib/presentation/screens/onboarding/pages/completion_page.dart`
- `lib/presentation/screens/onboarding/widgets/onboarding_page_indicator.dart`

**Files updated:**
- `lib/main.dart` (add onboarding check and routing)

### Phase 3: Permission Integration
1. Add permission request logic to `permissions_request_page.dart`
2. Initialize notification service in wizard
3. Request iOS/Android notification permissions
4. Handle permission granted/denied states
5. Add error handling for permission requests

**Files updated:**
- `lib/presentation/screens/onboarding/pages/permissions_request_page.dart`
- `lib/infrastructure/notifications/local_notification_service.dart`

### Phase 4: Notification System
1. Update `ReminderService` to inject and use `INotificationService`
2. Add try-catch blocks around all notification operations
3. Check permissions before scheduling notifications
4. Gracefully handle permission denials (save reminder, skip notification)
5. Schedule notifications when reminders created
6. Cancel notifications when reminders deleted

**Files updated:**
- `lib/application/services/reminder_service.dart`
- `lib/infrastructure/dependency_injection.dart` (inject notification service into reminder service)

### Phase 5: Testing
1. Test with debug flag enabled (wizard shows every launch)
2. Test with debug flag disabled (wizard shows only on first launch)
3. Test permission denial scenarios
4. Test notification scheduling and cancellation
5. Test reminder deletion cancels notifications
6. Verify app works without notification permissions
7. Test on physical iOS device (simulator doesn't support notifications)
8. Test on Android emulator/device

## Key Technical Details

### Notification ID Strategy
- Use reminder.id string hash as int for notification ID
- Consistent ID ensures updates replace old notifications
- Same ID used for cancellation

### Timezone Handling
- Use `timezone` package (already in dependencies)
- Convert all DateTimes to proper timezone
- Initialize timezone data in `main()`
- Handle daylight saving time transitions

### Permission Handling
- Request during onboarding wizard
- Check before every schedule operation
- Store permission status in SharedPreferences (optional)
- Handle permission denial gracefully
- Don't crash if permissions denied

### Platform-Specific Considerations

**iOS:**
- Requires explicit permission request
- Limited to 64 scheduled notifications
- No true background execution
- Notifications must be scheduled upfront
- Test on physical device (simulator doesn't support notifications)

**Android:**
- Notification channels required (API 26+)
- More flexible background execution
- Battery optimization may affect reliability
- Can schedule more notifications
- Emulator supports notifications

### Error Handling Strategy

1. **Permission Denied:**
   - Save reminder to database
   - Don't schedule notification
   - Log event
   - App continues normally

2. **Notification Scheduling Failed:**
   - Catch exception
   - Log error
   - Don't propagate to UI
   - Reminder still saved

3. **Service Not Initialized:**
   - Check initialization status
   - Initialize if needed
   - Retry operation
   - Fail gracefully if still fails

## Dependencies

### Already in pubspec.yaml
- `flutter_local_notifications: ^17.0.0`
- `timezone: ^0.9.0`
- `workmanager: ^0.5.2` (optional for background tasks)

### Need to Add
- `shared_preferences: ^2.2.0` (for onboarding completion flag)

## Future Enhancements (Post-Initial Implementation)

### Onboarding Wizard
- Add app feature tour with screenshots
- Add customization options (theme selection)
- Add option to import data
- Add analytics opt-in/out

### Notifications
- Notification action buttons (Complete, Snooze)
- Handle notification taps (deep linking to todo)
- Notification grouping by todo list
- Badge count for pending reminders (iOS)
- Custom notification sounds
- Priority/importance levels

### Background Tasks
- Implement workmanager for periodic notification refresh
- Reschedule notifications after device restart
- Handle past-due reminders
- Sync notifications with server (if cloud sync added)

## Testing Checklist

### Onboarding
- [ ] Wizard shows on first launch
- [ ] Debug flag forces wizard to show every time
- [ ] Wizard doesn't show after completion (debug flag off)
- [ ] All four pages render correctly
- [ ] Progress indicator updates correctly
- [ ] Skip button works with confirmation
- [ ] Back navigation works between pages
- [ ] Completion flag saved to SharedPreferences
- [ ] App navigates to main screen after completion

### Permissions
- [ ] Permission request dialog appears
- [ ] Permission granted state handled correctly
- [ ] Permission denied state handled gracefully
- [ ] App works without notification permissions
- [ ] Can request permissions again from settings

### Notifications
- [ ] Notification scheduled when reminder created
- [ ] Notification appears at correct time
- [ ] Notification contains correct todo info
- [ ] Notification canceled when reminder deleted
- [ ] Notification canceled when todo deleted
- [ ] Notification canceled when list deleted (all todos)
- [ ] Multiple notifications can be scheduled
- [ ] No crashes if permissions denied
- [ ] Timezone handling correct

### Error Handling
- [ ] App doesn't crash without permissions
- [ ] Reminders save even if notification scheduling fails
- [ ] Error logs generated for debugging
- [ ] UI remains responsive during errors
- [ ] No error messages shown to user for permission issues

### Platform-Specific
- [ ] iOS: Physical device testing completed
- [ ] iOS: Notification center integration works
- [ ] Android: Emulator testing completed
- [ ] Android: Notification channels configured
- [ ] Both platforms: Timezone handling correct

## Development Commands

```bash
# Add shared_preferences dependency
flutter pub add shared_preferences

# Generate code (if needed for any serialization)
flutter pub run build_runner build

# Run on iOS simulator (onboarding UI testing)
flutter run -d <simulator-id>

# Run on physical iPhone (notification testing)
flutter run -d <iphone-id>

# Run on Android emulator
flutter run -d <emulator-id>

# Clean and rebuild
flutter clean && flutter pub get && flutter run

# Check for issues
flutter analyze
```

## Notes

- **iOS Testing:** Notifications don't work in iOS simulator - must use physical device
- **Debug Flag:** Remember to set `kForceOnboarding = false` for production builds
- **Permissions:** Once denied, users must enable in device settings - provide guidance
- **Timezone:** Initialize timezone database in main() before any notification operations
- **Error Logging:** Consider adding proper logging service for production debugging

## Status

**Current Status:** Plan documented, awaiting implementation approval

**Next Action:** Begin Phase 1 implementation upon user confirmation
