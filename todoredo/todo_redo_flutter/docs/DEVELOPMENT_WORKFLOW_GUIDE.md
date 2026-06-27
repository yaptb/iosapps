# Development Workflow Guide

## 🎯 Quick Reference: Edit → Test → Deploy

### Daily Development Workflow

```bash
# 1. Start the app on your device
cd /Users/keith/dev/todoapp/claude_flutter_poc
export PATH="/opt/homebrew/opt/ruby/bin:/Users/keith/.local/share/gem/ruby/3.4.0/bin:$PATH"
flutter run -d <device-id>

# 2. Make code changes in your editor (VS Code, IntelliJ, etc.)

# 3. Save the file (⌘S)

# 4. In the terminal where flutter run is active:
#    Press 'r' for hot reload (instant, preserves state)
#    Press 'R' for hot restart (full restart, loses state)

# 5. See changes immediately in the simulator/device
```

---

## 📱 Device Selection

### Find Available Devices
```bash
flutter devices
```

**Current devices on your Mac:**
- **iPhone 16 Pro Simulator:** `2C1C6BBE-9D47-46A7-88AF-E91E70EEDFC0`
- **iPad Pro 13-inch Simulator:** `71BB00B2-733C-4611-8943-4F1380D08F66`
- **macOS Desktop:** `macos`
- **Chrome Web:** `chrome`

### Run on Specific Device
```bash
# iPhone simulator
flutter run -d 2C1C6BBE-9D47-46A7-88AF-E91E70EEDFC0

# iPad simulator
flutter run -d 71BB00B2-733C-4611-8943-4F1380D08F66

# Physical device (once connected via USB)
flutter devices  # Find the device ID
flutter run -d <physical-device-id>
```

### Boot a Different Simulator
```bash
# List all available simulators
xcrun simctl list devices available | grep iPhone

# Boot a specific simulator
xcrun simctl boot <simulator-id>
open -a Simulator

# Then run your app
flutter run -d <simulator-id>
```

---

## 🔥 Hot Reload vs Hot Restart

### Hot Reload (`r` key)
- **Speed:** Instant (< 1 second)
- **Preserves:** App state, data, UI position
- **Use for:** UI changes, text updates, style tweaks, most code changes
- **Example:** Changing button colors, text, layouts

```dart
// Change this:
Text('My Lists')

// To this:
Text('📝 My Lists')

// Save → Press 'r' → See change instantly
```

### Hot Restart (`R` key)
- **Speed:** Fast (3-5 seconds)
- **Resets:** All app state, returns to initial screen
- **Use for:** State management changes, provider updates, new dependencies
- **Example:** Adding new Riverpod providers, changing initialization logic

### Full Rebuild (when needed)
```bash
# Stop the app (press 'q' in terminal)
flutter clean
flutter pub get
flutter run -d <device-id>
```

**When to use:**
- Adding new packages to `pubspec.yaml`
- Modifying native code (iOS/Android)
- Strange errors or caching issues
- After pulling major changes from git

---

## 🛠️ Complete Development Workflow

### Step-by-Step Example: Adding a Feature

Let's say you want to **add a dark mode toggle** to the Settings screen.

#### 1. **Plan the Change**
- Identify files to modify: `lib/presentation/screens/settings_screen.dart`
- Determine what data to store: Use SharedPreferences for theme preference
- Design the UI: Add a switch in the Preferences section

#### 2. **Make Code Changes**

**Open the file:**
```bash
# Use your preferred editor
code lib/presentation/screens/settings_screen.dart
# or
open -a "IntelliJ IDEA" lib/presentation/screens/settings_screen.dart
```

**Edit the code:**
```dart
// In _buildPreferencesSection(), change:
ListTile(
  leading: const Icon(Icons.brightness_6),
  title: const Text('Theme'),
  subtitle: const Text('Light'),  // Static
  trailing: const Icon(Icons.chevron_right),
  onTap: () {
    // Coming soon
  },
),

// To this:
ListTile(
  leading: const Icon(Icons.brightness_6),
  title: const Text('Theme'),
  trailing: Switch(
    value: _isDarkMode,  // Add this state variable
    onChanged: (bool value) {
      setState(() {
        _isDarkMode = value;
      });
      _saveThemePreference(value);
    },
  ),
),
```

