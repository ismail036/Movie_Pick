//
//  NowPlayingSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct NowPlayingSection: View {
    
    var title1:String
    var title2:String
    
  var body: some View {
        VStack(alignment: .leading) {
            Text(title1)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title2)
                .font(.subheadline)
                .foregroundColor(.gray)

            
            ScrollView(.horizontal) {
                HStack {
                    
                    VerticalMovieCard(
                        selectedDestination:Destination.movieDetail,
                        movieTitle: "Deadpool & Wolverine",
                        moviePoster: "deadpool_wolverine",
                        rating: 5,
                        releaseYear: "2024"
                    )
                    
                    VerticalMovieCard(
                        selectedDestination:Destination.movieDetail,
                        movieTitle: "Bad Boys: Ride or Die",
                        moviePoster: "bad_boys",
                        rating: 4,
                        releaseYear: "2024"
                    )
                    
                    VerticalMovieCard(
                        selectedDestination:Destination.movieDetail,
                        movieTitle: "Despicable Me 4",
                        moviePoster: "despicable",

                        rating: 3,
                        releaseYear: "2024"
                    )
                    
                    VerticalMovieCard(
                        selectedDestination:Destination.movieDetail,
                        movieTitle: "Deadpool & Wolverine",
                        moviePoster: "deadpool_wolverine",
                        rating: 5,
                        releaseYear: "2024"
                    )
                }
            }
        }
        .background(Color.black)
    }
}

#Preview {
    NowPlayingSection(title1: "Now Playing", title2: "Current  Films on Big Screens")
}
