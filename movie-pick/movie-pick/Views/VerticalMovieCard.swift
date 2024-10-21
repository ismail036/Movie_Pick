//
//  TrendingMovieCardView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct VerticalMovieCard: View {
    var movieTitle: String
    var moviePoster: String
    var rating: Int
    var releaseYear: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Spacer()
                
                Text(movieTitle)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .padding(.leading, 8)
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 0)
                
                HStack {
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < rating ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.system(size: 12))
                        }
                    }
                    
                    Spacer()
                    
                    
                    Text(releaseYear)
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 1)
            }
            .frame(width: 165, height: 210)
            .background(Color.mainColor3)
            .cornerRadius(12)
            .offset(y: 40)
            
            
            Image(moviePoster)
                .resizable()
                .scaledToFit()
                .frame(height: 220)
                .cornerRadius(12)
                .offset(y: -45)
        }
        .frame(width: 170, height: 310)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

#Preview {
    VerticalMovieCard(
        movieTitle: "Deadpool & Wolverine",
        moviePoster: "deadpool_wolverine",
        rating: 4,
        releaseYear: "2024"
    )
}
