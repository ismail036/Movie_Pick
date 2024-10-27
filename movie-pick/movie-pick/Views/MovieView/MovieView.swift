//
//  MovieView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct MovieView: View {
    var body: some View {
        ZStack {
            Color.mainColor1
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading) {
                    WelcomeSection(text: "TV Shows")
                    Spacer().frame(height: 16)
                    
                    TrendingSection()
                    Spacer().frame(height: 16)
                    
                    DiscoverSection(text: "Explore Movies and uncover new favorites")
                    Spacer().frame(height: 32)
                    
                    ComingSoonSection()
                    Spacer().frame(height: 16)
                    
                    WatchlistSection()
                    Spacer().frame(height: 16)
                    
                    BoxOfficeView()
                    Spacer().frame(height: 16)
                    
                    PeopleSection(text:"Popular People")
                    Spacer().frame(height: 16)
                    
                    StreamingProvidersSection()
                    Spacer().frame(height: 16)
                    
                    NowPlayingSection(title1: "Now Playing", title2: "Current  Films on Big Screens")
                    Spacer().frame(height: 50)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.horizontal, 8)
                .padding(.vertical, 16)
            }
        }
    }
}

#Preview {
    MovieView()
}
 