#### 3. **Add Required State**
```dart
// At the top of _SettingsScreenState class:
class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  PackageInfo? _packageInfo;
  bool _isLoadingPackageInfo = true;
  bool _isDarkMode = false;  // ADD THIS

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
    _loadThemePreference();  // ADD THIS
  }

  // ADD THESE METHODS:
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
    });
  }

  Future<void> _saveThemePreference(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isDark);
    // TODO: Apply theme change to app
  }
```

#### 4. **Save and Test**
```bash
# In the terminal where flutter run is active:
# 1. Save the file (⌘S)
# 2. Press 'r' for hot reload
# 3. Navigate to Settings in the app
# 4. Toggle the switch and see it work
```

#### 5. **If You Need New Dependencies**

```bash
# 1. Stop the app (press 'q')

# 2. Add dependency to pubspec.yaml
# (shared_preferences is already added, but if you needed something new:)
# dependencies:
#   your_new_package: ^1.0.0

# 3. Install dependencies
flutter pub get

# 4. Restart the app
flutter run -d <device-id>
```

#### 6. **If You Modified Drift Database**

```bash
# 1. Make changes to lib/infrastructure/persistence/drift/tables.dart

# 2. Generate updated database code
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Restart the app
flutter run -d <device-id>
```

---

## 🏗️ Project Structure & Where to Make Changes

### **UI Changes (Presentation Layer)**
```
lib/presentation/
├── screens/              ← Modify these for screen-level changes
│   ├── todo_lists_screen.dart
│   ├── todos_screen.dart
│   ├── todo_form_screen.dart
│   ├── settings_screen.dart
│   └── onboarding_screen.dart
└── widgets/              ← Modify for reusable component changes
    ├── todo_item_widget.dart
    └── todo_list_item_widget.dart
```

**Common changes:**
- Button text/colors
- Layout modifications
- Adding new screens
- Form validation

### **Business Logic (Application Layer)**
```
lib/application/services/
├── todo_service.dart              ← Todo operations
├── todo_list_service.dart         ← List operations
├── reminder_service.dart          ← Reminder logic
├── recurrence_service.dart        ← Recurring tasks
└── sync_coordinator_service.dart  ← CloudKit sync
```

**Common changes:**
- Adding new features
- Changing validation rules
- Modifying business rules
- Adding computed properties

### **Data Models (Domain Layer)**
```
lib/domain/entities/
├── todo.dart           ← Todo data model
├── todo_list.dart      ← List data model
├── reminder.dart       ← Reminder data model
└── recurrence_rule.dart
```

**Common changes:**
- Adding new fields
- Changing data structure
- Adding validation

### **Database (Infrastructure Layer)**
```
lib/infrastructure/persistence/drift/
├── tables.dart         ← Database schema (modify here)
├── database.dart       ← Generated (don't edit)
└── database.g.dart     ← Generated (don't edit)
```

**Workflow for database changes:**
1. Edit `tables.dart`
2. Run `flutter pub run build_runner build --delete-conflicting-outputs`
3. Update repositories to handle new fields
4. Restart app

---

## 💡 Common Enhancement Ideas

### Easy (Beginner Level)

#### 1. **Change App Colors**
```dart
// lib/main.dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue,  // Change to Colors.purple, Colors.green, etc.
),
```

#### 2. **Add Icons to Lists**
```dart
// lib/presentation/widgets/todo_list_item_widget.dart
leading: CircleAvatar(
  child: Icon(Icons.list),  // Change to Icons.favorite, Icons.work, etc.
),
```

#### 3. **Customize Empty State Messages**
```dart
// lib/presentation/screens/todos_screen.dart
Text(
  'No todos yet!\nTap + to add one',  // Make it more fun
  // e.g., 'All done! 🎉\nAdd a new task to get started'
),
```

#### 4. **Add More Quick Filters**
```dart
// In todos_screen.dart, add buttons to the app bar:
actions: [
  IconButton(
    icon: Icon(Icons.calendar_today),
    onPressed: () => _filterByDueDate(),
  ),
  IconButton(
    icon: Icon(Icons.priority_high),
    onPressed: () => _filterByPriority(),
  ),
],
```

### Medium (Intermediate Level)

