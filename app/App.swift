import UIKit
import ComposableArchitecture

@UIApplicationMain
final class ApplicationDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    window = UIWindow()
    window?.rootViewController = UIViewController()
    window?.makeKeyAndVisible()
    return true
  }
}
