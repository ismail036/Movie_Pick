//
//  DetailInfoCard.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct MovieDetailInfoCard: View {
    var movieId: Int
    @State private var movieDetails: [String: String] = [:]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Details")
                .font(.headline)
                .padding(.bottom, 10)
                .foregroundColor(.white)

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
                }
            }
            .padding()
            .background(Color.mainColor3)
            .cornerRadius(10)
        }
        .padding()
        .background(Color.mainColor1)
        .cornerRadius(10)
        .onAppear {
            fetchMovieDetails()
        }
    }

    private func fetchMovieDetails() {
        TMDBService().fetchMovieDetails(movieId: movieId) { result in
            switch result {
            case .success(let movieDetail):
                DispatchQueue.main.async {
                    movieDetails = [
                        "Status": movieDetail.status ?? "N/A",
                        "Release Date": movieDetail.releaseDateFormatted ?? "N/A",
                        "Original Language": movieDetail.originalLanguage ?? "N/A",
                        "Runtime": movieDetail.runtime != nil ? "\(movieDetail.runtime! / 60)h \(movieDetail.runtime! % 60)m" : "N/A",
                        "Budget": movieDetail.budgetFormatted,
                        "Revenue": movieDetail.revenueFormatted
                    ]
                }
            case .failure(let error):
                print("Failed to fetch movie details: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    MovieDetailInfoCard(movieId: 1184918)
}

