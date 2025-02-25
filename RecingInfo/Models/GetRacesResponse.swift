public struct GetRacesResponse: Decodable, Sendable {
  public let status: Int
  public var data: RaceSummeriesResponse
}
