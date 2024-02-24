import UIKit
import ComposableArchitecture
import IGListKit
import AsyncDisplayKit
import IGListSwiftKit
import Combine

@UIApplicationMain
final class ApplicationDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    let store = Store(initialState: .init(), reducer: Feature.init)
    window = UIWindow()
    window?.rootViewController = ViewController(store: store)
    window?.makeKeyAndVisible()
    return true
  }
}

@Reducer
struct Feature {
  @ObservableState
  struct State {
    var count = 1
  }
  
  enum Action {
    case increment
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .increment:
        state.count += 1
        return .none
      }
    }
  }
}

class ViewController: ASDKViewController<ASCollectionNode> {
  private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
  private let store: StoreOf<Feature>
  private var cancellables: [AnyCancellable] = []

  init(store: StoreOf<Feature>) {
    self.store = store
    
    let collectionLayout = UICollectionViewFlowLayout()
    let collectionNode = ASCollectionNode(collectionViewLayout: collectionLayout)
    collectionNode.backgroundColor = .systemBackground
    super.init(node: collectionNode)

    adapter.setASDKCollectionNode(node)
    adapter.dataSource = self
    
    store.publisher.sink { [weak self] _ in
      self?.adapter.performUpdates(animated: true)
    }.store(in: &cancellables)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ViewController: ListAdapterDataSource {
  func listAdapter(_: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    let controller = SectionController()
    controller.delegate = self
    return controller
  }

  func objects(for _: ListAdapter) -> [ListDiffable] {
    (1 ... store.count).map { number in
      SectionControllerConfiguration(text: number.description).diffable()
    }
  }

  func emptyView(for _: ListAdapter) -> UIView? {
    nil
  }
}

extension ViewController: SectionControllerDelegate {
  func sectionControllerDidTap(_ sectionController: SectionController) {
    store.send(.increment)
  }
}


struct SectionControllerConfiguration: Hashable, ListIdentifiable {
  let text: String
  var diffIdentifier: NSObjectProtocol {
    text as NSString
  }
}

protocol SectionControllerDelegate: AnyObject {
  func sectionControllerDidTap(_ sectionController: SectionController)
}

final class SectionController: ListValueSectionController<SectionControllerConfiguration> {
  weak var delegate: SectionControllerDelegate?
  
  override func numberOfItems() -> Int {
    1
  }

  func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
    let text = value.text
    return {
      let node = ASTextCellNode()
      node.backgroundColor = .systemYellow
      node.text = text
      return node
    }
  }
  
  override func didSelectItem(at index: Int) {
    delegate?.sectionControllerDidTap(self)
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
