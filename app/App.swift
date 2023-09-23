import UIKit
import AsyncDisplayKit

@UIApplicationMain
final class ApplicationDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    let rootViewController = ASDKViewController(node: .init())
    rootViewController.node.backgroundColor = .systemGreen
    window = UIWindow()
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()
    return true
  }
}
