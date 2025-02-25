@MainActor
public protocol NetworkClientProtocol {
    func get<Entity: Decodable & Sendable>(_ endPoint: Endpoint) async throws -> Entity
}
