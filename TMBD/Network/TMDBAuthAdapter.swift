import Foundation
import NetworkingLibrary

struct TMDBAuthAdapter: RequestAdaptation {
    private let apiKey: String
    
    init(apiKey: String = "f2b4502f48921ca4253b0a570caa027d") {
        self.apiKey = apiKey
    }
    
    func adapt(request: URLRequest) -> URLRequest {
        guard var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false) else {
            return request
        }
        
        var queryItems = components.queryItems ?? []
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        components.queryItems = queryItems
        
        var newRequest = request
        newRequest.url = components.url
        return newRequest
    }
}
