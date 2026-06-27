/// Debug configuration for the application
///
/// Contains debug flags for development purposes.
/// Remember to set appropriate values for production builds.
class DebugConfig {
  /// Force onboarding wizard to show on every app launch
  ///
  /// Set to true during development to test the onboarding flow repeatedly.
  /// Set to false for production builds to show onboarding only on first launch.
  static const bool kForceOnboarding = true;

  /// Enable CloudKit synchronization
  ///
  /// Set to false to disable CloudKit sync (useful for simulator testing or development).
  /// Set to true to enable CloudKit sync (requires physical iOS device with iCloud).
  ///
  /// Note: CloudKit only works on physical iOS devices, not in the simulator.
  /// When false, the app will work in local-only mode with all data stored in SQLite.
  static const bool kEnableCloudKitSync = false;

  /// Private constructor to prevent instantiation
  DebugConfig._();
}
