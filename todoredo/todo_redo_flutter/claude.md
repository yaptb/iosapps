# TodoRedo

## Project Overview

TodoRedo is a Flutter-based TODO application for iOS that supports recurring tasks, reminders, and iCloud sync via CloudKit. Built with a layered architecture following clean architecture principles and SOLID design patterns.

## Core Features

### Phase 1: Foundation ✓ COMPLETE
- Basic TODO CRUD operations (Create, Read, Update, Delete)
- Local database persistence with Drift
- List view and detail screens
- Material Design 3 UI

### Phase 2: Core TODO Features ✓ COMPLETE
- Mark items complete/incomplete
- Due dates
- Categories/lists (`TodoList` entity, `TodoListsScreen`, `TodoListFormScreen`)
- Filtering and sorting

### Phase 3: Recurrence & Reminders ✓ COMPLETE
- Recurrence rules (daily, weekly, monthly, custom) via `RecurrenceService`
- On-completion generation of next recurring instance
- Local notifications for reminders via `flutter_local_notifications`
- Permission handling with first-run onboarding wizard
- Settings screen with sync status

### Phase 4: CloudKit Sync (IN PROGRESS)
- Bidirectional iCloud sync via CloudKit platform channel
- `SyncCoordinatorService` orchestrates Drift ↔ CloudKit
- All entities have soft delete and sync tracking fields (`needsSync`, `isDeleted`)
- `ICloudSyncService` interface with real (`CloudKitSyncService`) and mock implementations
- Debug flag `DebugConfig.kEnableCloudKitSync` to toggle sync without recompiling (default: `false` for simulator)
- iOS native `CloudKitHandler.swift` written; end-to-end testing requires physical device + Xcode CloudKit capability configuration

**What's left for Phase 4:**
- Configure Xcode CloudKit capability (iCloud container: `iCloud.com.parsecxr.todoredo`)
- Create CloudKit schema in iCloud Dashboard
- End-to-end testing on physical device with `kEnableCloudKitSync = true`
- Conflict resolution edge case testing

See `docs/CLOUDKIT_SYNC_PLAN.md` and `docs/CLOUDKIT_DEBUG_SWITCH.md` for full details.

## Architecture

### Layered Architecture

```
┌─────────────────────────────────────────┐
│   Presentation Layer (UI/Widgets)       │
│   - TodosScreen, TodoDetailScreen       │
│   - TodoListsScreen, SettingsScreen     │
│   - OnboardingScreen (first-run)        │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│   Application Layer (Business Logic)    │
│   - TodoService, RecurrenceService      │
│   - ReminderService, TodoListService    │
│   - SyncCoordinatorService              │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│   Domain Layer (Entities & Contracts)   │
│   - Todo, TodoList, Reminder entities   │
│   - ITodoRepository, ITodoListRepository│
│   - IReminderRepository                 │
│   - INotificationService               │
│   - ICloudSyncService                  │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│   Infrastructure Layer (Implementations)│
│   - DriftTodoRepository                 │
│   - DriftTodoListRepository             │
│   - DriftReminderRepository             │
│   - LocalNotificationService            │
│   - CloudKitSyncService (platform ch.)  │
│   - MockCloudSyncService                │
└─────────────────────────────────────────┘
```

### Design Patterns

#### 1. Repository Pattern (Persistence Abstraction)
- **Interfaces**: `ITodoRepository`, `ITodoListRepository`, `IReminderRepository`
- **Implementations**: Drift-backed repositories in infrastructure layer

#### 2. Strategy Pattern (Notifications & Sync)
- **Notification**: `INotificationService` → `LocalNotificationService`
- **Sync**: `ICloudSyncService` → `CloudKitSyncService` / `MockCloudSyncService`
- Swapped at startup via `DebugConfig.kEnableCloudKitSync`

#### 3. Dependency Injection (Riverpod)
- Provider hierarchy: Database → Repository → Service → UI
- All services wired in `lib/infrastructure/dependency_injection.dart`

#### 4. Service Layer
- `TodoService`: CRUD + recurrence triggering
- `RecurrenceService`: Next-instance calculation on completion
- `ReminderService`: Notification scheduling lifecycle
- `SyncCoordinatorService`: Bidirectional sync orchestration

## Folder Structure

