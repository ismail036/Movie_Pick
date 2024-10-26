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
                        selectedDestination: .movieDetail,
                        movieId: 1232454
                    )
                    
                    VerticalMovieCard(
                        selectedDestination: .movieDetail,
                        movieId: 1232454
                    )
                    
                    VerticalMovieCard(
                        selectedDestination: .movieDetail,
                        movieId: 1232454
                    )
                    
                    VerticalMovieCard(
                        selectedDestination: .movieDetail,
                        movieId: 1232454
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
