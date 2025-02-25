import Foundation

public enum Endpoint {
    case racing(method: String, count: Int)
    
    var restV1Path: String {
        return switch self {
        case .racing:
            "/rest/v1/racing"
        }
    }
    
    var queryParameters: [URLQueryItem] {
        return switch self {
        case .racing(let method, let count):
            [URLQueryItem(name: "method", value: method),
             URLQueryItem(name: "count", value: String(count))]
        }
    }
    
    var method: String {
        return switch self {
        case .racing:
            HttpMethod.get.rawValue
        }
    }
}
