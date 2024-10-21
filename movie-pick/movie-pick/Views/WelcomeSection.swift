//
//  WelcomeSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct WelcomeSection: View {
    var body: some View {
        VStack(alignment: (.leading)) {
            Text("Welcome")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.clear)                             .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("MainColor2Primary"), Color("MainColor2Secondary")]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(
                        Text("Welcome")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    )
                )
            
            ScrollView(.horizontal) {
                HStack {
                    
                    MainMovieCardView()
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                    MainMovieCardView()
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                }
            }
            
            
        }
        .background(Color.mainColor1)
    }
}

#Preview {
    WelcomeSection()
}
