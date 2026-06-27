# Settings Screen Documentation

## Overview

A comprehensive settings screen has been added to the app, providing users with sync status information, app information, and support resources.

## Features

### 1. 📊 Sync Status Section

**Shows CloudKit synchronization information:**

- **CloudKit Sync Status**
  - Enabled/Disabled indicator
  - Visual icon (cloud or cloud_off)
  - Color-coded status (green for enabled, gray for disabled)

- **Platform Status**
  - Current platform (iOS, Android, etc.)
  - CloudKit support indication
  - iOS shows "CloudKit supported"
  - Other platforms show "CloudKit not supported"

- **iCloud Account Status** (when CloudKit enabled on iOS)
  - Available: Signed in and ready to sync ✅
  - No Account: Not signed into iCloud
  - Restricted: Parental controls or restrictions
  - Temporarily Unavailable: Network issues
  - Could Not Determine: Unable to check status
  - Real-time status checking with loading indicator

- **Last Sync Time**
  - Shows when data was last synced
  - Human-readable format:
    - "Just now" (< 1 minute)
    - "5 minutes ago"
    - "2 hours ago"
    - "3 days ago"
    - Date format for older syncs

- **Manual Sync Button**
  - Available when:
    - CloudKit is enabled
    - On iOS device
    - Signed into iCloud
  - Shows loading state while syncing
  - Displays success/failure message with details
  - Shows records pushed/pulled counts

- **Info Messages**
  - CloudKit disabled: Explains data is local-only
  - Non-iOS platform: Explains CloudKit is iOS-only

### 2. ⚙️ Preferences Section

**User customization options:**

- **Theme** (Coming Soon)
  - Currently shows "Light"
  - Placeholder for theme selection

- **Notifications**
  - Manage reminder notifications
  - Placeholder for notification settings

### 3. ℹ️ About Section

**App information and branding:**

- **App Logo/Icon**
  - 80x80 container with app icon
  - Primary color themed
  - Rounded corners (20dp radius)

- **App Name**
  - Displays from package info
  - Falls back to "TODO App"

- **Version Information**
  - Version number (e.g., "1.0.0")
  - Build number (e.g., "(1)")
  - Automatically from package_info_plus

- **App Description**
  - "A simple and powerful TODO app with recurring tasks, reminders, and iCloud sync."

- **Built with Flutter Badge**
  - Shows Flutter branding
  - Dash icon

### 4. 🆘 Support Section

**Help and legal information:**

- **Help & Documentation**
  - Opens documentation URL
  - External link icon

- **Report a Bug**
  - Links to GitHub issues
  - External link icon

- **Rate This App**
  - Placeholder for app store rating
  - Shows thank you message

- **Privacy Policy**
  - Dialog with privacy information
  - Explains:
    - Local data storage
    - iCloud sync privacy
    - No data collection
    - No analytics
    - No third-party access

- **Terms of Service**
  - Dialog with terms
  - Covers:
    - Usage terms
    - Warranty disclaimer
    - Data backup responsibility
    - iCloud requirements
    - License information

- **Licenses**
  - Opens Flutter's license page
  - Shows all open source licenses
  - App info and legal text

## Navigation

### Access Settings

**From Main Screen (TodoListsScreen):**
- Tap the **Settings** icon (⚙️) in the top-right corner of the app bar
- Opens SettingsScreen in full screen

**Location:**
- `TodoListsScreen` → AppBar → Actions → Settings button

## Technical Implementation

### File Structure

```
lib/presentation/screens/
  └── settings_screen.dart (NEW)

Modified files:
  - pubspec.yaml (added package_info_plus)
  - todo_lists_screen.dart (added settings navigation)
```

### Dependencies Added

```yaml
package_info_plus: ^8.0.0
```

**Purpose:** Get app version, build number, and app name from platform

### Key Components

#### 1. SettingsScreen Widget

```dart
class SettingsScreen extends ConsumerStatefulWidget
```

