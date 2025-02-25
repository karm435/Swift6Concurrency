import Foundation

extension RaceSummary {
    private static let horseRacingId = UUID(uuidString: RaceCategory.horseRacing.rawValue)!
    private static let greyhoundRacingId = UUID(uuidString: RaceCategory.greyhoundRacing.rawValue)!
    private static let harnessRacingId = UUID(uuidString: RaceCategory.harnessRacing.rawValue)!
    
    static var mockSummaries: [RaceSummary] {
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
    
    static var onlyHorseRaces: [RaceSummary] {
        mockSummaries.filter { $0.categoryId == horseRacingId }
    }
    
    static var onlyGreyhoundRaces: [RaceSummary] {
        mockSummaries.filter { $0.categoryId == greyhoundRacingId }
    }
    
    static var onlyHarnessRaces: [RaceSummary] {
        mockSummaries.filter { $0.categoryId == harnessRacingId }
    }
}
