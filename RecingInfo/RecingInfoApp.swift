import SwiftUI

@main
struct RecingInfoApp: App {
  @State private var racingModel: RacingViewModel = .init()
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        ContentView()
          .environment(racingModel)
      }
    }
  }
}
