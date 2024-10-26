//
//  DiscoverDetail.swift
//  movie-pick
//
//  Created by İsmail Parlak on 22.10.2024.
//

import SwiftUI

struct DiscoverDetail: View {
    @Environment(\.presentationMode) var presentationMode

    let genres = ["All Genres", "Action", "Adventure", "Animation", "Comedy", "Horror", "Sci-Fi"]
    @State private var selectedGenres: [String] = []

    var body: some View {
        VStack {
            
            genreScrollView
            
            ScrollView {
                VStack(alignment: .leading) {

                    let cardWidth = (UIScreen.main.bounds.width - 48) / 3

                    LazyVGrid(columns: [
                        GridItem(.fixed(cardWidth), spacing: 8),
                        GridItem(.fixed(cardWidth), spacing: 8),
                        GridItem(.fixed(cardWidth), spacing: 8)
                    ], spacing: 8) {
                        ForEach(0..<5, id: \.self) { _ in
                        VerticalMovieCard(
                            selectedDestination:Destination.movieDetail,
                            movieTitle: "Deadpool & Wolverine",
                            moviePoster: "deadpool_wolverine",
                            rating: 4,
                            releaseYear: "2024",
                            multiplier: UIScreen.main.bounds.width < 375 ? 0.6 :
                                UIScreen.main.bounds.width > 430 ? 0.8 : 0.7
                        )

                        VerticalMovieCard(
                            selectedDestination:Destination.movieDetail,
                            movieTitle: "Bad Boys: Ride or Die",
                            moviePoster: "bad_boys",
                            rating: 4,
                            releaseYear: "2024",
                            multiplier: UIScreen.main.bounds.width < 375 ? 0.6 :
                                UIScreen.main.bounds.width > 430 ? 0.8 : 0.7
                        )

                        VerticalMovieCard(
                            selectedDestination:Destination.movieDetail,
                            movieTitle: "Despicable Me 4",
                            moviePoster: "despicable",

                            rating: 4,
                            releaseYear: "2024",
                            multiplier: UIScreen.main.bounds.width < 375 ? 0.6 :
                                UIScreen.main.bounds.width > 430 ? 0.8 : 0.7
                        )
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .background(Color.mainColor1)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Discover")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(Color.mainColor1, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    private var genreScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(genres, id: \.self) { genre in
                    Button(action: {
                        if genre == "All Genres" {
                            selectedGenres.removeAll()
                        } else {
                            if selectedGenres.contains("All Genres") {
                                selectedGenres.removeAll { $0 == "All Genres" }
                            }
                            if selectedGenres.contains(genre) {
                                selectedGenres.removeAll { $0 == genre }
                            } else {
                                selectedGenres.append(genre)
                            }
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text(genre)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(selectedGenres.contains(genre) ? Color.white : Color.blue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                            if selectedGenres.contains(genre) {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16, height: 16)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .padding(.trailing,8)
                            }
                        }
                    }
                    .background(selectedGenres.contains(genre) ? Color.blue : Color.blue.opacity(0.3))
                    .cornerRadius(20)


                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
        DiscoverDetail()
}
