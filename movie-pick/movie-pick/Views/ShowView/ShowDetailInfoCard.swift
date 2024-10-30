//
//  ShowDetailInfoCard.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI

struct ShowDetailInfoCard: View {
    var showId: Int
    @State private var showDetails: [String: String] = [:]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Details")
                .font(.headline)
                .padding(.bottom, 10)
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(showDetails.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
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
            fetchShowDetails()
        }
    }

    private func fetchShowDetails() {
        TMDBService().fetchTVShowDetails(showId: showId) { result in
            switch result {
            case .success(let showDetail):
                DispatchQueue.main.async {
                    showDetails = [
                        "Status": showDetail.status ?? "N/A",
                        "First Air Date": showDetail.firstAirDateFormatted ?? "N/A",
                        "Original Language": showDetail.originalLanguage ?? "N/A",
                        "Episode Runtime": showDetail.episodeRunTime?.first != nil ? "\(showDetail.episodeRunTime!.first!) min" : "N/A",
                        "Number of Seasons": "\(showDetail.seasons?.count ?? 0)",
                        "Vote Average": showDetail.voteAverageFormatted
                    ]
                }
            case .failure(let error):
                print("Failed to fetch show details: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ShowDetailInfoCard(showId: 1396)
}