#### 5. **Add Priority Field to Todos**

**Step 1:** Add to database schema
```dart
// lib/infrastructure/persistence/drift/tables.dart
class Todos extends Table {
  // ... existing fields ...
  IntColumn get priority => integer().withDefault(const Constant(0))();
}
```

**Step 2:** Regenerate database
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Step 3:** Add to domain entity
```dart
// lib/domain/entities/todo.dart
class Todo {
  final int priority;  // 0=low, 1=medium, 2=high

  Todo({
    // ... existing fields ...
    this.priority = 0,
  });
}
```

**Step 4:** Add UI to set priority
```dart
// lib/presentation/screens/todo_form_screen.dart
DropdownButtonFormField<int>(
  value: _priority,
  items: [
    DropdownMenuItem(value: 0, child: Text('Low')),
    DropdownMenuItem(value: 1, child: Text('Medium')),
    DropdownMenuItem(value: 2, child: Text('High')),
  ],
  onChanged: (value) => setState(() => _priority = value ?? 0),
),
```

#### 6. **Add Tags/Labels System**
- Create a new `Tag` entity
- Add many-to-many relationship with Todos
- Create tag selection UI
- Add tag filtering

#### 7. **Implement Dark Mode**
- Use `ThemeMode` in MaterialApp
- Store preference in SharedPreferences
- Toggle from Settings screen
- Apply throughout app

### Advanced (Expert Level)

#### 8. **Add Search Functionality**
```dart
// Add to todos_screen.dart app bar
IconButton(
  icon: Icon(Icons.search),
  onPressed: () {
    showSearch(
      context: context,
      delegate: TodoSearchDelegate(todos: todos),
    );
  },
),

// Create custom SearchDelegate
class TodoSearchDelegate extends SearchDelegate<Todo> {
  final List<Todo> todos;

  TodoSearchDelegate({required this.todos});

  @override
  Widget buildResults(BuildContext context) {
    final results = todos.where((t) =>
      t.title.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => TodoItemWidget(todo: results[index]),
    );
  }
  // ... implement other required methods
}
```

#### 9. **Add Subtasks**
- Add `parentTodoId` to Todos table
- Create hierarchical relationship
- Build nested UI with expansion tiles
- Track parent completion based on subtasks

#### 10. **Enable CloudKit Sync**
- Set `kEnableCloudKitSync = true` in `lib/infrastructure/config/debug_config.dart`
- Configure Xcode project with iCloud capability
- Create CloudKit schema in iCloud Dashboard
- Test on physical device (requires Apple Developer account)

---

## 🐛 Debugging Workflow

### View Console Logs
```dart
// Add print statements anywhere in your code
print('Debug: Current todo count: ${todos.length}');
print('User tapped: ${todo.title}');

// Save and hot reload to see output in terminal
```

### Use Flutter DevTools
```bash
# After running flutter run, open the DevTools URL shown:
# http://127.0.0.1:<port>/devtools/

# Features:
# - Widget inspector (see UI tree)
# - Performance profiler
# - Network inspector
# - Memory analyzer
```

### Common Errors

**"Hot reload not working"**
```bash
# Press 'R' for hot restart instead
# Or quit and restart: press 'q', then flutter run again
```

**"Build failed after database change"**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run -d <device-id>
```

**"App crashes on launch"**
```bash
# Check terminal for error messages
# Common issues:
# - Missing await on async functions
# - Null safety violations
# - Provider not initialized

# Use try-catch for debugging:
try {
  // Your code
} catch (e, stackTrace) {
  print('Error: $e');
  print('Stack: $stackTrace');
}
```

---

## 📦 Adding New Packages

### Example: Adding URL Launcher

```bash
# 1. Add to pubspec.yaml dependencies section
# url_launcher: ^6.2.0

# 2. Install
flutter pub get

# 3. Import in your file
import 'package:url_launcher/url_launcher.dart';

# 4. Use it
Future<void> _openUrl(String urlString) async {
  final url = Uri.parse(urlString);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }
}

