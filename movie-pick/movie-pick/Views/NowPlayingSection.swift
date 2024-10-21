//
//  NowPlayingSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct NowPlayingSection: View {
  var body: some View {
        VStack(alignment: .leading) {
            Text("Now Playing")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Current  Films on Big Screens")
                .font(.subheadline)
                .foregroundColor(.gray)

            
            ScrollView(.horizontal) {
                HStack {
                    
                    VerticalMovieCard(
                        movieTitle: "Deadpool & Wolverine",
                        moviePoster: "deadpool_wolverine",
                        rating: 5,
                        releaseYear: "2024"
                    )
                    
                    VerticalMovieCard(
                        movieTitle: "Bad Boys: Ride or Die",
                        moviePoster: "bad_boys",
                        rating: 4,
                        releaseYear: "2024"
                    )
                    
                    VerticalMovieCard(
                        movieTitle: "Despicable Me 4",
                        moviePoster: "despicable",
                        rating: 3,
                        releaseYear: "2024"
                    )
                    
                    VerticalMovieCard(
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
    NowPlayingSection()
}
