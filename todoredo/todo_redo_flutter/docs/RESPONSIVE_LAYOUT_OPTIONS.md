# Responsive Layout Options for iPad/Large Screens

## Overview

This document outlines options for implementing a split-screen (master-detail) layout on large screen devices in landscape mode. The goal is to show the todo item list on the left while keeping detail/edit forms visible on the right, improving the iPad user experience.

## Target Design Pattern: Master-Detail

### Visual Layout

```
┌─────────────────────────────────────────────────┐
│  [Landscape iPad]                               │
│  ┌──────────────┬─────────────────────────────┐ │
│  │  Todo List   │   Detail/Dialog Area        │ │
│  │  (Master)    │   (Detail)                  │ │
│  │              │                             │ │
│  │  ☐ Buy milk  │   ┌───────────────────────┐ │ │
│  │  ☐ Call mom  │   │ Edit "Buy milk"       │ │ │
│  │  ☐ Meeting   │   │                       │ │ │
│  │  ...         │   │ Title: [Buy milk___]  │ │ │
│  │              │   │ Due: [Tomorrow___]    │ │ │
│  │              │   │                       │ │ │
│  │              │   │ [Save] [Cancel]       │ │ │
│  │              │   └───────────────────────┘ │ │
│  └──────────────┴─────────────────────────────┘ │
└─────────────────────────────────────────────────┘
```

### Behavior
- **Left pane (30-40% width):** Shows todo list
- **Right pane (60-70% width):** Shows detail/edit form
- **On phone/portrait:** Falls back to full-screen navigation
- **List remains visible** while editing

---

## Implementation Options

### Option 1: Adaptive Layout with `LayoutBuilder` ⭐ RECOMMENDED

#### Description
Use Flutter's built-in `LayoutBuilder` to check screen width and conditionally render split view or single view.

#### How It Works
```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 700) {
      // Tablet landscape - Split view
      return Row(
        children: [
          Expanded(flex: 2, child: TodoListPane()),
          VerticalDivider(),
          Expanded(flex: 3, child: TodoDetailPane()),
        ],
      );
    } else {
      // Phone - Single view with navigation
      return Navigator(...);
    }
  },
)
```

#### Pros
- ✅ Simple to implement
- ✅ Full control over breakpoints
- ✅ Easy to customize
- ✅ No external dependencies
- ✅ Works with existing code

#### Cons
- ❌ More manual work
- ❌ Need to handle state management yourself
- ❌ No built-in animations

#### Best For
- Quick implementation
- Full control needed
- Minimal dependencies
- Existing codebase

---

### Option 2: Flutter's Adaptive Navigation Packages

#### Description
Use community packages designed for adaptive navigation patterns.

#### Packages
- `adaptive_navigation`
- `go_router` with shell routes
- `responsive_framework`

#### Example with `adaptive_navigation`
```dart
AdaptiveNavigationScaffold(
  destinations: [...],
  body: selectedPage,
  useDrawer: false, // Use rail on tablet
  navigationRailOptions: NavigationRailOptions(...),
)
```

#### Pros
- ✅ Less code to write
- ✅ Handles common patterns
- ✅ Well-tested solutions
- ✅ Community support

#### Cons
- ❌ Less flexibility
- ❌ Learning curve for new packages
- ❌ External dependencies

#### Best For
- Standard navigation patterns
- Want battle-tested solutions
- Don't mind dependencies

---

### Option 3: `flutter_adaptive_scaffold` (Google Official)

#### Description
Official Google package for adaptive layouts with Material 3 support.

#### Package
`flutter_adaptive_scaffold` (pub.dev)

#### Features
- Official Google package
- Automatic breakpoints (phone, tablet, desktop)
- Supports navigation rail, drawer, bottom nav
- Built-in animations
- Material 3 design

#### Example
```dart
AdaptiveScaffold(
  destinations: [
    NavigationDestination(icon: Icon(Icons.list), label: 'Todos'),
  ],
  smallBody: (_) => TodoListScreen(), // Phone
  body: (_) => Row([
    Expanded(child: TodoListPane()),
    Expanded(child: TodoDetailPane()),
  ]), // Tablet/Desktop
)
```

#### Pros
- ✅ Official Google support
- ✅ Material 3 design
- ✅ Handles most responsive patterns
- ✅ Good documentation
- ✅ Active maintenance

