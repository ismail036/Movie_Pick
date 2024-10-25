//
//  ShowView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 24.10.2024.
//

import SwiftUI

struct ShowView: View {
    var body: some View {
        ZStack {
            Color.mainColor1
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading) {
                    
                    
                    Text("TV Shows")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.clear)                             .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("MainColor2Primary"), Color("MainColor2Secondary")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .mask(
                                Text("TV Shows")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            )
                        )

                    Spacer().frame(height: 16)

                    
                    VStack(alignment: .leading) {
                        Text("Airing Today")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("October 14, 2024, Watch the newest episodes")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        
                        ScrollView(.horizontal) {
                            HStack {
                                
                                VerticalMovieCard(
                                    selectedDestination:Destination.showDetail,
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
                
                    
                    Spacer().frame(height: 16)

                    WatchlistSection()
                    
                    Spacer().frame(height: 16)
                    
                    DiscoverSection(text: "Explore Movies and uncover new favorites")
                    
                    
                    Spacer().frame(height: 16)
                    
                
                    ComingSoonSection()
                    Spacer().frame(height: 16)
                    
                    
                    StreamingProvidersSection()
                    Spacer().frame(height: 16)
                    
                    NowPlayingSection(title1: "Top Rated", title2: "The Best-Ranked Series Out There")
                    
                    Spacer().frame(height: 16)
                    
                    NowPlayingSection(title1: "On Air", title2: "TV Shows that air in the 7 days")
                    
                    
                    Spacer().frame(height: 50)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
        }
    }
}

#Preview {
    ShowView()
}
