public struct RaceForm: Codable {
  public let distance: Int
  public let distanceType: DistanceType
  public let trackCondition: TrackCondition
  public let raceComment: String
  public let additionalData: String
  public let generated: Int
  public let raceCommentAlternative: String
  public let silkBaseUrl: String
}
