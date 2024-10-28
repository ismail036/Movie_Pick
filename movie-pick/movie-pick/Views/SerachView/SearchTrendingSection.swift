//
//  SearchTrendingSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI

struct SearchTrendingSection: View {
    @State private var selectedTab: String = "Today"
    @State private var trendingMovies: [MovieModel] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            header
            trendingMoviesScrollView
        }
        .background(Color.mainColor1)
        .onAppear {
            fetchTrendingMovies()
        }
    }
    
    private var header: some View {
        HStack(alignment: .bottom) {
            Text("Trending Content")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
    
    private var trendingMoviesScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(trendingMovies) { movie in
                    VerticalMovieCard(
                        selectedDestination: .movieDetail,
                        movieId: movie.id
                    )
                }
            }
        }
    }
    
    private func fetchTrendingMovies() {
        let timeWindow = selectedTab == "Today" ? "day" : "week"
        TMDBService().fetchTrendingMovies(timeWindow: timeWindow) { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self.trendingMovies = movies
                }
            case .failure(let error):
                print("Failed to fetch trending movies: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    SearchTrendingSection()
}
