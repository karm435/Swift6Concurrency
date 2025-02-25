import Foundation

public struct RaceSummary: Decodable, Sendable {
    public var raceId: UUID
    public var meetingName: String
    public var raceNumber: Int
    public var categoryId: UUID
    public var advertisedStart: AdvertisedStart
}

extension RaceSummary: Identifiable {
  public var id: UUID {
    raceId
  }
}

extension RaceSummary {
  public var raceCategory: RaceCategory? {
    return RaceCategory(rawValue: categoryId.uuidString.lowercased())
  }
}
