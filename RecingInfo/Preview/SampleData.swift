import SwiftUI
import Factory

struct SampleData: PreviewModifier {
    var mockNetworkClient = MockNetworkClient()
    
    init() {
        self.mockNetworkClient.getRacesClosure = {
            GetRacesResponse(
                status: 200,
                data: RaceSummeriesResponse(raceSummaries: RaceSummaries(nextRaces: RaceSummary.mockSummaries))
            )
        }
    }
    
    // Define the object to share and return it as a shared context.
    static func makeSharedContext() async throws -> RacingViewModel {
        let viewModel = RacingViewModel()
        return viewModel
    }

    func body(content: Content, context: RacingViewModel) -> some View {
        let _ = Container.shared.networkClient.register { self.mockNetworkClient }
        content
            .environment(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}
