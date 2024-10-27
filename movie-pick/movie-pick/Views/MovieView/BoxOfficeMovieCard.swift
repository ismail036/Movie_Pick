//
//  BoxOfficeMovieCard.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct BoxOfficeMovieCard: View {
    var posterImage: String
    var movieTitle: String
    var totalGross: String
    var weekendGross: String
    var week: Int

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // Resmi URL'den yüklüyoruz
            if let url = URL(string: posterImage) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .scaledToFill()
                .frame(width: 120, height: 180)
                .cornerRadius(12)
            } else {
                Color.gray
                    .frame(width: 120, height: 180)
                    .cornerRadius(12)
            }
            
            VStack(alignment: .leading) {
                Text(movieTitle)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 2)
                
                Text("Total Gross: \(totalGross)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.vertical, 2)
                
                Text("Weekend Gross: \(weekendGross)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.vertical, 2)
                
                Text("Week: \(week)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.vertical, 2)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.mainColor1)
            .cornerRadius(20)
        }
        .frame(maxWidth: .infinity)
        .background(Color.mainColor1)
        .cornerRadius(20)
        .padding(.horizontal, 8)
    }
}

#Preview {
    BoxOfficeMovieCard(
        posterImage: "https://image.tmdb.org/t/p/w500/beetlejuice.jpg",
        movieTitle: "Beetlejuice Beetlejuice Beetlejuice",
        totalGross: "$40M",
        weekendGross: "$40M",
        week: 1
    )
}
