//
//  MoreLikeThisSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct MoreLikeThisSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("More Like This")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                NavigationLink(destination: MoreLikeThisDetail()){
                    HStack {
                            Text("View More")
                            Image(systemName: "chevron.right")
                        }
                    }
                    .foregroundColor(.blue)
                    .navigationBarBackButtonHidden(true)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    VerticalMovieCard(
                        movieTitle: "S.O.S. Bikini Bottom : Une mission pour Sandy Écureuil",
                        moviePoster: "bikini_bottom",
                        rating: 0,
                        releaseYear: "2024"
                    )
                    
                    VerticalMovieCard(
                        movieTitle: "Venom: The Last Dance",
                        moviePoster: "venom",
                        rating: 0,
                        releaseYear: "2024"
                    )
                    
                    VerticalMovieCard(
                        movieTitle: "Smile 2",
                        moviePoster: "smile",
                        rating: 0,
                        releaseYear: "2024"
                    )
                }
                .padding(.horizontal, 0)
                .padding(.vertical, 0)
            }
            
            
        }
        .background(Color.black)
        .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    MoreLikeThisSection()
}
