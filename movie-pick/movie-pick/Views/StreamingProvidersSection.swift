//
//  StreamingProvidersSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct StreamingProvidersSection: View {
    @State private var movies: [MovieModel] = []
    @State private var selectedProvider: (name: String, id: Int)? = nil
    private let tmdbService = TMDBService()
    
    let providers = [
        ("Netflix", 8, Color.red),
        ("Disney+", 337, Color.blue),
        ("Apple TV+", 350, Color.black),
        ("Hulu", 15, Color.green),
        ("Amazon Prime", 9, Color.blue.opacity(0.7)),
        ("Max", 384, Color.gray),
        ("Paramount+", 531, Color.blue),
        ("Crunchyroll", 283, Color.orange),
        ("Peacock Premium", 386, Color.blue.opacity(0.5))
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Streaming Providers")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Find Movies from your favorite streaming services")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(providers, id: \.0) { provider in
                        Text(provider.0)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(provider.2)
                            .cornerRadius(20)
                            .onTapGesture {
                                selectedProvider = (provider.0, provider.1)
                                fetchMovies(forProviderId: provider.1)
                            }
                    }
                }
                .padding(.top, 10)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(movies, id: \.id) { movie in
                        VerticalMovieCard(
                            selectedDestination: .movieDetail,
                            movieId: movie.id
                        )
                    }
                }
            }
        }
        .background(Color.black)
        .onAppear {
            fetchMovies(forProviderId: nil) 
        }
    }
    
    func fetchMovies(forProviderId providerId: Int?) {
        if let providerId = providerId {
            print("Fetching movies for provider ID: \(providerId)")
            tmdbService.fetchMoviesByProvider(providerId: providerId) { result in
                switch result {
                case .success(let fetchedMovies):
                    movies = Array(fetchedMovies.prefix(10))
                case .failure(let error):
                    print("Error fetching movies for provider ID \(providerId): \(error)")
                }
            }
        } else {
            print("Fetching random movies from all providers")
            tmdbService.fetchPopularMovies { result in
                switch result {
                case .success(let fetchedMovies):
                    movies = Array(fetchedMovies.shuffled().prefix(10))
                case .failure(let error):
                    print("Error fetching popular movies: \(error)")
                }
            }
        }
    }
}

#Preview {
    StreamingProvidersSection()
}
