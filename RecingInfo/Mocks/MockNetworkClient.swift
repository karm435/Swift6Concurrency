import Foundation

class MockNetworkClient: NetworkClientProtocol {
    var getRacesClosure: () async throws -> GetRacesResponse = {
        throw NetworkError.invalidServerResponse
    }
    
    func get<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        if let response = try await getRacesClosure() as? T {
            return response
        }
        throw NetworkError.invalidServerResponse
    }
}