# 5. Hot restart (R) to load new package
```

### Popular Packages to Consider

- **url_launcher** - Open URLs, emails, phone numbers
- **image_picker** - Select images from gallery/camera
- **share_plus** - Share content to other apps
- **connectivity_plus** - Check network status
- **cached_network_image** - Efficient image loading/caching
- **flutter_slidable** - Swipe actions on list items
- **badges** - Add notification badges
- **animations** - Pre-built animations
- **google_fonts** - Use Google Fonts
- **flutter_colorpicker** - Color picker widget

---

## 🚀 Deploy to Physical Device

### iOS Device (iPad/iPhone)

#### One-Time Setup:
```bash
# 1. Connect device via USB
# 2. Trust the computer on the device
# 3. Open Xcode
open ios/Runner.xcworkspace

# 4. In Xcode:
#    - Select your device from device dropdown
#    - Click on "Runner" in left sidebar
#    - Go to "Signing & Capabilities"
#    - Select your Apple ID team
#    - Change bundle identifier to something unique:
#      com.yourname.todoapp
```

#### Deploy:
```bash
# 1. Find device ID
flutter devices

# 2. Run on device
flutter run -d <your-iphone-id>

# First time: May need to trust developer on device
# Settings → General → VPN & Device Management → Trust
```

### Android Device

```bash
# 1. Enable Developer Options on Android device
#    Settings → About Phone → Tap "Build Number" 7 times

# 2. Enable USB Debugging
#    Settings → Developer Options → USB Debugging

# 3. Connect via USB and authorize computer

# 4. Find device
flutter devices

# 5. Run
flutter run -d <android-device-id>
```

---

## 🔧 Configuration Files Reference

### `pubspec.yaml`
- **Location:** Root of project
- **Purpose:** Package dependencies, assets, app metadata
- **When to modify:**
  - Adding new packages
  - Including assets (images, fonts)
  - Changing app version

### `lib/infrastructure/config/debug_config.dart`
- **Location:** `lib/infrastructure/config/`
- **Purpose:** Feature flags and debug settings
- **Current flags:**
  - `kForceOnboarding` - Always show onboarding screen
  - `kEnableCloudKitSync` - Enable/disable CloudKit sync

### `lib/main.dart`
- **Location:** Root of lib folder
- **Purpose:** App entry point, theme configuration
- **Common changes:**
  - App theme colors
  - Dark mode settings
  - Initial route

### `lib/infrastructure/dependency_injection.dart`
- **Location:** `lib/infrastructure/`
- **Purpose:** Riverpod provider definitions
- **When to modify:**
  - Adding new services
  - Changing provider scope
  - Dependency injection setup

---

## 📝 Best Practices

### 1. **Always Save Before Testing**
- Hot reload only works on saved files
- Use auto-save in your editor

### 2. **Use Version Control**
```bash
# Before making changes
git checkout -b feature/my-new-feature

# After testing
git add .
git commit -m "Add dark mode toggle"

# If something breaks
git checkout main  # Return to working version
```

### 3. **Test on Multiple Devices**
```bash
# Test on both iPhone and iPad simulators
flutter run -d 2C1C6BBE-9D47-46A7-88AF-E91E70EEDFC0  # iPhone
flutter run -d 71BB00B2-733C-4611-8943-4F1380D08F66  # iPad
```

### 4. **Keep Dependencies Updated**
```bash
# Check for updates
flutter pub outdated

# Update all packages
flutter pub upgrade

# Test app thoroughly after updates
```

### 5. **Read the Logs**
- Terminal output shows compilation errors
- Runtime errors appear with stack traces
- Search error messages online (Stack Overflow)

### 6. **Code Organization**
- Keep files under 500 lines
- Extract reusable widgets to separate files
- Use meaningful variable names
- Add comments for complex logic

### 7. **Follow Flutter Conventions**
```dart
// Good naming:
class TodoListScreen extends StatelessWidget {}  // PascalCase for classes
final String userName = 'Keith';  // camelCase for variables
const double kPadding = 16.0;  // k prefix for constants

