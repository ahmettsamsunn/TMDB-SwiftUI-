import Foundation

@MainActor
class MoviesViewModel {
    // MARK: - Properties
    private let movieService: MovieService
    
    private(set) var nowPlayingMovies: [Movie] = []
    private(set) var popularMovies: [Movie] = []
    private(set) var movieDetails: MovieDetails?
    
    private(set) var isLoading = false
    private(set) var isLoadingDetails = false
    private(set) var error: Error?
    private(set) var detailsError: Error?
    
    private var nowPlayingPage = 1
    private var popularPage = 1
    private var isLoadingMoreNowPlaying = false
    private var isLoadingMorePopular = false
    
    var onStateChange: (() -> Void)?
    
    // MARK: - Initialization
    init(movieService: MovieService = MovieService()) {
        self.movieService = movieService
    }
    
    // MARK: - Public Methods
    func fetchNowPlaying(loadMore: Bool = false) async {
        if loadMore {
            guard !isLoadingMoreNowPlaying else { return }
            isLoadingMoreNowPlaying = true
        } else {
            guard !isLoading else { return }
            isLoading = true
            nowPlayingMovies = []
            nowPlayingPage = 1
        }
        
        error = nil
        onStateChange?()
        
        do {
            let response = try await movieService.fetchNowPlaying(page: nowPlayingPage)
            if loadMore {
                nowPlayingMovies.append(contentsOf: response.results)
            } else {
                nowPlayingMovies = response.results
            }
            nowPlayingPage += 1
        } catch {
            self.error = error
        }
        
        isLoading = false
        isLoadingMoreNowPlaying = false
        onStateChange?()
    }
    
    func fetchPopular(loadMore: Bool = false) async {
        if loadMore {
            guard !isLoadingMorePopular else { return }
            isLoadingMorePopular = true
        } else {
            guard !isLoading else { return }
            isLoading = true
            popularMovies = []
            popularPage = 1
        }
        
        error = nil
        onStateChange?()
        
        do {
            let response = try await movieService.fetchPopular(page: popularPage)
            if loadMore {
                popularMovies.append(contentsOf: response.results)
            } else {
                popularMovies = response.results
            }
            popularPage += 1
        } catch {
            self.error = error
        }
        
        isLoading = false
        isLoadingMorePopular = false
        onStateChange?()
    }
    
    func fetchMovieDetails(id: Int) async {
        guard !isLoadingDetails else { return }
        
        isLoadingDetails = true
        detailsError = nil
        onStateChange?()
        
        do {
            movieDetails = try await movieService.fetchMovieDetails(id: id)
        } catch {
            detailsError = error
        }
        
        isLoadingDetails = false
        onStateChange?()
    }
    
    func searchMovies(query: String) async -> [Movie] {
        do {
            let response = try await movieService.searchMovies(query: query)
            return response.results
        } catch {
            self.error = error
            onStateChange?()
            return []
        }
    }
    
    // MARK: - Helper Methods
    func resetState() {
        nowPlayingMovies = []
        popularMovies = []
        movieDetails = nil
        isLoading = false
        isLoadingDetails = false
        error = nil
        detailsError = nil
        nowPlayingPage = 1
        popularPage = 1
        isLoadingMoreNowPlaying = false
        isLoadingMorePopular = false
        onStateChange?()
    }
}

// MARK: - State Helpers
extension MoviesViewModel {
    var hasError: Bool {
        error != nil
    }
    
    var isInitialLoading: Bool {
        isLoading && nowPlayingMovies.isEmpty && popularMovies.isEmpty
    }
    
    var canLoadMoreNowPlaying: Bool {
        !isLoadingMoreNowPlaying && !nowPlayingMovies.isEmpty
    }
    
    var canLoadMorePopular: Bool {
        !isLoadingMorePopular && !popularMovies.isEmpty
    }
}
