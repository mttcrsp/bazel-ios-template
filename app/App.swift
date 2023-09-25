import UIKit
import ComposableArchitecture
import IGListKit
import AsyncDisplayKit

@UIApplicationMain
final class ApplicationDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    window = UIWindow()
    window?.rootViewController = UIViewController()
    window?.makeKeyAndVisible()
    print(SectionController.self)
    return true
  }
}

struct Feature: Reducer {
  typealias Action = String
  typealias State = String
  var body: some Reducer<State, Action> {
    Reduce { _, _ in .none }
  }
}

final class SectionController: ListSectionController {
  override func numberOfItems() -> Int {
    1
  }

  func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
    { ASCellNode() }
  }
}

extension SectionController: ASSectionController {
  override func sizeForItem(at index: Int) -> CGSize {
    ASIGListSectionControllerMethods.sizeForItem(at: index)
  }

  override func cellForItem(at index: Int) -> UICollectionViewCell {
    ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
  }
}
