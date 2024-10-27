//
//  DiscoverShowCardView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct DiscoverShowCardView: View {
    var showTitle: String
    var firstAirDate: String
    var rating: Int
    var genres: [String]
    var description: String
    var posterImageURL: String // Tam URL olarak poster resim URL'si

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text(showTitle)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text(firstAirDate)
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
            
            WebImage(url: URL(string: posterImageURL))
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
    DiscoverShowCardView(
        showTitle: "Breaking Bad",
        firstAirDate: "2008 Jan, 20",
        rating: 5,
        genres: ["Drama", "Crime"],
        description: "A high school chemistry teacher turned methamphetamine producer.",
        posterImageURL: "https://image.tmdb.org/t/p/w500/breaking_bad_poster.jpg"
    )
}