```
lib/
├── domain/
│   ├── entities/
│   │   ├── todo.dart
│   │   ├── todo_list.dart
│   │   └── reminder.dart
│   ├── repositories/
│   │   ├── i_todo_repository.dart
│   │   ├── i_todo_list_repository.dart
│   │   └── i_reminder_repository.dart
│   └── services/
│       ├── i_notification_service.dart
│       └── i_cloud_sync_service.dart
│
├── application/
│   └── services/
│       ├── todo_service.dart
│       ├── todo_list_service.dart
│       ├── recurrence_service.dart
│       ├── reminder_service.dart
│       └── sync_coordinator_service.dart
│
├── infrastructure/
│   ├── config/
│   │   └── debug_config.dart           ← kEnableCloudKitSync toggle
│   ├── persistence/
│   │   ├── drift/
│   │   │   ├── database.dart
│   │   │   ├── database.g.dart         ← generated
│   │   │   └── tables.dart
│   │   ├── drift_todo_repository.dart
│   │   ├── drift_todo_list_repository.dart
│   │   └── drift_reminder_repository.dart
│   ├── notifications/
│   │   └── local_notification_service.dart
│   ├── sync/
│   │   ├── cloudkit_sync_service.dart  ← platform channel to iOS native
│   │   └── mock_cloud_sync_service.dart
│   └── dependency_injection.dart
│
└── presentation/
    ├── screens/
    │   ├── todos_screen.dart
    │   ├── todo_list_screen.dart
    │   ├── todo_lists_screen.dart
    │   ├── todo_list_form_screen.dart
    │   ├── todo_detail_screen.dart
    │   ├── settings_screen.dart
    │   └── onboarding/
    │       ├── onboarding_screen.dart
    │       └── pages/
    │           ├── welcome_page.dart
    │           ├── permissions_info_page.dart
    │           ├── permissions_request_page.dart
    │           └── completion_page.dart
    └── widgets/
        ├── todo_item_widget.dart
        └── todo_list_item_widget.dart

docs/                                   ← supplementary planning docs
ios/Runner/
    ├── AppDelegate.swift
    └── CloudKitHandler.swift           ← native CloudKit implementation
```

## Data Model

### Todo Entity
```dart
{
  id: String (UUID)
  title: String
  description: String?
  dueDate: DateTime?
  isCompleted: bool
  completedAt: DateTime?
  createdAt: DateTime
  updatedAt: DateTime
  recurrenceRule: RecurrenceRule?
  reminderEnabled: bool
  listId: String?
  originalTodoId: String?   // recurrence chain tracking
  // Sync fields:
  needsSync: bool
  isDeleted: bool
  lastSyncedAt: DateTime?
}
```

### Reminder Entity
```dart
{
  id: String (UUID)
  todoId: String
  reminderTime: DateTime
  notificationId: int
  createdAt: DateTime
  // Sync fields: needsSync, isDeleted, lastSyncedAt
}
```

### TodoList Entity
```dart
{
  id: String (UUID)
  name: String
  color: Color?
  icon: String?
  createdAt: DateTime
  updatedAt: DateTime
  // Sync fields: needsSync, isDeleted, lastSyncedAt
}
```

## Technical Stack

### Core
- **drift** ^2.14.0 — type-safe SQLite ORM
- **drift_flutter** ^0.1.0 — Flutter integration
- **flutter_riverpod** ^2.4.0 — DI and state management
- **uuid** ^4.0.0 — UUID generation
- **intl** — date formatting

### Notifications & Permissions
- **flutter_local_notifications** ^17.0.0
- **timezone** ^0.9.0

### Utilities
- **shared_preferences** ^2.2.0 — onboarding completion flag
- **package_info_plus** ^8.0.0 — app version in settings

### Dev
- **drift_dev** ^2.14.0 — code generation
- **build_runner** ^2.4.0

## Environment

- Flutter SDK: 3.38.3 (stable)
- Ruby: 3.4.7 (Homebrew) — required for CocoaPods
- CocoaPods: 1.16.2
- PATH includes: `/opt/homebrew/opt/ruby/bin` and `/Users/keith/.local/share/gem/ruby/3.4.0/bin`
- Working directory: `/Users/keith/_dev/_github/iosapps/todoredo/todo_redo_flutter`

## Development Commands

```bash
# Run app (simulator — CloudKit disabled by default)
flutter run

# Run on specific device
flutter run -d <device-id>

# List devices
flutter devices

# Generate Drift code
flutter pub run build_runner build

# Watch for Drift changes
flutter pub run build_runner watch

# Run tests
flutter test

# Lint check
flutter analyze

# Clean build
flutter clean
```

## CloudKit Setup (Phase 4 — physical device)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Add **iCloud** capability → enable **CloudKit**
3. Create container: `iCloud.com.parsecxr.todoredo`
4. Add **Background Modes** → **Remote notifications**
5. Create CloudKit schema in [iCloud Dashboard](https://icloud.developer.apple.com/dashboard) (see `docs/CLOUDKIT_SYNC_PLAN.md`)
6. Set `DebugConfig.kEnableCloudKitSync = true` in `lib/infrastructure/config/debug_config.dart`
7. Run on physical iOS device

## Architecture Principles

1. **Separation of Concerns** — each layer has one well-defined responsibility
2. **Dependency Inversion** — high-level modules depend on abstractions, not implementations
3. **Interface Segregation** — small, focused interfaces per domain concept
4. **Single Responsibility** — each class has one reason to change
5. **Open/Closed** — extend via new implementations, not modification of existing ones
6. **Offline-First** — all core functionality works without network; CloudKit sync is additive