#### Cons
- ❌ Opinionated design
- ❌ May be overkill for simple apps
- ❌ External dependency

#### Best For
- Material 3 apps
- Want official solution
- Complex navigation needs

---

### Option 4: Custom Navigator 2.0 with Nested Routes

#### Description
Use Flutter's declarative navigation (Navigator 2.0) for full control over routing and navigation state.

#### How It Works
- Define nested routes for split view
- Control which pane shows what
- Handle deep linking

#### Pros
- ✅ Maximum flexibility
- ✅ Deep linking support
- ✅ Full control over back button behavior
- ✅ URL-based navigation

#### Cons
- ❌ Complex to implement
- ❌ Steep learning curve
- ❌ More boilerplate code
- ❌ Can be overwhelming

#### Best For
- Complex navigation requirements
- Web app with URLs
- Advanced use cases

---

### Option 5: Dual-Pane with Route-based State (Hybrid)

#### Description
Keep existing navigation for phone, intercept on tablet to show in right pane.

#### How It Works
```dart
class ResponsiveTodoScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLargeScreen = MediaQuery.of(context).size.width > 700;
    final selectedTodo = ref.watch(selectedTodoProvider);

    if (isLargeScreen) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: TodoListPane(
              onTodoSelected: (todo) {
                ref.read(selectedTodoProvider.notifier).state = todo;
              },
            ),
          ),
          VerticalDivider(width: 1),
          Expanded(
            flex: 3,
            child: selectedTodo != null
                ? TodoDetailPane(todo: selectedTodo)
                : EmptySelectionPane(),
          ),
        ],
      );
    } else {
      // Keep existing navigation for phone
      return TodoListScreen();
    }
  }
}
```

#### Pros
- ✅ Reuse existing screens
- ✅ Minimal refactoring
- ✅ Gradual migration
- ✅ Works with current code

#### Cons
- ❌ Need to handle two navigation paradigms
- ❌ Can get complex with deep navigation
- ❌ More state management

#### Best For
- Existing app with navigation already built
- Gradual migration
- Want to reuse current screens

---

## Handling Dialogs in Split View

### Option A: Replace Dialogs with Inline Forms (Recommended)

**Description:**
- Instead of `showDialog()`, show form in right pane
- More "iPad-like" experience
- Keep list always visible

**Implementation:**
```dart
if (isLargeScreen) {
  // Update state to show form in right pane
  ref.read(selectedTodoProvider.notifier).state = newTodo;
} else {
  // Show full-screen dialog on phone
  showDialog(context: context, builder: (_) => TodoForm());
}
```

**Best For:**
- Native iPad feel
- Always-visible list
- Smooth transitions

---

### Option B: Adaptive Dialog Positioning

**Description:**
- Phone: Standard full-screen dialog
- Tablet: Dialog positioned on right side

**Implementation:**
```dart
void showAdaptiveDialog(BuildContext context, Widget dialog) {
  final isLargeScreen = MediaQuery.of(context).size.width > 700;

  if (isLargeScreen) {
    // Show as card in right pane
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        pageBuilder: (_, __, ___) => Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: dialog,
          ),
        ),
      ),
    );
  } else {
    // Standard full-screen dialog on phone
    showDialog(context: context, builder: (_) => dialog);
  }
}
```

**Best For:**
- Quick implementation
- Keep existing dialogs
- Minimal refactoring

---

### Option C: Modal on Right Side

**Description:**
- Use `showGeneralDialog` with custom positioning
- Dialog appears over right pane only
- Left pane remains interactive

**Best For:**
- Quick edits
- Don't need full detail view
- Modal workflow preference

---

## Breakpoint Strategy

### Common Breakpoints

```dart
// Phone portrait
width < 600dp → Single pane, full-screen navigation

// Phone landscape / Small tablet portrait
600dp ≤ width < 840dp → Optional split or single pane

// Tablet landscape / Desktop
width ≥ 840dp → Split view (master-detail)

// Large desktop
width ≥ 1200dp → Three panes or wider split
```

### Recommended for TODO App

```dart
const double kTabletBreakpoint = 700.0;

bool isLargeScreen(BuildContext context) {
  return MediaQuery.of(context).size.width >= kTabletBreakpoint;
}
```

