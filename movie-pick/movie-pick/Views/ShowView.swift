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

                    

                    AiringTodaySection()
                    
                    Spacer().frame(height: 16)

                    WatchlistSection()
                    
                    Spacer().frame(height: 16)
                    
                    ShowDiscoverSection(text: "Explore Movies and uncover new favorites")
                    
                    
                    Spacer().frame(height: 16)
                    
                
                    ShowComingSoonSection()
                    Spacer().frame(height: 16)
                    
                    
                    ShowStreamingProvidersSection()
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
