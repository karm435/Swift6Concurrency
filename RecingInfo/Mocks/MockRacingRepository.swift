import Foundation

@MainActor
class MockRacingRepository: RacingRepositoryProtocol {
    private let refreshInterval: TimeInterval = 30 // refresh every 30 seconds
    
    private func fetchNextRaces(count: Int) async throws -> [RaceSummary] {
        return Array(getMockRaces().prefix(count))
    }
    
    func streamRaces(categories: Set<RaceCategory>) -> AsyncStream<[RaceSummary]> {
        AsyncStream(bufferingPolicy: .bufferingNewest(30)) { continuation in
            Task {
                let task = Task {
                    while !Task.isCancelled {
                        do {
                            let races = try await fetchNextRaces(count: 10)
                            let filteredRaces = races// Fetch extra to account for filtering
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
                            continuation.yield(filteredRaces)
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
    
    private func getMockRaces() -> [RaceSummary] {
        let horseRacingId = UUID(uuidString: "4a2788f8-e825-4d36-9894-efd4baf1cfae")!
        let greyhoundRacingId = UUID(uuidString: "9daef0d7-bf3c-4f50-921d-8e818c60fe61")!
        let harnessRacingId = UUID(uuidString: "161d9be2-e909-4326-8c2c-35ed71fb460b")!
        
        return [
            RaceSummary(
                raceId: UUID(),
                meetingName: "Melbourne Cup",
                raceNumber: 7,
                categoryId: horseRacingId,
                advertisedStart: AdvertisedStart(seconds: Date().addingTimeInterval(3600).timeIntervalSince1970)
            ),
            RaceSummary(
                raceId: UUID(),
                meetingName: "Meadows Cup",
                raceNumber: 9,
                categoryId: greyhoundRacingId,
                advertisedStart: AdvertisedStart(seconds: Date().addingTimeInterval(7200).timeIntervalSince1970)
            ),
            RaceSummary(
                raceId: UUID(),
                meetingName: "Inter Dominion",
                raceNumber: 5,
                categoryId: harnessRacingId,
                advertisedStart: AdvertisedStart(seconds: Date().addingTimeInterval(10800).timeIntervalSince1970)
            ),
            RaceSummary(
                raceId: UUID(),
                meetingName: "Caulfield Cup",
                raceNumber: 8,
                categoryId: horseRacingId,
                advertisedStart: AdvertisedStart(seconds: Date().addingTimeInterval(14400).timeIntervalSince1970)
            ),
            RaceSummary(
                raceId: UUID(),
                meetingName: "Sandown Classic",
                raceNumber: 6,
                categoryId: greyhoundRacingId,
                advertisedStart: AdvertisedStart(seconds: Date().addingTimeInterval(18000).timeIntervalSince1970)
            ),
            RaceSummary(
                raceId: UUID(),
                meetingName: "Miracle Mile",
                raceNumber: 4,
                categoryId: harnessRacingId,
                advertisedStart: AdvertisedStart(seconds: Date().addingTimeInterval(21600).timeIntervalSince1970)
            ),
            RaceSummary(
                raceId: UUID(),
                meetingName: "Queen Elizabeth Stakes",
                raceNumber: 3,
                categoryId: horseRacingId,
                advertisedStart: AdvertisedStart(seconds: Date().addingTimeInterval(25200).timeIntervalSince1970)
            ),
            RaceSummary(
                raceId: UUID(),
                meetingName: "Melbourne Cup Night Sprint",
                raceNumber: 2,
                categoryId: greyhoundRacingId,
                advertisedStart: AdvertisedStart(seconds: Date().addingTimeInterval(28800).timeIntervalSince1970)
            ),
            RaceSummary(
                raceId: UUID(),
                meetingName: "Victoria Pacing Cup",
                raceNumber: 1,
                categoryId: harnessRacingId,
                advertisedStart: AdvertisedStart(seconds: Date().addingTimeInterval(32400).timeIntervalSince1970)
            ),
            RaceSummary(
                raceId: UUID(),
                meetingName: "Victoria Derby",
                raceNumber: 10,
                categoryId: horseRacingId,
                advertisedStart: AdvertisedStart(seconds: Date().addingTimeInterval(36000).timeIntervalSince1970)
            )
        ]
    }
}
