//
//  MoreLikeThisDetail.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct MoreLikeThisDetail: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var similarMovies: [SimilarMovie] = []
    @State private var selectedGenres: [String] = []
    @State private var genres: [Genre] = []
    
    let movieId: Int
    
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
                        ForEach(filteredMovies) { movie in
                            VerticalMovieCard(
                                selectedDestination: .movieDetail,
                                movieId: 1232454
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
                Text("More like this")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(Color.mainColor1, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            fetchGenres()
            fetchSimilarMovies()
        }
    }
    
    private var genreScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Button(action: {
                    selectedGenres = ["All Genres"]
                }) {
                    genreButtonContent("All Genres", isSelected: selectedGenres.contains("All Genres"))
                }
                
                ForEach(genres, id: \.id) { genre in
                    Button(action: {
                        toggleGenreSelection(genre.name)
                    }) {
                        genreButtonContent(genre.name, isSelected: selectedGenres.contains(genre.name))
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
    
    private func genreButtonContent(_ genre: String, isSelected: Bool) -> some View {
        HStack(spacing: 4) {
            Text(genre)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isSelected ? Color.white : Color.blue)
                .padding(.vertical, 6)
                .padding(.leading, 6)
                .padding(.trailing, 6)
            
            if isSelected {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.trailing, 6)
            }
        }
        .background(isSelected ? Color.blue : Color.blue.opacity(0.3))
        .cornerRadius(20)
    }
    
    private func toggleGenreSelection(_ genre: String) {
        if genre == "All Genres" {
            selectedGenres = selectedGenres.contains("All Genres") ? [] : ["All Genres"]
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
    }
    
    private func fetchGenres() {
        TMDBService().fetchGenres { result in
            switch result {
            case .success(let genres):
                DispatchQueue.main.async {
                    self.genres = genres
                }
            case .failure(let error):
                print("Error fetching genres: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchSimilarMovies() {
        TMDBService().fetchMovieDetails(movieId: movieId) { result in
            switch result {
            case .success(let movieDetail):
                DispatchQueue.main.async {
                    self.similarMovies = movieDetail.similar?.results ?? []
                    self.similarMovies = self.similarMovies.map { movie in
                        var updatedMovie = movie
                        updatedMovie.setGenres(from: genres)
                        return updatedMovie
                    }
                }
            case .failure(let error):
                print("Failed to fetch similar movies: \(error.localizedDescription)")
            }
        }
    }
    
    private var filteredMovies: [SimilarMovie] {
        if selectedGenres.isEmpty || selectedGenres.contains("All Genres") {
            return similarMovies
        } else {
            return similarMovies.filter { movie in
                guard let movieGenres = movie.genres else { return false }
                return !Set(selectedGenres).isDisjoint(with: movieGenres)
            }
        }
    }
}

#Preview {
    MoreLikeThisDetail(movieId: 1184918)
}
