import Foundation

struct PaginatedResponse<T> {
    let items: [T]
    let currentPage: Int
    let totalPages: Int
    let hasNextPage: Bool
    
    init(items: [T], currentPage: Int, totalPages: Int) {
        self.items = items
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.hasNextPage = currentPage < totalPages
    }
}
