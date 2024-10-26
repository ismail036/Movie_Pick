//
//  TrendingSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct TrendingSection: View {
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
            Text("Trending")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Button(action: {
                selectedTab = "Today"
                fetchTrendingMovies()
            }) {
                Text("Today")
                    .font(.system(size: 16))
                    .fontWeight(selectedTab == "Today" ? .bold : .regular)
                    .foregroundColor(selectedTab == "Today" ? .white : .gray)
            }
            .padding(.leading, 15)
            
            Text("|")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            Button(action: {
                selectedTab = "This Week"
                fetchTrendingMovies()
            }) {
                Text("This Week")
                    .font(.system(size: 16))
                    .fontWeight(selectedTab == "This Week" ? .bold : .regular)
                    .foregroundColor(selectedTab == "This Week" ? .white : .gray)
            }
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
    TrendingSection()
}
