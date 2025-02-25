import Foundation
import Combine
import Factory
import AsyncAlgorithms

@Observable
class RacingViewModel {
    @ObservationIgnored @Injected(\.racingRepository) var repository
    
    private(set) var searchTokens: Set<RaceCategory> = []
    private(set) var nextToGoRaceSummaries: [RaceSummary] = []
    private var streamTask: Task<Void, Never>?
    var progress: AsyncChannel<()>?
    
    deinit {
        streamTask?.cancel()
    }
    
    func stopStreamingRaces() {
        streamTask?.cancel()
    }
    
    @MainActor
    func startStreamingRaces() async {
        streamTask?.cancel()
        streamTask = Task {
            for await races in repository.streamRaces() {
                guard !Task.isCancelled else { break }
                nextToGoRaceSummaries = races
                    .filter {
                        guard let category = $0.raceCategory else { return false }
                        
                        return searchTokens.isEmpty || searchTokens.contains(category)
                    }
                    .prefix(5) // Take only 5 races
                    .map { $0 }
                await progress?.send(())
            }
        }
    }
    
    @MainActor
    public func filterRacesFor(_ category: RaceCategory?) async {
        guard let category else {
            searchTokens.removeAll()
            await startStreamingRaces()
            return
        }
        
        if searchTokens.contains(category) {
            searchTokens.remove(category)
        } else {
            searchTokens.insert(category)
        }
        
        await startStreamingRaces()
    }
}
