import Foundation
import Factory

// I like to keep the protocol and implementation in same file. But not fuzzy to move them to separate files.
@MainActor
protocol RacingRepositoryProtocol {
    func streamRaces(categories: Set<RaceCategory>) -> AsyncStream<[RaceSummary]>
}

class RacingRepository: RacingRepositoryProtocol {
    @Injected(\.networkClient) private var networkClient
    private let refreshInterval: TimeInterval = 30 // refresh every 30 seconds
    
    private func fetchNextRaces(count: Int) async throws -> [RaceSummary] {
        let result: GetRacesResponse = try await networkClient.get(.racing(method: "nextraces", count: count))
        
        return result.data.raceSummaries.nextRaces
    }
    
    func streamRaces(categories: Set<RaceCategory>) -> AsyncStream<[RaceSummary]> {
        AsyncStream { continuation in
            Task {
                let task = Task {
                    while !Task.isCancelled {
                        do {
                            let races = try await fetchNextRaces(count: 10) // Fetch extra to account for filtering
                                .filter { race in
                                    // Filter out races more than 1 minute past start
                                    let cutoffTime = Date().timeIntervalSince1970 - 60
                                    guard race.advertisedStart.seconds > cutoffTime else { return false }
                                    
                                    guard let raceCategory = race.raceCategory else { return false }
                                    
                                    // Apply category filter if specified
                                    return categories.isEmpty || categories.contains(raceCategory)
                                }
                                .sorted { $0.advertisedStart.seconds < $1.advertisedStart.seconds }
                                .prefix(5) // Take only 5 races
                                .map { $0 }
                            
                            continuation.yield(races)
                            try await Task.sleep(nanoseconds: UInt64(refreshInterval * 1_000_000_000))
                        } catch {
                            continuation.finish()
                            break
                        }
                    }
                }
                
                continuation.onTermination = { _ in
                    task.cancel()
                }
            }
        }
    }
}

// MARK: Container registration
extension Container {
    var racingRepository: Factory<RacingRepositoryProtocol> {
        self { @MainActor in RacingRepository() }
    }
}
