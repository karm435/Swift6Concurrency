import Foundation

public struct RaceSummaries: Sendable {
  public var nextRaces: [RaceSummary]
  
  public init(nextRaces: [RaceSummary]) {
    self.nextRaces = nextRaces
  }
}

extension RaceSummaries: Decodable {
  struct RaceSummariesKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
      self.stringValue = stringValue
    }
    
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
  }
  
  public init(from decoder: Decoder) throws {
    var races = [RaceSummary]()
    let container = try decoder.container(keyedBy: RaceSummariesKey.self)
    for key in container.allKeys {
      let raceSummary = try container.decode(RaceSummary.self, forKey: key)
      races.append(raceSummary)
    }
    
    self.init(nextRaces: races)
  }
}
