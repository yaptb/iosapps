# App Store Publishing Guide

## Overview

This doc collects the App Store Connect metadata (marketing copy, keywords)
and the permission/capability disclosures you'll need when submitting
TodoRedo, given the notification-reminder and in-app-review features added
in this app.

---

## App Store Metadata

### App Name
```
TodoRedo
```

### Subtitle (30 characters max)
```
Recurring Tasks & Reminders
```

### Promotional Text (170 characters max — editable anytime without review)
```
Organize your day with recurring todos and smart reminders. Simple,
fast, and built to keep you on track — no clutter, no distractions.
```

### Description (4000 characters max)
```
TodoRedo is a simple, powerful to-do app built for people who want their
task list to actually work the way they think — recurring chores that
come back on schedule, reminders that show up right when you need them,
and lists that keep everything organized without the clutter.

FEATURES

• Recurring Tasks — Set up daily, weekly, monthly, or custom recurrence
  rules once. TodoRedo automatically creates your next task the moment
  you complete the current one, so nothing falls through the cracks.

• Smart Reminders — Attach a reminder to any task with a due date and
  get notified right on time. Manage your notification permissions
  anytime from Settings.

• Custom Lists — Organize tasks into color-coded, icon-labeled lists
  (Home, Work, Shopping, Fitness, and more) so everything has its place.

• Light & Dark Mode — Choose Light, Dark, or match your device's system
  setting — pick it during setup or change it anytime in Settings.

• Offline-First — Your tasks live on your device and work completely
  offline. No account required, no login screens, no waiting on a
  network.

• Clean, Focused Design — Built with Material 3 for a fast, modern
  interface that gets out of your way.

Whether you're managing daily chores, work deadlines, or personal
goals, TodoRedo helps you stay on top of what matters — without the
noise.
```

### Keywords (100 characters max, comma-separated, no spaces needed after commas)
```
todo,task,reminder,recurring,checklist,planner,productivity,organizer,to-do list,daily tasks
```
A few notes on keyword selection:
- Apple's search indexes the **App Name** and **Subtitle** too, so don't
  repeat "TodoRedo" or "reminders"/"recurring" in the keyword field itself
  — those are already covered by the name/subtitle above.
- Avoid keyword-stuffing plurals of the same word (e.g. "task" and "tasks")
  — Apple's search already matches word stems, so it's wasted character
  budget.
- Consider swapping in seasonal or competitor-adjacent terms (e.g.
  "habit tracker", "gtd") if you find the above aren't converting once you
  have App Analytics data.

### Category
- **Primary:** Productivity
- **Secondary:** Utilities

---

## Permissions & Privacy Disclosures

### Notifications — no extra Info.plist key required

Local notification permission (used for todo reminders, via
`flutter_local_notifications` / `UNUserNotificationCenter`) is a
**runtime permission**, not an Info.plist-declared one. Unlike camera,
location, or contacts access, iOS does **not** require an
`NSUsageDescription`-style key in `Info.plist` for local notifications —
there's nothing to add there.

What you *do* need to get right:
- **No "Push Notifications" capability needed.** This app only schedules
  **local** notifications — there's no APNs/remote-push integration, so
  do not enable the "Push Notifications" capability in Xcode or request
  an APNs entitlement. Adding it unused can complicate review for no
  benefit.
- The permission prompt itself (triggered by `requestPermissions()` in
  `notification_settings_screen.dart` and during onboarding in
  `permissions_request_page.dart`) shows the standard iOS system dialog.
  Apple's App Review Guideline 5.1.1 expects the *reason* for the request
  to be clear from context — the onboarding page's "Permissions" info
  screen (`permissions_info_page.dart`) already explains why before the
  OS prompt appears, which satisfies this.
- **App Privacy questionnaire (App Store Connect):** notification
  permission itself isn't a data type you disclose on the privacy
  "nutrition label." Since reminders and todos are stored locally with no
  account/login and (with `DebugConfig.kEnableCloudKitSync = false` at
  submission time) no network transmission, you should be able to answer
  **"Data Not Collected"** for this submission.
  - ⚠️ If you flip `kEnableCloudKitSync = true` before shipping (i.e. you
    ship with iCloud sync live), you'll need to revisit this — iCloud
    sync means user content leaves the device via CloudKit, and Apple's
    privacy label will need an entry (typically "Identifiers"/"User
    Content" linked to the user, used for App Functionality only, not
    tracking). See `CLOUDKIT_SYNC_PLAN.md` for the sync design. As of this
    doc, CloudKit is **disabled by default** for release builds, so this
    likely doesn't apply yet.

### In-App Review Prompt (`in_app_review` — App Store review reminder)

Not a permission, but worth flagging since it's new: the 7th-launch
review prompt uses `SKStoreReviewController` under the hood (via the
`in_app_review` plugin). Apple **rate-limits this to 3 requests per
365 days per user, automatically** — your app can *ask* more often, but
iOS silently no-ops extra requests, and this is exactly the reason
`AppLaunchTracker` (`lib/infrastructure/config/app_launch_tracker.dart`)
also persists a one-time `review_requested` flag so it doesn't keep
retrying every session for the same user. No entitlement or Info.plist
change is needed for this either — just don't add your own additional
manual "Rate Us" button that calls `requestReview()` on demand, since
Apple's guidelines (2.3.1, 5.6.1) expect you to use the system-provided
prompt as-is, not wrap it in custom UI that pressures the user.

### Existing capabilities to double check before submission
- **iCloud/CloudKit** — per `CLAUDE.md`/`CLOUDKIT_SYNC_PLAN.md`, this is
  still mid-implementation and behind `DebugConfig.kEnableCloudKitSync`
  (default `false`). If it's off, no iCloud entitlement needs to be
  present in the submitted build. If you turn it on for release, you'll
  need the iCloud capability + CloudKit container configured in Xcode
  (see `CLOUDKIT_DEBUG_SWITCH.md`) *and* the App Privacy label update
  mentioned above.

---

## Pre-Submission Checklist

- [ ] Verify `DebugConfig.kEnableCloudKitSync` matches what you intend to
      ship (currently `false`)
- [ ] Verify `DebugConfig.kForceOnboarding` is `false` for release builds
- [ ] App Privacy questionnaire answered per the Notifications section
      above ("Data Not Collected", unless CloudKit is enabled)
- [ ] No "Push Notifications" capability enabled in Xcode (not needed —
      local notifications only)
- [ ] Screenshots captured for required device sizes (6.9" and 6.5"
      iPhone at minimum; iPad if supporting iPad)
- [ ] App icon finalized (see `assets/images/check_mark_icon.png` as the
      current in-app icon source)
- [ ] Support URL and Marketing URL ready (App Store Connect requires a
      Support URL at minimum)
- [ ] Age rating questionnaire completed (should be 4+ — no objectionable
      content, no user-generated content shared with others)
