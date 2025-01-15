import Foundation

struct TMDBParameters: Encodable {
    let page: Int
    let query: String?
    
    enum CodingKeys: String, CodingKey {
        case page
        case query
    }
    
    init(page: Int = 1, query: String? = nil) {
        self.page = page
        self.query = query
    }
}
