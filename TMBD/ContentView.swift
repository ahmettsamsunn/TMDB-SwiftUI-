//
//  ContentView.swift
//  TMBD
//
//  Created by Ahmet Samsun on 15.01.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MoviesViewModel()
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading && viewModel.nowPlayingMovies.isEmpty {
                ProgressView()
            } else if let error = viewModel.error {
                VStack {
                    Text("Error loading movies")
                        .font(.headline)
                    Text(error.localizedDescription)
                        .font(.subheadline)
                        .foregroundColor(.red)
                    Button("Retry") {
                        viewModel.fetchNowPlaying()
                        viewModel.fetchPopular()
                    }
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HorizontalMovieSection(
                            title: "Now Playing",
                            movies: viewModel.nowPlayingMovies,
                            onLoadMore: { viewModel.fetchNowPlaying(loadMore: true) }
                        )
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Popular")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.popularMovies) { movie in
                                    NavigationLink(destination: MovieDetailsView(movie: movie, viewModel: viewModel)) {
                                        PopularMovieRow(movie: movie)
                                            .onAppear {
                                                if viewModel.popularMovies.last?.id == movie.id {
                                                    viewModel.fetchPopular(loadMore: true)
                                                }
                                            }
                                    }
                                    Divider()
                                }
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("TMDB Movies")
            }
        }
        .task {
            viewModel.fetchNowPlaying()
            viewModel.fetchPopular()
        }
    }
}

struct HorizontalMovieSection: View {
    let title: String
    let movies: [Movie]
    let onLoadMore: () -> Void
    @StateObject private var viewModel = MoviesViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(movies) { movie in
                        NavigationLink(destination: MovieDetailsView(movie: movie, viewModel: viewModel)) {
                            MovieCard(movie: movie)
                                .onAppear {
                                    if movies.last?.id == movie.id {
                                        onLoadMore()
                                    }
                                }
                        }
                    }
                }
            }
        }
    }
}

struct MovieCard: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Poster Image
            Group {
                if let url = movie.posterURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.3))
                                .overlay(ProgressView())
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure(_):
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.3))
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                }
            }
            .frame(width: 150, height: 225)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 4)
            
            Text(movie.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2)
                .frame(width: 150)
                .foregroundColor(.primary)
            
            if let rating = movie.voteAverage {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", rating))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(.bottom)
    }
}

struct PopularMovieRow: View {
    let movie: Movie
    
    var body: some View {
        HStack(spacing: 16) {
            // Poster Image
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .overlay(ProgressView())
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(_):
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 60, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                if let releaseDate = movie.releaseDate {
                    Text(releaseDate)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", movie.voteAverage ?? 0.0))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(.trailing, 8)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

#Preview {
    ContentView()
}
