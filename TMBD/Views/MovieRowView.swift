import SwiftUI

struct MovieRowView: View {
    let movie: Movie
    @ObservedObject var viewModel: MoviesViewModel
    
    var body: some View {
        NavigationLink(destination: MovieDetailsView(movie: movie, viewModel: viewModel)) {
            HStack(spacing: 16) {
                // Movie Poster
                if let posterURL = movie.posterURL {
                    AsyncImage(url: posterURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                    }
                    .frame(width: 80, height: 120)
                    .cornerRadius(8)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 120)
                        .cornerRadius(8)
                }
                
                // Movie Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    if let rating = movie.voteAverage {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", rating))
                                .foregroundColor(.green)
                        }
                    }
                    
                    if let releaseDate = movie.releaseDate {
                        Text(releaseDate)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
        }
    }
}
