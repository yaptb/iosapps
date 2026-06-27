# CloudKit Debug Switch Guide

## Overview

The app now has a debug configuration switch to enable/disable CloudKit synchronization without requiring code changes or recompilation. This is useful for:

- **Testing in simulator** (CloudKit doesn't work in simulators)
- **Development without iCloud account**
- **Testing local-only functionality**
- **Switching between simulator and physical device testing**

## How to Use the Debug Switch

### Location

The debug switch is in: `lib/infrastructure/config/debug_config.dart`

```dart
class DebugConfig {
  /// Enable CloudKit synchronization
  ///
  /// Set to false to disable CloudKit sync (useful for simulator testing or development).
  /// Set to true to enable CloudKit sync (requires physical iOS device with iCloud).
  static const bool kEnableCloudKitSync = false;  // <-- Change this
}
```

### Configuration Options

#### Option 1: CloudKit DISABLED (Default)
```dart
static const bool kEnableCloudKitSync = false;
```

**Use this for:**
- ✅ iPad/iPhone Simulator testing
- ✅ Development on Mac
- ✅ Testing UI and local database
- ✅ No iCloud account needed

**What happens:**
- App uses `MockCloudSyncService` (safe no-op implementation)
- All data stored locally in SQLite (Drift)
- Sync buttons/features don't actually sync
- No network calls to iCloud
- No crashes or errors

#### Option 2: CloudKit ENABLED
```dart
static const bool kEnableCloudKitSync = true;
```

**Use this for:**
- ✅ Physical iPhone/iPad with iCloud
- ✅ Testing real CloudKit synchronization
- ✅ Multi-device sync testing

**Requirements:**
- Physical iOS device (not simulator)
- Signed into iCloud
- Xcode CloudKit configuration complete
- CloudKit schema created in iCloud Dashboard

**What happens:**
- App uses `CloudKitSyncService` (real CloudKit)
- Data syncs to iCloud
- Syncs across devices with same iCloud account

## Testing Workflow

### Phase 1: Simulator Testing (CloudKit Disabled)

1. **Set configuration:**
   ```dart
   static const bool kEnableCloudKitSync = false;
   ```

2. **Run on iPad simulator:**
   ```bash
   flutter devices  # Find iPad simulator ID
   flutter run -d <simulator-id>
   ```

3. **Test features:**
   - ✅ Create/edit/delete todos
   - ✅ Lists and reminders
   - ✅ Local persistence
   - ✅ Recurrence
   - ✅ UI/UX
   - ❌ CloudKit sync (disabled)

### Phase 2: Physical Device Testing (CloudKit Enabled)

1. **Configure Xcode CloudKit:**
   ```bash
   open ios/Runner.xcworkspace
   ```
   - Add "iCloud" capability
   - Enable "CloudKit"
   - Create container: `iCloud.com.todoapp.flutter`
   - Add "Background Modes" → "Remote notifications"

2. **Create CloudKit schema** in [iCloud Dashboard](https://icloud.developer.apple.com/dashboard)
   - See `CLOUDKIT_SYNC_PLAN.md` for schema details

3. **Enable CloudKit in code:**
   ```dart
   static const bool kEnableCloudKitSync = true;
   ```

4. **Connect your physical iPad:**
   ```bash
   flutter devices  # Find your iPad
   flutter run -d <ipad-id>
   ```

5. **Test sync features:**
   - ✅ All Phase 1 features
   - ✅ CloudKit sync to iCloud
   - ✅ Multi-device sync
   - ✅ Conflict resolution

## How It Works

### Architecture

```
┌─────────────────────────────────────────────┐
│         DebugConfig.kEnableCloudKitSync     │
│                                             │
│         false          │         true       │
└───────────┬────────────┴────────┬───────────┘
            │                     │
            ▼                     ▼
   ┌─────────────────┐   ┌─────────────────┐
   │ MockCloudSync   │   │ CloudKitSync    │
   │ Service         │   │ Service         │
   │                 │   │                 │
   │ • Returns       │   │ • Real CloudKit │
   │   safe defaults │   │ • Platform      │
   │ • No network    │   │   channels      │
   │ • No crashes    │   │ • iOS native    │
   └─────────────────┘   └─────────────────┘
            │                     │
            └──────────┬──────────┘
                       ▼
            ┌─────────────────────┐
            │  SyncCoordinator    │
            │  Service            │
            │                     │
            │  • Checks debug     │
            │    flag first       │
            │  • Returns early    │
            │    if disabled      │
            └─────────────────────┘
```

### Code Flow

1. **Dependency Injection** (`dependency_injection.dart`):
   ```dart
   final cloudSyncServiceProvider = Provider<ICloudSyncService>((ref) {
     if (DebugConfig.kEnableCloudKitSync) {
       return CloudKitSyncService();  // Real CloudKit
     } else {
       return MockCloudSyncService();  // Safe mock
     }
   });
   ```

2. **Sync Coordinator** (`sync_coordinator_service.dart`):
   ```dart
   Future<bool> isSyncAvailable() async {
     // Check debug flag first
     if (!DebugConfig.kEnableCloudKitSync) {
       return false;  // Early return
     }

     // ... rest of CloudKit checks
   }
   ```

3. **Mock Service** (`mock_cloud_sync_service.dart`):
   ```dart
   class MockCloudSyncService implements ICloudSyncService {
     @override
     Future<bool> isSignedIn() async => false;

     @override
     Future<List<CloudRecord>> fetchRecordsSince(...) async => [];

     // ... all methods return safe defaults
   }
   ```

## Quick Reference

### Current Status

```bash
# Check current setting
cat lib/infrastructure/config/debug_config.dart | grep kEnableCloudKitSync
```

**Currently:** `kEnableCloudKitSync = false` (CloudKit DISABLED)

### Running Commands

```bash
# Simulator (CloudKit disabled)
export PATH="/opt/homebrew/opt/ruby/bin:/Users/keith/.local/share/gem/ruby/3.4.0/bin:$PATH"
flutter run -d 71BB00B2-733C-4611-8943-4F1380D08F66

# Physical iPad (after enabling CloudKit)
flutter devices
flutter run -d <your-ipad-id>
```

### CocoaPods Fix (Already Done)

```bash
# Ruby and CocoaPods are now installed and configured
ruby --version  # 3.4.7
pod --version   # 1.16.2

# PATH is already set in ~/.zshrc:
export PATH="/opt/homebrew/opt/ruby/bin:/Users/keith/.local/share/gem/ruby/3.4.0/bin:$PATH"
```

## Benefits of This Approach

1. **No Recompilation** - Just change one constant
2. **Type-Safe** - Compile-time constant (not runtime config)
3. **Safe** - Mock service prevents crashes when disabled
4. **Clean** - Single source of truth for sync state
5. **Flexible** - Easy to add more debug flags later
6. **Documented** - Clear comments explain each setting

## Testing Checklist

### Simulator Testing (CloudKit Disabled)
- [x] App launches successfully
- [x] Can create todos
- [x] Can edit todos
- [x] Can delete todos (soft delete)
- [x] Data persists locally
- [x] No sync errors
- [x] No crashes

### Physical Device Testing (CloudKit Enabled)
- [ ] Configure Xcode CloudKit
- [ ] Create CloudKit schema
- [ ] Enable `kEnableCloudKitSync = true`
- [ ] Sign into iCloud on device
- [ ] App launches successfully
- [ ] Can create todos → sync to iCloud
- [ ] Delete todo → sync deletion
- [ ] Create on device A → appears on device B
- [ ] Conflict resolution works
- [ ] Offline changes queue for sync

## Troubleshooting

### "CloudKit not available" even with flag enabled
- ✅ Check you're on a physical iOS device (not simulator)
- ✅ Check device is signed into iCloud (Settings → iCloud)
- ✅ Check Xcode CloudKit capabilities are configured
- ✅ Check `AppDelegate.swift` has CloudKitHandler registered

### App crashes on simulator
- ✅ Ensure `kEnableCloudKitSync = false` for simulator
- ✅ Check `AppDelegate.swift` has CloudKitHandler registration commented out
- ✅ Clean build: `flutter clean && flutter run`

### Sync not working on physical device
- ✅ Ensure `kEnableCloudKitSync = true`
- ✅ Check CloudKit schema exists in iCloud Dashboard
- ✅ Check container ID matches in Xcode and code
- ✅ Check device has network connectivity

## Next Steps

1. **Current:** Test all features on iPad simulator with CloudKit disabled ✅
2. **Next:** Configure Xcode CloudKit capabilities
3. **Next:** Create CloudKit schema in iCloud Dashboard
4. **Next:** Enable `kEnableCloudKitSync = true`
5. **Next:** Test on physical iPad with iCloud

See `SYNC_IMPLEMENTATION_STATUS.md` for full CloudKit implementation details.
