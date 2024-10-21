//
//  TrendingSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct TrendingSection: View {
    
    @State private var selectedTab: String = "Today"
    
    var body: some View {
        VStack(alignment: (.leading)) {
            
            HStack(alignment: .bottom) {
                       Text("Trending")
                    .font(.system(size: 22))
                           .fontWeight(.bold)
                           .foregroundColor(.white)
                       
                                              Button(action: {
                           selectedTab = "Today"
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
                       }) {
                           Text("This Week")
                               .font(.system(size: 16))
                               .fontWeight(selectedTab == "This Week" ? .bold : .regular)
                               .foregroundColor(selectedTab == "This Week" ? .white : .gray)
                       }
                   }
                   .padding(.horizontal)
            
                
            
            ScrollView(.horizontal) {
                HStack {
                    
                    TrendingMovieCardView(
                        movieTitle: "Deadpool & Wolverine",
                        moviePoster: "deadpool_wolverine",
                        rating: 5,
                        releaseYear: "2024"
                    )
                    
                    TrendingMovieCardView(
                        movieTitle: "Bad Boys: Ride or Die",
                        moviePoster: "bad_boys",
                        rating: 4,
                        releaseYear: "2024"
                    )
                    
                    TrendingMovieCardView(
                        movieTitle: "Despicable Me 4",
                        moviePoster: "despicable",
                        rating: 3,
                        releaseYear: "2024"
                    )
                    
                    TrendingMovieCardView(
                        movieTitle: "Deadpool & Wolverine",
                        moviePoster: "deadpool_wolverine",
                        rating: 5,
                        releaseYear: "2024"
                    )
                }
            }
            
            
        }
        .frame(maxWidth: .infinity)
                .background(Color.mainColor1)
    }

}

#Preview {
    TrendingSection()
}