import SwiftUI
import Factory

struct SampleData: PreviewModifier {
    // Define the object to share and return it as a shared context.
    static func makeSharedContext() async throws -> RacingViewModel {
        let appState = RacingViewModel()
        return appState
    }

    func body(content: Content, context: RacingViewModel) -> some View {
        let _ = Container.shared.racingRepository.register { MockRacingRepository() }
        content
            .environment(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}
