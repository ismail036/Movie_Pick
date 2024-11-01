//
//  NowPlayingSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct NowPlayingSection: View {
    var title1: String
    var title2: String
    @State private var nowPlayingMovies: [MovieModel] = []
    private let tmdbService = TMDBService()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title1)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title2)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(nowPlayingMovies, id: \.id) { movie in
                        VerticalMovieCard(
                            selectedDestination: .movieDetail,
                            movieId: movie.id
                        )
                    }
                }
            }
        }
        .background(Color.mainColor1)
        .onAppear {
            fetchNowPlayingMovies()
        }
    }
    
    private func fetchNowPlayingMovies() {
        tmdbService.fetchNowPlayingMovies { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self.nowPlayingMovies = Array(movies.prefix(10)) 
                }
            case .failure(let error):
                print("Error fetching now playing movies: \(error)")
            }
        }
    }
}

#Preview {
    NowPlayingSection(title1: "Now Playing", title2: "Current Films on Big Screens")
}
