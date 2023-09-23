import SwiftUI
import PINOperation
import Alamofire

@main
struct App: SwiftUI.App {
  var body: some Scene {
    WindowGroup {
      Text("\(String(describing: PINOperationGroup.self))")
      Text("\(String(describing: Session.self))")
    }
  }
}
