import SwiftUI
import PINOperation

@main
struct App: SwiftUI.App {
  var body: some Scene {
    WindowGroup {
      Text("\(String(describing: PINOperationGroup.self))")
    }
  }
}
