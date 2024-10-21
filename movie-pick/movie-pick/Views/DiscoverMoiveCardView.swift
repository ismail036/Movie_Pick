//
//  DiscoverMoiveCardView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct DiscoverMovieCardView: View {
    var movieTitle: String
    var releaseDate: String
    var rating: Int
    var genres: [String]
    var description: String
    var posterImage: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text(movieTitle)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text(releaseDate)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < rating ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.system(size: 14))
                        }
                    }
                }
                
                HStack {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                }
                
                Text(description)
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
            .padding()
            .background(Color.mainColor3)
            .cornerRadius(20)
            
            Image(posterImage)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 180)
                .cornerRadius(12)
        }
        .frame(maxWidth: .infinity) 
        .background(Color.mainColor3)
        .cornerRadius(20)
        .padding(.leading, 0)
        .padding(.trailing, 0)
    }
}

#Preview {
    DiscoverMovieCardView(
        movieTitle: "Beetlejuice Beetlejuice Beetlejuice",
        releaseDate: "2023 Jul, 21",
        rating: 4,
        genres: ["Action", "Adventure", "Animation"],
        description: "After a family tragedy, three generations of the Deetz family return home to Winter River.",
        posterImage: "beetlejuice"
    )
}