---

## Recommended Implementation Plan

### Phase 1: Basic Split View (Recommended Start)

**Approach:** Option 1 - LayoutBuilder + State Management

**Why:**
- You already have working screens
- Minimal refactoring needed
- Full control over behavior
- Easy to understand and maintain

**Steps:**
1. Create a new `ResponsiveTodoScreen` widget
2. Use `LayoutBuilder` to detect screen size
3. On large screens: `Row([TodoListPane, TodoDetailPane])`
4. Use Riverpod state to track selected todo
5. Replace dialogs with inline forms in right pane

**Estimated Effort:** 4-6 hours

**Files to Create:**
```
lib/presentation/responsive/
  ├── responsive_todo_screen.dart
  ├── todo_list_pane.dart
  ├── todo_detail_pane.dart
  └── adaptive_dialog_helper.dart

lib/presentation/providers/
  └── selected_todo_provider.dart
```

---

### Phase 2: Polish & Animations (Optional)

**If needed later:**
- Add `flutter_adaptive_scaffold` for polish
- Implement smooth transitions
- Add Material 3 styling
- Handle edge cases

**Estimated Effort:** 2-4 hours

---

## Key Considerations

### 1. State Management

**Challenge:**
- Selected item needs to be in state (Riverpod provider)
- List and detail panes both watch this state
- Phone version uses navigation, tablet version uses state

**Solution:**
```dart
final selectedTodoProvider = StateProvider<Todo?>((ref) => null);

// In list pane
onTap: (todo) {
  if (isLargeScreen) {
    ref.read(selectedTodoProvider.notifier).state = todo;
  } else {
    Navigator.push(...); // Existing navigation
  }
}

// In detail pane
final selectedTodo = ref.watch(selectedTodoProvider);
```

---

### 2. Back Button Behavior

**Challenge:**
- On tablet: Should clear selection, not pop route
- On phone: Should pop route normally

**Solution:**
```dart
WillPopScope(
  onWillPop: () async {
    if (isLargeScreen && selectedTodo != null) {
      ref.read(selectedTodoProvider.notifier).state = null;
      return false; // Don't pop
    }
    return true; // Allow pop
  },
  child: ...,
)
```

---

### 3. Deep Linking

**Challenge:**
- If user shares a link to a specific todo
- On tablet: Should show list + selected item
- On phone: Should navigate to detail screen

**Solution:**
```dart
// On app launch with deep link
if (isLargeScreen) {
  ref.read(selectedTodoProvider.notifier).state = todo;
} else {
  Navigator.pushNamed(context, '/todo/$todoId');
}
```

---

### 4. Keyboard Handling

**Challenge:**
- On iPad with keyboard, need to handle shortcuts
- Cmd+W to close, Escape to deselect, etc.

**Solution:**
```dart
Focus(
  onKey: (node, event) {
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      ref.read(selectedTodoProvider.notifier).state = null;
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  },
  child: ...,
)
```

---

### 5. Rotation Handling

**Challenge:**
- Portrait → Landscape: Keep selection
- Landscape → Portrait: Decide to show detail or list

**Solution:**
```dart
// Keep selection in state, let layout rebuild
// State persists across orientation changes

// Option: Show detail in portrait if something selected
if (!isLargeScreen && selectedTodo != null) {
  // Navigate to detail screen
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.push(...);
    ref.read(selectedTodoProvider.notifier).state = null;
  });
}
```

---

## Example File Structure

```
lib/
├── presentation/
│   ├── responsive/
│   │   ├── responsive_todo_screen.dart    # Main responsive container
│   │   ├── todo_list_pane.dart            # Left pane (reusable)
│   │   ├── todo_detail_pane.dart          # Right pane (reusable)
│   │   ├── empty_selection_pane.dart      # Placeholder when nothing selected
│   │   └── adaptive_dialog_helper.dart    # Dialog utilities
│   │
│   ├── screens/
│   │   ├── todo_list_screen.dart          # Phone version (existing)
│   │   └── todo_detail_screen.dart        # Phone version (existing)
│   │
│   └── providers/
│       └── selected_todo_provider.dart    # State for selection
│
└── infrastructure/
    └── config/
        └── responsive_config.dart         # Breakpoints and constants
```

---

## Design Decisions to Make

### 1. When should the detail pane show?

