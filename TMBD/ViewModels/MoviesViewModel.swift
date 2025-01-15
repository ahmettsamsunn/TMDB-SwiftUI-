import Foundation
import SwiftUI
import OSLog

@MainActor
class MoviesViewModel: ObservableObject {
    @Published var nowPlayingMovies: [Movie] = []
    @Published var popularMovies: [Movie] = []
    @Published var searchResults: [Movie] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published private(set) var selectedMovie: MovieDetails?
    @Published private(set) var isLoadingDetails = false
    @Published private(set) var detailsError: Error?
    
    // Pagination state
    private var nowPlayingPage = 1
    private var popularPage = 1
    private var hasMoreNowPlaying = true
    private var hasMorePopular = true
    private var isLoadingMore = false
    
    private let movieService = MovieService()
    private let logger = Logger(subsystem: "com.tmdb.app", category: "MoviesViewModel")
    
    func fetchNowPlaying(loadMore: Bool = false) {
        guard !isLoading, !isLoadingMore, (loadMore ? hasMoreNowPlaying : true) else { return }
        
        Task {
            if loadMore {
                isLoadingMore = true
            } else {
                isLoading = true
                nowPlayingPage = 1
            }
            
            do {
                let response = try await movieService.fetchNowPlaying(page: nowPlayingPage)
                if loadMore {
                    nowPlayingMovies.append(contentsOf: response.results)
                } else {
                    nowPlayingMovies = response.results
                }
                
                if let totalPages = response.totalPages {
                    hasMoreNowPlaying = nowPlayingPage < totalPages
                    if hasMoreNowPlaying {
                        nowPlayingPage += 1
                    }
                }
                error = nil
            } catch {
                self.error = error
                logger.error("Failed to fetch now playing movies: \(error.localizedDescription)")
            }
            
            isLoading = false
            isLoadingMore = false
        }
    }
    
    func fetchPopular(loadMore: Bool = false) {
        guard !isLoading, !isLoadingMore, (loadMore ? hasMorePopular : true) else { return }
        
        Task {
            if loadMore {
                isLoadingMore = true
            } else {
                isLoading = true
                popularPage = 1
            }
            
            do {
                let response = try await movieService.fetchPopular(page: popularPage)
                if loadMore {
                    popularMovies.append(contentsOf: response.results)
                } else {
                    popularMovies = response.results
                }
                
                if let totalPages = response.totalPages {
                    hasMorePopular = popularPage < totalPages
                    if hasMorePopular {
                        popularPage += 1
                    }
                }
                error = nil
            } catch {
                self.error = error
                logger.error("Failed to fetch popular movies: \(error.localizedDescription)")
            }
            
            isLoading = false
            isLoadingMore = false
        }
    }
    
    func searchMovies(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        Task {
            do {
                let response = try await movieService.searchMovies(query: query)
                searchResults = response.results
                error = nil
            } catch {
                self.error = error
                logger.error("Failed to search movies: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchMovieDetails(id: Int) {
        Task {
            isLoadingDetails = true
            detailsError = nil
            do {
                selectedMovie = try await movieService.fetchMovieDetails(id: id)
            } catch {
                detailsError = error
                logger.error("Failed to fetch movie details: \(error.localizedDescription)")
            }
            isLoadingDetails = false
        }
    }
}
