# DayPoints

A Flutter mobile app (iOS + Android) for tracking countdowns and count-ups to significant life events — days until retirement, days sober, days married, time until graduation, etc.

## Architecture

- **State management:** Riverpod (`flutter_riverpod`)
- **Storage:** Local-first via Hive CE (`hive_ce_flutter`) behind a `TimerRepository` interface; designed so a cloud-sync implementation can be slotted in later without changing consumers
- **Preferences:** `shared_preferences` for theme mode, accent color, onboarding-complete flag
- **Theming:** Material 3 with seeded color schemes, light/dark/system; Google Fonts (Inter body, Space Grotesk headlines)
- **Notifications:** none (deliberate scope decision for v1 — do not add scaffolding speculatively)

## Directory layout

```
lib/
  main.dart                       # App entry: init Hive, build ProviderScope, route to onboarding or home
  domain/                         # Pure Dart entities & display logic
    life_timer.dart               # LifeTimer entity (id, label, targetDate, format, color, icon, createdAt, sortOrder)
    timer_format.dart             # enum: days | yearsMonthsDays
    timer_display.dart            # Renders a LifeTimer + now into TimerDisplay (primary text, isPast)
  data/
    timer_repository.dart         # Abstract interface
    hive_timer_repository.dart    # Hive-backed impl (broadcast stream + yield-current-on-subscribe)
    app_preferences.dart          # shared_preferences wrapper
  providers/
    providers.dart                # All Riverpod providers (repo, prefs, settings, onboarding, ticker, timers stream)
  theme/
    app_theme.dart                # AppTheme.light/dark from seed color; AccentPalette curated colors
  ui/
    screens/
      onboarding_screen.dart      # 4-page PageView: intro slides + appearance + sample-seed toggle
      timer_list_screen.dart      # ReorderableListView, drawer, FAB
      timer_detail_screen.dart    # Per-timer view; orientation-aware (portrait vertical, landscape header row + centered countdown)
      timer_edit_screen.dart      # Create/edit form (label, date-only picker, format, color, icon)
      settings_screen.dart        # Theme mode + accent color
      about_screen.dart           # Static About page
    widgets/
      app_drawer.dart             # Hamburger menu: Settings + About
      timer_card.dart             # Tinted card with icon, label, countdown
  utils/
    icon_catalog.dart             # 24 curated Material icons for timer selection
test/
  widget_test.dart                # Unit tests for TimerDisplay + LifeTimer serialization
```

## Domain rules

- **Direction is auto-detected** from `targetDate` vs `now`. Future = count down. Past = count up. There is no manual direction toggle.
- **Dates are date-only.** All `targetDate` values are normalized to midnight (`DateTime(y, m, d)`) on save. The edit form does not show a time picker. Display formats never include time-of-day.
- **List ordering is manual.** `LifeTimer.sortOrder` is the source of truth; `HiveTimerRepository.getAll()` sorts ascending by `sortOrder`. Drag-reorder renormalizes to 0..n-1. New timers get `min - 1` so they insert at the top.
- **Onboarding seeds two samples** ("New Year" and next "Weekend") when the user opts in on the final onboarding page.

## Conventions

- Riverpod providers that need runtime values (repo, prefs) are declared with `throw UnimplementedError` and overridden in `main()`. Do not instantiate them lazily.
- Repository methods that mutate the box rely on `Box.listenable()` to feed the `_controller` broadcast stream. `watchAll()` yields the current `getAll()` snapshot before delegating to the stream so new subscribers don't sit on a spinner.
- For UI work, default to **centered** alignment when constraining or positioning a content block. Edge-alignment only when there's a specific reason.
- Detail screen and edit form both branch on `OrientationBuilder`/`MediaQuery.orientation` rather than width breakpoints.

## Commands

```bash
flutter pub get                                  # install deps
flutter analyze                                  # lint + type check (must be clean)
flutter test                                     # run unit tests
flutter run                                      # run on the currently-booted device/simulator
flutter run -d "iPhone 15 Pro"                   # run on a specific simulator
open -a Simulator                                # boot the default iOS simulator first if none is running
flutter build bundle                             # compile-only sanity check (no platform tools needed)
```

Android builds require an Android SDK, which is not installed on the dev machine as of 2026-06-23.
