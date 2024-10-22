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
            
            Image(posterImage)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 180)
                .cornerRadius(12)
            
            VStack(alignment: .leading) {
                
                Text(movieTitle)
                    .foregroundColor(.white)
                    .padding(.vertical,2)
                    
                Text("Total Gross: \(totalGross)")
                    .foregroundColor(.white)
                    .padding(.vertical,2)
                
                Text("Weekend Gross: \(weekendGross)")
                    .foregroundColor(.white)
                    .padding(.vertical,2)
                
                Text("Week: \(week)")
                    .foregroundColor(.white)
                    .padding(.vertical,2)
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.mainColor1)
            .cornerRadius(20)
        }
        .frame(maxWidth: .infinity)
        .background(Color.mainColor1)
        .cornerRadius(20)
        .padding(.leading, 0)
        .padding(.trailing, 0)

    }
}

#Preview {
    BoxOfficeMovieCard(
        posterImage: "beetlejuice",
        movieTitle: "Beetlejuice Beetlejuice Beetlejuice",
        totalGross: "$40M",
        weekendGross: "$40$",
        week: 1
    )
}
