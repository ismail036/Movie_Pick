//
//  DetailInfoCard.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//
import SwiftUI

struct MovieDetailInfoCard: View {
    let movieDetails: [String: String] = [
        "Status": "Released",
        "Release Date": "03/04/2022",
        "Original Language": "English",
        "Runtime": "2h 56m",
        "Budget": "$185,000,000.00",
        "Revenue": "$672,000,000.00"
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Details")
                .font(.headline)
                .padding(.bottom, 10)
                .foregroundStyle(Color.white)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(movieDetails.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text(key)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(value)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 5)
                    .overlay(
                        Divider().background(Color.blue)
                            .frame(height: 1),
                        alignment: .bottom
                    )
                }
            }
            .padding()
            .background(Color.mainColor3)
            .cornerRadius(10) 
        }
        .padding()
        .background(Color.mainColor1)
    }
}

#Preview {
    MovieDetailInfoCard()
}
