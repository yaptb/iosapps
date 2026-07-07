import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // TODO: Register CloudKit handler when ready to test on physical device
    // Commented out for simulator testing (CloudKit doesn't work in simulator)
    // To enable: Add CloudKitHandler.swift to Xcode project, then uncomment below
    // let controller = window?.rootViewController as! FlutterViewController
    // CloudKitHandler.register(with: registrar(forPlugin: "CloudKitHandler")!)

    // flutter_local_notifications has no API to set the app icon badge
    // count independently of showing/scheduling a notification, so this is
    // a small dedicated channel handled directly here.
    if let controller = window?.rootViewController as? FlutterViewController {
      let badgeChannel = FlutterMethodChannel(
        name: "com.parsecxr.todoredo/badge",
        binaryMessenger: controller.binaryMessenger)
      badgeChannel.setMethodCallHandler { [weak self] call, result in
        guard call.method == "setBadgeCount",
          let args = call.arguments as? [String: Any],
          let count = args["count"] as? Int
        else {
          result(FlutterMethodNotImplemented)
          return
        }
        self?.setBadgeCount(count)
        result(nil)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func setBadgeCount(_ count: Int) {
    if #available(iOS 16.0, *) {
      UNUserNotificationCenter.current().setBadgeCount(count) { _ in }
    } else {
      UIApplication.shared.applicationIconBadgeNumber = count
    }
  }
}