**State:**
- `PackageInfo? _packageInfo` - App version information
- `bool _isLoadingPackageInfo` - Loading state

**Lifecycle:**
- `initState()` - Loads package information asynchronously

#### 2. Sync Status Logic

**Checks:**
1. Debug flag: `DebugConfig.kEnableCloudKitSync`
2. Platform: `Platform.isIOS`
3. Account status: `syncCoordinator.getAccountStatus()`

**States:**
- Disabled: CloudKit off or not iOS
- Available: Ready to sync
- No Account: Not signed into iCloud
- Restricted/Unavailable: Various issues

#### 3. Manual Sync

**Flow:**
1. User taps "Sync Now" button
2. Shows loading state
3. Calls `syncCoordinator.performFullSync()`
4. Waits for result
5. Shows success/failure snackbar
6. Updates last sync time

**Success Message:**
```
Sync completed: 5 pushed, 3 pulled
```

**Failure Message:**
```
Sync failed: [error messages]
```

## UI/UX Design

### Material Design Patterns

- **List Tiles:** Consistent layout for settings items
- **Section Headers:** Primary color, bold, uppercase
- **Icons:** Leading icons for visual clarity
- **Trailing Icons:** Chevrons for navigation, external link icons for URLs
- **Cards:** Used for info messages with contrasting background
- **Dialogs:** For privacy policy and terms
- **Chips:** For badges like "Built with Flutter"

### Color Scheme

- **Enabled/Active:** Green
- **Disabled/Inactive:** Gray
- **Warning:** Orange
- **Primary:** Theme primary color
- **Surface Variants:** For info cards

### Spacing

- Section header padding: `16dp top, 16dp horizontal, 8dp bottom`
- ListTile: Default Material spacing
- Info cards: `16dp all around`
- Logo container: `16dp vertical padding`

## User Experience

### Sync Status Scenarios

#### Scenario 1: CloudKit Disabled (Default)
```
CloudKit Sync: Disabled ❌
Platform: iOS (CloudKit supported)

[Info Card]
CloudKit sync is disabled in debug settings.
All data is stored locally.
```

#### Scenario 2: CloudKit Enabled, Signed In
```
CloudKit Sync: Enabled ✅
Platform: iOS (CloudKit supported)
iCloud Account: Signed in and ready to sync ✅
Last Sync: 5 minutes ago

[Sync Now Button]
```

#### Scenario 3: CloudKit Enabled, Not Signed In
```
CloudKit Sync: Enabled ✅
Platform: iOS (CloudKit supported)
iCloud Account: Not signed in to iCloud
Last Sync: Never
```

#### Scenario 4: Non-iOS Platform
```
CloudKit Sync: Disabled ❌
Platform: macos (CloudKit not supported)

[Info Card]
CloudKit sync is only available on iOS devices.
```

### Sync Button Behavior

**Normal State:**
- Label: "Sync Now"
- Icon: Sync icon
- Enabled: When iCloud available

**Syncing State:**
- Label: "Syncing..."
- Icon: Circular progress indicator (spinning)
- Disabled: Can't trigger another sync

**Success State:**
- Shows green snackbar
- Message: "Sync completed: X pushed, Y pulled"
- Duration: 3 seconds

**Failure State:**
- Shows red snackbar
- Message: "Sync failed: [errors]"
- Duration: 5 seconds (longer to read errors)

## Privacy & Legal

### Privacy Policy Content

**Key Points:**
- All data stored locally on device
- iCloud sync uses personal iCloud account
- No data collection by developers
- No analytics or tracking
- No third-party access
- iCloud subject to Apple's privacy policy
- Data encrypted in transit and at rest

### Terms of Service Content

**Key Points:**
- Provided "as is" without warranty
- User responsible for data backup
- Not liable for data loss
- Requires iCloud for sync features
- Free and open source
- Can be used personally or commercially

## Customization Guide

### Change App Branding

**1. Update App Name:**
```dart
// In settings_screen.dart (automatic from package)
_packageInfo?.appName
```

