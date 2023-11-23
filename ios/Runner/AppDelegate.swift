import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let appGroup = "group.com.useinsider.mobile-ios"
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
    UNUserNotificationCenter.current().delegate = self;
      
    if let savedNotifications = getSavedNotifications() {
        print("Saved notifications: \(savedNotifications)")
    }
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    

  private func getSavedNotifications() -> [Any]? {
    // Make sure to have the same app group for your main target & notification service extension
    let sharedDefaults = UserDefaults(suiteName: appGroup)
    let savedNotifications = sharedDefaults?.array(forKey: "savedNotifications")
    return savedNotifications
  }
}
