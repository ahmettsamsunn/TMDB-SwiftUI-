import Foundation

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double?
    let releaseDate: String?
    let backdropPath: String?
    let originalLanguage: String?
    let voteCount: Int?
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(backdropPath)")
    }
    
    var formattedRating: String {
        if let rating = voteAverage {
            return String(format: "%.1f", rating)
        }
        return "N/A"
    }
}

struct MovieResponse: Codable {
    let page: Int?
    let results: [Movie]
    let totalPages: Int?
    let totalResults: Int?
    let dates: MovieResponseDates?
}

struct MovieResponseDates: Codable {
    let maximum: String
    let minimum: String
}
