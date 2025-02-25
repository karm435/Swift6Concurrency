import Foundation

public enum NetworkError: Error {
    case invalidUrl(_ url: String)
    case invalidServerResponse
}

public class NetworkClient: NetworkClientProtocol {
    private let baseURL: String
    private let urlSession: URLSession
    
    public init() {
        guard let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as? String,
              !baseURL.isEmpty else {
            fatalError("No base url found in Info.plist")
        }
        self.baseURL = baseURL.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
        
        // For debug version, I might add a localhost URL session delegate to handle the localhost request. For this sample as we are using hosted apis. I will ignore this for now.
        
        urlSession = URLSession.shared
    }
    
    public func get<Entity: Decodable & Sendable>(_ endPoint: Endpoint) async throws -> Entity {
        do {
            let url = try createFullURL(with: endPoint)
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = endPoint.method
            let (data, httpResponse) = try await urlSession.data(for: urlRequest)
            
            guard let httpResponse = httpResponse as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidServerResponse
            }
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let result = try jsonDecoder.decode(Entity.self, from: data)
            
            return result
        } catch {
//            RacingLogger.errorLogger.error("Error occurred while fetching data from network \(error.localizedDescription)")
            throw error
        }
    }
    
    private func createFullURL(with endpoint: Endpoint) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        
        // Remove any trailing slashes from baseURL
        let cleanBaseURL = baseURL.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let partsOfUrl = cleanBaseURL.split(separator: ":")
        
        guard let hostPart = partsOfUrl.first.map(String.init) else {
            throw NetworkError.invalidUrl(self.baseURL)
        }
        components.host = hostPart
        
        // Handle port if present in baseURL
        if partsOfUrl.count > 1, let portString = partsOfUrl.last, let port = Int(portString) {
            components.port = port
        }
        
        // Ensure path starts with forward slash. Looks like the path like
        // found out that url like https://api.neds.com.au/rest/v1/racing?method=nextraces&count=10
        // Which does notr have a / before the query string does not work. So adding this peice to make sure path starts and ends with /
        let pathWithoutSlashes = endpoint.restV1Path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let path = "/" + pathWithoutSlashes + "/"
        
        components.path = path
        components.queryItems = endpoint.queryParameters
        
        guard let url = components.url else {
            throw NetworkError.invalidUrl(self.baseURL)
        }
        
        return url
    }
}