**Options:**
- **A. Always show (empty state when nothing selected)** ← Recommended
  - Shows "Select a todo to edit" placeholder
  - Consistent layout
  - Clear affordance

- **B. Only when item selected**
  - List takes full width when nothing selected
  - More dynamic
  - Can be confusing

- **C. Placeholder content when empty**
  - Show tips, stats, or quick actions
  - More engaging
  - More work to implement

---

### 2. How to handle creation?

**Options:**
- **A. Right pane shows "create new" form** ← Recommended
  - Consistent with edit flow
  - List remains visible
  - Native iPad feel

- **B. Dialog on phone, inline on tablet**
  - Different experiences
  - More complexity

- **C. Always use dialog**
  - Simplest
  - Less iPad-optimized

---

### 3. What about lists view?

**Options:**
- **A. Keep current drawer for lists** ← Recommended for now
  - Minimal changes
  - Familiar pattern

- **B. Three-column layout (lists | todos | detail)**
  - Very desktop-like
  - Complex to implement
  - Maybe later

- **C. Tabs for lists**
  - Simple
  - Limited to few lists

---

### 4. Animations?

**Options:**
- **A. Smooth fade when changing selection** ← Recommended
  - Polished feel
  - Easy to implement

- **B. Slide transitions**
  - More dynamic
  - Can be distracting

- **C. No animations (start simple)**
  - Fastest implementation
  - Can add later

---

## Testing Plan

### Devices to Test

1. **iPhone (Phone)**
   - Portrait: Single pane with navigation
   - Landscape: Consider staying single pane or small split

2. **iPad (Tablet)**
   - Portrait: Single pane or compact split
   - Landscape: Full split view (target)

3. **iPad Pro (Large Tablet)**
   - Portrait: Compact split or single pane
   - Landscape: Wide split view

### Test Cases

- [ ] Create todo on phone → full screen
- [ ] Create todo on iPad landscape → shows in right pane
- [ ] Select todo on iPad → shows in right pane
- [ ] Rotate iPad portrait → landscape → keeps selection
- [ ] Back button on phone → pops navigation
- [ ] Back button on iPad → clears selection (doesn't pop)
- [ ] Deep link on phone → navigates to detail
- [ ] Deep link on iPad → shows list + detail
- [ ] Multiple selections → smooth transitions
- [ ] Empty state → shows placeholder

---

## Resources

### Flutter Documentation
- [Adaptive Apps](https://docs.flutter.dev/development/ui/layout/adaptive-responsive)
- [Building Adaptive Apps](https://docs.flutter.dev/development/ui/layout/building-adaptive-apps)
- [LayoutBuilder](https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html)

### Packages
- [flutter_adaptive_scaffold](https://pub.dev/packages/flutter_adaptive_scaffold)
- [adaptive_navigation](https://pub.dev/packages/adaptive_navigation)
- [responsive_framework](https://pub.dev/packages/responsive_framework)

### Design Inspiration
- Apple Mail on iPad
- Apple Notes on iPad
- Google Keep on tablet
- Microsoft To Do on tablet

---

## Next Steps

1. **Decide on approach** (Recommendation: Option 1 - LayoutBuilder)
2. **Define breakpoints** (Recommendation: 700dp for tablet)
3. **Create state management** (selectedTodoProvider)
4. **Build responsive container** (ResponsiveTodoScreen)
5. **Create panes** (TodoListPane, TodoDetailPane)
6. **Test on simulator** (iPad Pro 13-inch)
7. **Polish and animate** (optional)
8. **Test on physical iPad** (your device)

---

## Summary

**Recommended Approach:**
- Start with **Option 1: LayoutBuilder + Riverpod State**
- Use **inline forms** instead of dialogs on tablet
- Implement **smooth fade animations** for polish
- Test on **iPad simulator first**, then physical device

**Estimated Total Effort:**
- Basic implementation: 4-6 hours
- Polish and animations: 2-4 hours
- Testing and refinement: 2-3 hours
- **Total: 8-13 hours**

**Benefits:**
- ✅ Better iPad user experience
- ✅ Modern, native-feeling interface
- ✅ Reusable components
- ✅ Scalable to desktop later
- ✅ Aligns with platform conventions

This can be implemented as a separate feature after CloudKit sync is complete and tested.
