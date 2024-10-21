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
            
            
            VStack(
                alignment: .leading
            ) {
                
                WelcomeSection()
                
                Spacer().frame(height: 16)
                
                TrendingSection()
                

            }
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .topLeading
            )
            .background(Color.mainColor1)
            .padding(.horizontal,16)
            .padding(.vertical,16)
        }

    }
        
}

#Preview {
    MovieView()
}
