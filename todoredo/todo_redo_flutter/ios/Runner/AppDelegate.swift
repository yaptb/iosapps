import Flutter
import UIKit

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

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
