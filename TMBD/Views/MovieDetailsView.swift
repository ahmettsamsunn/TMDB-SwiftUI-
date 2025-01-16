import SwiftUI

struct MovieDetailsView: View {
    let movie: Movie
    @ObservedObject var viewModel: MoviesViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Backdrop Image
                if let backdropURL = movie.backdropURL {
                    AsyncImage(url: backdropURL) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .overlay(ProgressView())
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 200)
                    .clipped()
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title and Rating
                    HStack(alignment: .top, spacing: 16) {
                        // Poster Image
                        if let posterURL = movie.posterURL {
                            AsyncImage(url: posterURL) { phase in
                                switch phase {
                                case .empty:
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 120, height: 180)
                                        .overlay(ProgressView())
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 180)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                case .failure:
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 120, height: 180)
                                        .overlay(
                                            Image(systemName: "photo")
                                                .foregroundColor(.gray)
                                        )
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(movie.title)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            if let rating = movie.voteAverage {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text(String(format: "%.1f", rating))
                                        .fontWeight(.semibold)
                                }
                            }
                            
                            if let releaseDate = movie.releaseDate {
                                Text("Release Date: \(releaseDate)")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Overview
                    if !movie.overview.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Overview")
                                .font(.headline)
                            Text(movie.overview)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Additional Details
                    if let language = movie.originalLanguage {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Additional Information")
                                .font(.headline)
                            
                            HStack {
                                Text("Original Language:")
                                Text(language.uppercased())
                                    .foregroundColor(.secondary)
                            }
                            
                            if let voteCount = movie.voteCount {
                                HStack {
                                    Text("Vote Count:")
                                    Text("\(voteCount)")
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.fetchMovieDetails(id: movie.id)
        }
        .overlay {
            if viewModel.isLoadingDetails {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
            }
        }
        .alert("Error", isPresented: .constant(viewModel.detailsError != nil)) {
            Button("OK") {
                dismiss()
            }
        } message: {
            if let error = viewModel.detailsError {
                Text(error.localizedDescription)
            }
        }
    }
}

#Preview {
    NavigationView {
        MovieDetailsView(
            movie: Movie(
                id: 1,
                title: "Test Movie",
                overview: "This is a test overview",
                posterPath: nil,
                voteAverage: 8.5,
                releaseDate: "2025-01-15",
                backdropPath: nil, originalLanguage: "en", voteCount: 50
            ),
            viewModel: MoviesViewModel()
        )
    }
}
