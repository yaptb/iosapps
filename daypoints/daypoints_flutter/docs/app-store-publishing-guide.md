# Publishing DayPoints to the Apple App Store

A step-by-step tutorial for a first-time iOS app publisher.

---

## What you will need

- A Mac with Xcode installed (already done)
- An **Apple Developer Program** membership ($99/year) — if you don't have one, enroll at [developer.apple.com/programs/enroll](https://developer.apple.com/programs/enroll) and wait for approval (can take 24–48 hours)
- The Apple ID you used to enroll in the Developer Program
- App Store screenshots (detailed in the [Screenshots](#6-prepare-screenshots-and-metadata) section)

---

## Overview

The process has six stages:

1. Register your app's bundle ID in Apple's developer portal
2. Create the App Store listing in App Store Connect
3. Configure Xcode signing
4. Build a release archive and upload it
5. Fill in metadata and attach the build
6. Submit for review

---

## 1. Register the Bundle ID

The bundle ID uniquely identifies your app across Apple's systems. DayPoints's is currently set to `com.daypoints.daypoints`. You may want to change this to something tied to your personal developer account (e.g. `com.yourname.daypoints`) — if so, do it now, before registering anything.

**To change the bundle ID (optional but recommended):**

Open Xcode:

```bash
open ios/Runner.xcworkspace
```

1. Click the **Runner** project in the left sidebar (the top-level item, not a folder)
2. Select the **Runner** target
3. Go to the **Signing & Capabilities** tab
4. Change the **Bundle Identifier** field to your preferred value

This also updates `project.pbxproj` automatically. Commit the change before proceeding.

**To register the bundle ID with Apple:**

1. Go to [developer.apple.com](https://developer.apple.com) and sign in
2. Navigate to **Certificates, Identifiers & Profiles** → **Identifiers**
3. Click **+** to add a new identifier
4. Choose **App IDs** → **App**
5. Enter a **Description** (e.g. "DayPoints") and your **Bundle ID** (explicit, not wildcard — paste the exact string from Xcode)
6. Under **Capabilities**, you don't need to enable anything for DayPoints (no push notifications, no iCloud, etc.)
7. Click **Continue**, then **Register**

---

## 2. Create the App Store Connect Listing

App Store Connect is where you manage your app's listing, pricing, and review submissions.

1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com) and sign in with your Apple ID
2. Click **Apps** → **+** → **New App**
3. Fill in the form:
   - **Platforms:** iOS
   - **Name:** DayPoints (this is what users see on the App Store — max 30 characters)
   - **Primary Language:** English (or your preference)
   - **Bundle ID:** Select the one you just registered
   - **SKU:** Any unique internal identifier you want (e.g. `daypoints-v1`). Users never see this.
   - **User Access:** Full Access (unless you have a team)
4. Click **Create**

You'll land on the app's page. Leave it open — you'll fill in the rest of the metadata in Step 6.

---

## 3. Configure Xcode Signing

Xcode needs to sign your app with your developer credentials before it can be distributed.

Open the workspace:

```bash
open ios/Runner.xcworkspace
```

1. Click the **Runner** project → **Runner** target → **Signing & Capabilities** tab
2. Check **Automatically manage signing**
3. Set **Team** to your Apple Developer account (sign in via Xcode → Settings → Accounts if it's not listed)
4. Confirm the **Bundle Identifier** matches what you registered

Xcode will automatically create a provisioning profile for you. If you see any errors in red, they will usually self-resolve once you've selected the correct team.

---

## 4. Build and Upload the Release Archive

This step compiles DayPoints for distribution and sends it to App Store Connect.

### 4a. Set the version number

In `pubspec.yaml`, the `version` field controls both the marketing version and the build number:

```yaml
version: 1.0.0+1
#        ^^^^^  build name (shown to users, e.g. "1.0.0")
#               ^ build number (integer, must increment with each upload)
```

For a first submission, `1.0.0+1` is fine.

### 4b. Run Flutter's iOS release build

Flutter builds the Dart code and hands off to Xcode:

```bash
flutter build ipa
```

This produces an `.ipa` file at `build/ios/ipa/daypoints.ipa` and (if needed) opens Xcode to complete the archive. Alternatively, to do it through Xcode manually:

```bash
flutter build ios --release
```

Then in Xcode: **Product → Archive**. Xcode will compile and open the **Organizer** window when done.

### 4c. Upload via Xcode Organizer

1. In the Organizer window, select your archive
2. Click **Distribute App**
3. Choose **App Store Connect** → **Upload**
4. Leave all checkboxes at their defaults (bitcode, symbols, etc.)
5. Click **Upload**

The upload takes a few minutes. Once complete, the build will appear in App Store Connect under your app → **TestFlight** (it processes there first, which takes 5–15 minutes).

---

## 5. Prepare Screenshots and Metadata

App Store Connect requires screenshots before you can submit. Apple requires at least one device size; providing multiple is better for ranking.

### Required screenshot sizes

| Device | Screen size label |
|---|---|
| 6.9" (iPhone 16 Pro Max) | 1320 × 2868 px |
| 6.5" (iPhone 11 Pro Max, 12/13/14 Plus) | 1284 × 2778 px |
| 5.5" (iPhone 8 Plus) | 1242 × 2208 px |

Providing the 6.9" size is mandatory for new submissions as of 2024.

### How to take screenshots in the iOS Simulator

```bash
# Boot and run on a specific device
open -a Simulator
flutter run -d "iPhone 16 Pro Max"
```

In the simulator: **File → Take Screenshot** (saves to Desktop), or use `Cmd+S`.

Take screenshots of:
- The timer list (with a couple of sample timers visible)
- The timer detail screen
- The onboarding flow
- The edit form

Aim for 3–5 screenshots that tell the app's story. You can add text overlays using tools like Figma, Sketch, or [screenshots.so](https://screenshots.so).

---

## 6. Fill in App Store Metadata

Back in App Store Connect, click on your app → the **1.0 Prepare for Submission** section.

### App Information (under the General section)

- **Category:** Productivity (or Lifestyle)
- **Content Rights:** Check "This app does not contain, display, or access third-party content"

### Pricing and Availability

- Click **Pricing and Availability** in the left sidebar
- Set **Price** to **Free** (or your preferred tier)
- Leave **Availability** as all countries unless you want to restrict

### 1.0 Prepare for Submission

Fill in:

| Field | Notes |
|---|---|
| **Screenshots** | Upload the screenshots you took. Drag into the 6.9" slot first. |
| **App Preview** | Optional short video. Skip for v1. |
| **Promotional Text** | Up to 170 chars. Shown above the description. Can be updated without a new app submission. |
| **Description** | Up to 4000 chars. Explain what DayPoints does. Plain text only — no markdown. |
| **Keywords** | Up to 100 chars, comma-separated. Think: "countdown timer, days until, life events, anniversary, sobriety tracker" |
| **Support URL** | Required. Use a GitHub repo URL, a simple landing page, or even a mailto link. |
| **Marketing URL** | Optional. |
| **Version** | 1.0.0 |
| **Copyright** | e.g. "2026 Your Name" |

**Rating:** Click **Edit** next to the age rating and answer the questionnaire. DayPoints has no objectionable content, so it will land at **4+**.

**Build:** Under the **Build** section, click **+** and select the build you uploaded in Step 4. (It must have finished processing — check the status under TestFlight.)

**App Review Information:**

- **Sign-in required:** No
- **Notes for reviewer:** Optional but helpful. Example: *"DayPoints is a countdown/count-up tracker for life events. No login or account required. Data is stored locally on device."*
- **Contact info:** Your email and phone number (not shown to users, only to Apple's review team)

---

## 7. Submit for Review

Once everything has a green checkmark:

1. Click **Add for Review** (top right of the submission page)
2. Confirm the submission
3. The status will change to **Waiting for Review**

Apple's review typically takes **24–48 hours** for a first submission, sometimes longer. You'll receive an email when it's approved or if there are issues to fix.

---

## Common First-Timer Issues

**"Missing compliance" warning after upload**
Flutter apps don't use custom encryption, so you can answer **No** to the export compliance question. You can pre-answer this in `Info.plist` to avoid the prompt entirely:

```xml
<!-- ios/Runner/Info.plist -->
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```

**"No accounts with App Store distribution" in Xcode**
You need to enroll in the Apple Developer Program (paid, $99/year), not just have a free Apple Developer account.

**Build not appearing in App Store Connect**
Processing usually takes 5–15 minutes. Refresh the page. If it's been over an hour, check your email — Apple sometimes sends a rejection email for builds with issues (rare).

**"Invalid Bundle ID" on upload**
The bundle ID in Xcode must exactly match what you registered in the Developer Portal. Re-check for typos.

**Review rejection: "We were unable to review your app"**
This almost always means a crash on launch in the reviewer's environment. Run `flutter analyze` and `flutter test`, then test a clean install on a real device (not just a simulator) before resubmitting.

---

## After Approval

Once approved:

- The app goes live on the App Store within minutes (sometimes up to 24 hours)
- You can find your App Store link in App Store Connect under **App Information → View on App Store**
- For future updates: bump `version` in `pubspec.yaml`, rebuild, upload, and submit a new version in App Store Connect — no need to redo the metadata from scratch

---

## Quick Reference: Key Files

| Purpose | Location |
|---|---|
| App version & build number | `pubspec.yaml` → `version:` |
| Bundle ID | Xcode → Runner target → Signing & Capabilities |
| App display name | `ios/Runner/Info.plist` → `CFBundleDisplayName` |
| Encryption declaration | `ios/Runner/Info.plist` → `ITSAppUsesNonExemptEncryption` |
| iOS deployment target | Xcode → Runner target → General → Minimum Deployments |
