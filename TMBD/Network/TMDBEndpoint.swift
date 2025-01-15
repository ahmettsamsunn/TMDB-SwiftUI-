import Foundation
import NetworkingLibrary

enum TMDBEndpoint: NetworkRequestable {
    case nowPlaying(page: Int)
    case popular(page: Int)
    case search(query: String, page: Int)
    case movieDetails(id: Int)
    
    var baseURL: String {
        "https://api.themoviedb.org/3"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var path: String {
        switch self {
        case .nowPlaying:
            return "/movie/now_playing"
        case .popular:
            return "/movie/popular"
        case .search:
            return "/search/movie"
        case .movieDetails(let id):
            return "/movie/\(id)"
        }
    }
    
    var parameters: Encodable? {
        switch self {
        case .nowPlaying(let page):
            return TMDBParameters(page: page)
        case .popular(let page):
            return TMDBParameters(page: page)
        case .search(let query, let page):
            return TMDBParameters(page: page, query: query)
        case .movieDetails:
            return TMDBParameters()
        }
    }
    
    var headers: [String: String]? {
        ["Accept": "application/json"]
    }
}
