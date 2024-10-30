//
//  ShowWatchList.swift
//  movie-pick
//
//  Created by İsmail Parlak on 30.10.2024.
//

import SwiftUI

struct ShowWatchList: View {
    @State private var bookmarkedMovies: [MovieDetailModel] = []
    @State private var bookmarkedShows: [TVShowDetailModel] = []
    
    var body: some View {
        VStack {
            HStack {
                Text("Watchlist")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            HStack {
                Text("Movies and TV Shows from your watchlist")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                
                Spacer()
            }
            
            if bookmarkedMovies.isEmpty && bookmarkedShows.isEmpty {
                emptyWatchlistView
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        
                        if !bookmarkedShows.isEmpty {
                            ForEach(bookmarkedShows, id: \.id) { show in
                                VerticalShowCard(showId: show.id)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)
            }
        }
        .onAppear(perform: fetchBookmarkedItems)
        .padding(0)
        .background(Color.mainColor1)
    }
    
    private var emptyWatchlistView: some View {
        VStack {
            Image("showWatchList")
 
            
            Text("Watchlist")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            Text("Add what you are planning to watch next to this list")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
                .padding(.bottom, 8)
        }
    }
    
    private func fetchBookmarkedItems() {
        fetchBookmarkedMovies()
        fetchBookmarkedShows()
    }
    
    private func fetchBookmarkedMovies() {
        let movieIds = UserDefaults.standard.array(forKey: "favoriteMovieIds") as? [Int] ?? []
        var movies: [MovieDetailModel] = []
        let dispatchGroup = DispatchGroup()
        
        for movieId in movieIds {
            dispatchGroup.enter()
            TMDBService().fetchMovieDetails(movieId: movieId) { result in
                switch result {
                case .success(let movie):
                    movies.append(movie)
                case .failure(let error):
                    print("Failed to fetch movie: \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.bookmarkedMovies = movies
        }
    }
    
    private func fetchBookmarkedShows() {
        let showIds = UserDefaults.standard.array(forKey: "favoriteShowIds") as? [Int] ?? []
        var shows: [TVShowDetailModel] = []
        let dispatchGroup = DispatchGroup()
        
        for showId in showIds {
            dispatchGroup.enter()
            TMDBService().fetchTVShowDetails(showId: showId) { result in
                switch result {
                case .success(let show):
                    shows.append(show)
                case .failure(let error):
                    print("Failed to fetch show: \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.bookmarkedShows = shows
        }
    }
}

#Preview {
    ShowWatchList()
}
