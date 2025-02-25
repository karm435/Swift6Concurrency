import Testing
import Factory
import AsyncAlgorithms
@testable import RacingInfo


@Suite("RacingViewModel tests") @MainActor
struct RacingViewModelTests {
    var mockNetworkClient = MockNetworkClient()
    
    @Test
    func getRacesForCategory() async {
        // Arrange
        let vmProgress = AsyncChannel<()>()
        
        mockNetworkClient.getRacesClosure = {
            GetRacesResponse(
                status: 200,
                data: RaceSummeriesResponse(raceSummaries: RaceSummaries(nextRaces: RaceSummary.mockSummaries))
            )
        }
        Container.shared.networkClient.register { @MainActor in self.mockNetworkClient }
        
        let viewModel = RacingViewModel()
        viewModel.progress = vmProgress
        await viewModel.startStreamingRaces()
        
        defer {
            viewModel.stopStreamingRaces()
        }
        
        // Act
        await viewModel.filterRacesFor(.greyhoundRacing)
        
        // Wait for the ViewModel to process the data
            for await _ in vmProgress {
                break // Exit after first emission
            }
        
        // Assert
        #expect(!viewModel.nextToGoRaceSummaries.isEmpty)
        #expect(viewModel.nextToGoRaceSummaries.allSatisfy { $0.raceCategory == .greyhoundRacing })

    }
}