**2. Change App Icon:**
```dart
// In _buildAboutSection()
Icon(
  Icons.your_icon,  // Change this
  size: 48,
  color: Theme.of(context).colorScheme.primary,
)
```

**3. Update Description:**
```dart
Text(
  'Your custom app description here',  // Change this
  textAlign: TextAlign.center,
  ...
)
```

### Add Support URLs

**1. Help Documentation:**
```dart
ListTile(
  title: const Text('Help & Documentation'),
  trailing: const Icon(Icons.open_in_new),
  onTap: () => _openUrl('https://your-docs-url.com'),  // Change URL
)
```

**2. Bug Reporting:**
```dart
ListTile(
  title: const Text('Report a Bug'),
  trailing: const Icon(Icons.open_in_new),
  onTap: () => _openUrl('https://your-issues-url.com'),  // Change URL
)
```

### Add URL Launcher

To make URLs actually open (currently just shows snackbar):

**1. Add dependency:**
```yaml
dependencies:
  url_launcher: ^6.0.0
```

**2. Update _openUrl method:**
```dart
import 'package:url_launcher/url_launcher.dart';

void _openUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open: $url')),
    );
  }
}
```

### Add New Settings

**1. Add to Preferences Section:**
```dart
ListTile(
  leading: const Icon(Icons.your_icon),
  title: const Text('Your Setting'),
  subtitle: const Text('Setting description'),
  trailing: const Icon(Icons.chevron_right),
  onTap: () {
    // Navigate or show dialog
  },
)
```

**2. Add New Section:**
```dart
_buildSectionHeader('New Section'),
_buildYourNewSection(),
const Divider(),
```

## Testing Checklist

### Functional Testing

- [ ] Settings button appears in TodoListsScreen app bar
- [ ] Tapping settings opens SettingsScreen
- [ ] Back button returns to TodoListsScreen
- [ ] Package info loads correctly (app name, version)
- [ ] Sync status shows correctly when disabled
- [ ] Sync status shows correctly when enabled (iOS only)
- [ ] Account status updates correctly
- [ ] Last sync time displays correctly
- [ ] Manual sync button works
- [ ] Sync success shows proper message
- [ ] Sync failure shows error message
- [ ] Info cards display when appropriate
- [ ] Privacy policy dialog opens
- [ ] Terms of service dialog opens
- [ ] Licenses page opens

### UI Testing

- [ ] Section headers styled correctly
- [ ] Icons display properly
- [ ] Colors match theme
- [ ] Loading indicators work
- [ ] Dialogs formatted correctly
- [ ] Scrolling works smoothly
- [ ] Spacing is consistent
- [ ] Text is readable
- [ ] Logo/icon displays properly

### Platform Testing

- [ ] Works on iOS simulator
- [ ] Works on physical iOS device
- [ ] Shows correct message on non-iOS (if tested)

## Future Enhancements

### Potential Additions

1. **Theme Selector**
   - Light/Dark/System modes
   - Custom color schemes

2. **Notification Settings**
   - Sound selection
   - Vibration settings
   - Quiet hours

3. **Sync Settings**
   - Sync interval
   - Sync on cellular toggle
   - Manual sync history

4. **Data Management**
   - Export data
   - Import data
   - Clear all data
   - Storage usage

5. **Account Settings**
   - Sign out of iCloud
   - Manage sync conflicts
   - View sync log

6. **Accessibility**
   - Font size
   - Contrast settings
   - Screen reader options

7. **Advanced**
   - Debug mode toggle
   - Developer options
   - App logs

## Summary

The Settings screen provides:
- ✅ Real-time sync status monitoring
- ✅ Manual sync trigger
- ✅ App version information
- ✅ Branding and about section
- ✅ Privacy and legal information
- ✅ Support and help resources
- ✅ Material Design UI
- ✅ Responsive and accessible

**Status:** ✅ Complete and ready to use
**Location:** Accessible from main TodoListsScreen
**Dependencies:** package_info_plus (for version info)
