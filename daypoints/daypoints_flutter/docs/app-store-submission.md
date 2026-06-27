# DayPoints — App Store Submission Guide

## Overview

This document walks through preparing and submitting DayPoints to the Apple App Store.
Bundle ID: `com.parsecxr.daypoints` | Team: `RR2K27U7MF`

---

## Step 1: App Store Connect — Create the App Record

1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com) and sign in
2. Click **+** → **New App**
3. Fill in:
   - **Platform:** iOS
   - **Name:** DayPoints
   - **Primary Language:** English (Australia) or English (U.S.)
   - **Bundle ID:** select `com.parsecxr.daypoints` from the dropdown (it appears after the first Xcode build)
   - **SKU:** `daypoints-ios-1` (any unique internal string, never shown to users)
   - **User Access:** Full Access
4. Click **Create**

---

## Step 2: App Information

In App Store Connect → your app → **App Information**:

| Field | Value |
|---|---|
| Name | DayPoints |
| Subtitle | Count down to what matters (30 char max) |
| Category (Primary) | Utilities |
| Category (Secondary) | Lifestyle |
| Content Rights | Does not contain third-party content |

**Privacy Policy URL** — Required before submission. You must host a privacy policy at a public URL. Since DayPoints stores all data locally and collects nothing, a minimal policy stating that is sufficient. Host it on GitHub Pages, Notion, or similar.

---

## Step 3: Pricing and Availability

In **Pricing and Availability**:

- **Price:** Free (or set a tier if paid)
- **Availability:** All territories (or restrict as needed)
- **Pre-order:** Skip unless you want a pre-order campaign

---

## Step 4: App Icon

The Xcode project already has the full icon set at `ios/Runner/Assets.xcassets/AppIcon.appiconset/`. All sizes are wired up. The only file you need to produce is:

**`Icon-App-1024x1024@1x.png`** — the master icon
- 1024 × 1024 px
- PNG, RGB, no transparency (alpha channel will be rejected)
- No rounded corners — iOS applies the mask automatically

Replace the placeholder file at that path. Xcode auto-derives all smaller sizes from it if you use a tool like [Makeappicon](https://makeappicon.com) or [App Icon Generator](https://appicon.co) to regenerate the full set, or just supply the 1024px source and let Xcode use it for the App Store marketing icon.

> **Note:** The 1024×1024 `ios-marketing` icon is what App Store Connect shows publicly. All other sizes are used on-device. Make sure they match visually.

---

## Step 5: Screenshots

App Store Connect requires screenshots for specific device sizes. You need at minimum:

### Required
| Device | Resolution | Simulator to use |
|---|---|---|
| iPhone 6.9" (16 Pro Max) | 1320 × 2868 px | iPhone 16 Pro Max |
| iPad Pro 13" (M4) | 2064 × 2752 px | iPad Pro 13-inch (M4) |

### How to capture
1. Run the app in the target simulator: `flutter run -d "iPhone 16 Pro Max"`
2. Set up a representative timer list (use real-looking data, not placeholder text)
3. In Simulator: **File → Save Screen** or press `Cmd+S` to save a screenshot
4. Capture 3–5 screens showing the core flow:
   - Timer list (populated with a few timers)
   - Timer detail screen (large countdown)
   - Edit/create screen
   - Settings screen (optional)

### Tips
- Use the light theme and dark theme variants — you can submit up to 10 per device
- Remove the debug banner before capturing (it's already disabled in the app: `debugShowCheckedModeBanner: false`)
- Screenshots must be exact pixel dimensions — Simulator captures are already at native resolution
- You can add device frames and marketing text using tools like [Screenshots.pro](https://screenshots.pro) or Sketch/Figma, but plain screenshots are accepted

---

## Step 6: App Description and Metadata

In App Store Connect → **App Store** → your version → **App Store Information**:

### Description (up to 4000 characters)
Write 2–4 paragraphs. Lead with the core value proposition, then features. Example structure:
```
DayPoints turns the dates that matter into a living countdown on your home screen.

Whether you're tracking days until retirement, days sober, days until graduation, 
or simply how long you've been married — DayPoints shows you exactly where you 
stand, updated every day.

Features:
• Count down to future events or count up from past ones — direction is automatic
• Choose from curated icons and colors to personalize each timer  
• Reorder timers by dragging to put what matters most front and center
• Light and dark themes with Material 3 design

All data stays on your device. No account, no sync, no ads.
```

### Keywords (up to 100 characters, comma-separated)
Keywords are separate from the description — the description is not indexed.
```
countdown,days,counter,timer,milestone,retirement,sober,anniversary,date,tracker
```

### Promotional Text (up to 170 characters)
Can be updated without a new app version — useful for seasonal messaging:
```
Count down to what matters. Count up from what changed you.
```

### Support URL
Required. Can be a GitHub repo URL, a simple landing page, or an email link:
`https://github.com/yourusername/daypoints` or `mailto:keefatiinetnetau@gmail.com`

### Marketing URL
Optional. Leave blank if you don't have a landing page.

---

## Step 7: Age Rating

In **App Information** → **Age Rating**:

Run through the questionnaire. DayPoints has no objectionable content:
- No violent/mature content
- No gambling
- No user-generated content
- No social networking

Result will be **4+** (the lowest rating).

---

## Step 8: Build the Archive and Upload

### In Xcode

1. Set the scheme back to **Release**: Scheme → Edit Scheme → Run → Build Configuration → Release
2. Set the destination to **Any iOS Device (arm64)** (top toolbar — select a generic device, not a specific simulator)
3. **Product → Archive**
4. Xcode builds and opens the **Organizer** window when done
5. Click **Distribute App** → **App Store Connect** → **Upload**
6. Follow the prompts (use automatic signing)
7. The build appears in App Store Connect under **TestFlight** within ~15 minutes

### Alternatively, from the command line
```bash
flutter build ipa
```
Then open the `.xcarchive` from `build/ios/archive/` in Xcode Organizer to upload, or use `xcrun altool` / `xcrun notarytool`.

---

## Step 9: TestFlight (Optional but Recommended)

Before submitting for review, test the uploaded build:

1. In App Store Connect → **TestFlight**
2. Add yourself as an internal tester
3. Install **TestFlight** on your device and accept the invite
4. Install and smoke-test the production binary

This confirms the release build works correctly before Apple reviews it.

---

## Step 10: Submit for Review

1. In App Store Connect → your app → **+** next to the version number to create a version (e.g., `1.0`)
2. Select your uploaded build
3. Fill in **What's New** (for 1.0 this can be "Initial release")
4. Complete **App Review Information**:
   - Contact name and email
   - Demo notes: "No login required. Tap + to create a timer, pick a date, and save."
   - Sign-in required: No
5. Click **Add for Review** → **Submit to App Review**

Review typically takes 24–48 hours for a new app.

---

## Checklist

- [ ] App record created in App Store Connect
- [ ] Privacy policy hosted at a public URL
- [ ] 1024×1024 app icon (no alpha)
- [ ] iPhone 6.9" screenshots (min 1, up to 10)
- [ ] iPad Pro 13" screenshots (min 1, up to 10)
- [ ] Description written
- [ ] Keywords filled in (under 100 chars)
- [ ] Support URL set
- [ ] Age rating questionnaire completed
- [ ] Build archived and uploaded via Xcode
- [ ] TestFlight smoke test passed
- [ ] Submitted for review