// File naming:
todo_list_screen.dart  // snake_case for files
```

---

## 🎓 Learning Resources

### Flutter Official
- [flutter.dev](https://flutter.dev) - Official documentation
- [Widget catalog](https://flutter.dev/docs/development/ui/widgets) - All available widgets
- [Cookbook](https://flutter.dev/docs/cookbook) - Common recipes
- [Codelabs](https://flutter.dev/docs/codelabs) - Step-by-step tutorials

### This Codebase Documentation
- `CLAUDE.md` - Architecture overview and design patterns
- `SETTINGS_SCREEN.md` - Settings feature documentation
- `RESPONSIVE_LAYOUT_OPTIONS.md` - UI enhancement ideas for tablets
- `CLOUDKIT_SYNC_PLAN.md` - CloudKit sync implementation details
- Code comments throughout the codebase

### Community Resources
- [pub.dev](https://pub.dev) - Flutter packages
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter) - Q&A
- [Flutter Community](https://flutter.dev/community) - Discord, meetups, forums
- [YouTube - Flutter](https://www.youtube.com/c/flutterdev) - Official tutorials

### Recommended Courses
- Flutter & Dart - The Complete Guide (Udemy)
- Flutter Development Bootcamp (App Brewery)
- Official Flutter YouTube channel

---

## 🔍 Quick Reference Commands

### Development
```bash
# Start development
flutter run -d <device-id>

# Hot reload
# Press 'r' in terminal

# Hot restart
# Press 'R' in terminal

# Quit app
# Press 'q' in terminal

# Clear console
# Press 'c' in terminal
```

### Build & Analysis
```bash
# Analyze code for issues
flutter analyze

# Format all code
flutter format .

# Run tests
flutter test

# Clean build artifacts
flutter clean

# Get dependencies
flutter pub get

# Generate code (Drift)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
flutter pub run build_runner watch
```

### Device Management
```bash
# List devices
flutter devices

# List simulators
xcrun simctl list devices available

# Boot simulator
xcrun simctl boot <simulator-id>

# Open Simulator app
open -a Simulator

# Shutdown all simulators
xcrun simctl shutdown all
```

### Project Info
```bash
# Check Flutter installation
flutter doctor

# Flutter version
flutter --version

# List outdated packages
flutter pub outdated

# Upgrade all packages
flutter pub upgrade
```

---

## 🚨 Troubleshooting

### "CocoaPods not found"
```bash
# Ensure Ruby and CocoaPods are in PATH
export PATH="/opt/homebrew/opt/ruby/bin:/Users/keith/.local/share/gem/ruby/3.4.0/bin:$PATH"

# Verify CocoaPods
pod --version

# If not found, install
gem install cocoapods
```

### "Xcode build failed"
```bash
# Clean and rebuild
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
flutter run -d <device-id>
```

### "DartError: Can't find X"
```bash
# Usually means code generation is needed
flutter pub run build_runner build --delete-conflicting-outputs
```

### "State not updating"
```bash
# Ensure you're using setState in StatefulWidget
setState(() {
  _myVariable = newValue;
});

# Or notifyListeners() in ChangeNotifier
# Or proper Riverpod state management
```

### "Simulator won't boot"
```bash
# Reset simulator
xcrun simctl erase <simulator-id>

# Or delete and recreate
xcrun simctl delete <simulator-id>
# Then create new one in Xcode
```

---

## Summary: Your Typical Development Session

```bash
# 1. Navigate to project
cd /Users/keith/dev/todoapp/claude_flutter_poc

# 2. Set up environment
export PATH="/opt/homebrew/opt/ruby/bin:/Users/keith/.local/share/gem/ruby/3.4.0/bin:$PATH"

# 3. Start app on device
flutter run -d 2C1C6BBE-9D47-46A7-88AF-E91E70EEDFC0

# 4. Open editor
code .  # or your preferred editor

# 5. Make changes to files in lib/

# 6. Save (⌘S)

# 7. In terminal, press 'r' for hot reload

# 8. See changes in simulator instantly

# 9. Repeat steps 5-8 until satisfied

# 10. Test thoroughly on different screens

# 11. Commit changes
git add .
git commit -m "Your change description"

# 12. Done!
```

---

## Environment Setup (Already Complete)

Your development environment is fully configured:

✅ Flutter SDK 3.38.3 installed
✅ Xcode configured
✅ iOS Simulators available (iPhone 16 Pro, iPad Pro 13-inch)
✅ Ruby 3.4.7 via Homebrew
✅ CocoaPods 1.16.2 installed
✅ PATH configured in `~/.zshrc`

**You're ready to start developing immediately!**

---

**Happy coding!** 🎉
