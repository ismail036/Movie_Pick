//
//  MainMovieCardView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct MainMovieCardView: View {
    var movie: MovieModel

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(movie.overview)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                HStack {
                    ForEach(movie.genreIds ?? [], id: \.self) { genreId in
                        Text(genreName(for: genreId))
                    }
                    .font(.footnote)
                    .foregroundColor(.gray)
                }
                
                HStack {
                    Text(movie.releaseDate ?? "Unknown date")
                        .font(.footnote)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        ForEach(0..<5) { star in
                            Image(systemName: star < Int(movie.voteAverage ?? 0) / 2 ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.caption)
                                .imageScale(.medium)
                        }
                    }
                }
                
                NavigationLink(destination: MovieDetail(movie: self.movie)) {
                    Text("Details")
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            Spacer()
            
            if let posterPath = movie.posterPath {
                AsyncImage(url: movie.posterURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 180)
                        .cornerRadius(10)
                        .padding(.trailing)
                } placeholder: {
                    Color.gray
                        .frame(width: 120, height: 180)
                        .cornerRadius(10)
                        .padding(.trailing)
                }
            }
        }
        .background(Color.mainColor1)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    private func genreName(for id: Int) -> String {
        // Genre ID'ye göre isim dönüştürme
        let genres = [
            28: "Action",
            12: "Adventure",
            16: "Animation",
            35: "Comedy",
            80: "Crime",
            99: "Documentary",
            18: "Drama",
            10751: "Family",
            14: "Fantasy",
            36: "History",
            27: "Horror",
            10402: "Music",
            9648: "Mystery",
            10749: "Romance",
            878: "Sci-Fi",
            10770: "TV Movie",
            53: "Thriller",
            10752: "War",
            37: "Western"
        ]
        return genres[id] ?? "Unknown"
    }
}

