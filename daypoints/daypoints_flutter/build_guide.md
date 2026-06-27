# DayPoints — Building & Testing on a Physical Device

## Prerequisites

- Xcode 26+ installed
- Flutter 3.38+ installed
- An Apple ID (free or paid Developer account)

---

## Step 1 — Apple Developer Account

You need an Apple Developer account to install apps on real devices.

- **Free account** (personal team): apps expire every 7 days, limited devices. Enough for testing.
- **Paid ($99/yr)**: no expiry, required for App Store distribution.

Sign in at [developer.apple.com](https://developer.apple.com) — a free account is created automatically with your Apple ID.

---

## Step 2 — Sign in to Xcode

1. Open Xcode
2. **Xcode → Settings → Accounts → +** → Apple ID → sign in
3. A "Personal Team" will appear under your account

---

## Step 3 — Connect & Trust Your Device

1. Plug in your iPhone or iPad via USB
2. On the device: tap **Trust** when prompted, enter your passcode
3. Your device should appear in Xcode's device picker (top bar)

---

## Step 4 — Configure Signing in Xcode

Open the project workspace:

```bash
open ios/Runner.xcworkspace
```

In Xcode:

1. Click **Runner** in the left sidebar → select the **Runner** target
2. Go to **Signing & Capabilities** tab
3. Check **Automatically manage signing**
4. Set **Team** to your personal team
5. Bundle ID is `com.parsecxr.daypoints` — change to something unique (e.g. `com.yourname.daypoints`) if you hit a conflict

Repeat for both **Debug** and **Release** configurations (dropdown at the top of the Signing tab).

---

## Step 5 — Enable Developer Mode on Device (iOS 16+)

On your iPhone or iPad:

**Settings → Privacy & Security → Developer Mode** → toggle on → restart

---

## Step 6 — Run from Flutter

Once signing is configured, drive everything from the terminal:

```bash
# List connected devices
flutter devices

# Run on iPhone (use the name or ID shown by flutter devices)
flutter run -d "Keith's iPhone"

# Run on iPad
flutter run -d "Keith's iPad"

# Release build — faster, no debug overhead, good for real-world feel
flutter run --release -d "Keith's iPhone"
```

Flutter compiles, signs, and installs the app automatically.

---

## Step 7 — Running on Both Devices Simultaneously

Open two terminals and run each independently:

```bash
# Terminal 1
flutter run -d <iphone-id>

# Terminal 2
flutter run -d <ipad-id>
```

---

## Troubleshooting

| Problem | Fix |
|---|---|
| "Untrusted Developer" on device | Settings → General → VPN & Device Management → trust your team |
| Code signing errors in Xcode | Make sure Team is set for all targets (Runner + RunnerTests) |
| App installs but crashes immediately | Run `flutter run` (not `--release`) to see logs in terminal |
| Device not appearing in `flutter devices` | Unplug/replug, trust again; or restart usbmuxd: `sudo killall -STOP -c usbmuxd` |
| Pods error during build | `cd ios && pod install --repo-update` |
