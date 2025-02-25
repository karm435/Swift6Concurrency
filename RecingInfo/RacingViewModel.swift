import Foundation
import Combine
import Factory

@Observable
class RacingViewModel {
    @ObservationIgnored @Injected(\.racingRepository) var repository
    
    private(set) var searchTokens: Set<RaceCategory> = []
    private(set) var nextToGoRaceSummaries: [RaceSummary] = []
    private var streamTask: Task<Void, Never>?
    
    deinit {
        streamTask?.cancel()
    }
    
    @MainActor
    func startStreamingRaces() async {
        streamTask?.cancel()
        streamTask = Task {
            for await races in repository.streamRaces(categories: searchTokens) {
                guard !Task.isCancelled else { break }
                nextToGoRaceSummaries = races
            }
        }
    }
    
    @MainActor
    public func updateSearch(cat: RaceCategory?) async {
        guard let cat else {
            searchTokens.removeAll()
            await startStreamingRaces()
            return
        }
        
        if searchTokens.contains(cat) {
            searchTokens.remove(cat)
        } else {
            searchTokens.insert(cat)
        }
        
        await startStreamingRaces()
    }
}
