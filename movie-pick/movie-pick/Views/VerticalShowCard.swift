//
//  VerticalShowCard.swift
//  movie-pick
//
//  Created by İsmail Parlak on 27.10.2024.
//

import SwiftUI

struct VerticalShowCard: View {
    var selectedDestination: Destination = .showDetail
    var showId: Int
    @State private var showDetail: TVShowModel? // Dizi detayı için state
    var multiplier: CGFloat = 0.8

    var body: some View {
        NavigationLink(destination: destinationView) {
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Spacer()

                    Text(showDetail?.name ?? "Loading...")
                        .font(.system(size: 14 * multiplier))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .padding(.leading, 8 * multiplier)
                        .padding(.bottom, 1 * multiplier)

                    HStack {
                        HStack(spacing: 2 * multiplier) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int((showDetail?.voteAverage ?? 0) / 2) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 12 * multiplier))
                            }
                        }

                        Spacer()

                        Text(String(showDetail?.firstAirDate?.prefix(4) ?? "N/A"))
                            .font(.system(size: 12 * multiplier))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8 * multiplier)
                    .padding(.bottom, 8 * multiplier)
                }
                .frame(width: 165 * multiplier, height: 210 * multiplier)
                .background(Color.mainColor3)
                .cornerRadius(12 * multiplier)
                .offset(y: 10 * multiplier)

                AsyncImage(url: showDetail?.posterURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 220 * multiplier)
                        .cornerRadius(12 * multiplier)
                        .offset(y: -45 * multiplier)
                } placeholder: {
                    Color.gray
                        .frame(height: 220 * multiplier)
                        .cornerRadius(12 * multiplier)
                        .offset(y: -50 * multiplier)
                }
            }
            .frame(width: 170 * multiplier, height: 310 * multiplier)
            .cornerRadius(12)
            .shadow(radius: 5)
        }
        .onAppear {
            fetchShowDetail()
        }
        .navigationBarBackButtonHidden(true)
    }

    @ViewBuilder
    private var destinationView: some View {
        if let show = showDetail {

        } else {
            Text("Loading...")
        }
    }

    private func fetchShowDetail() {
        TMDBService().fetchShowById(showId: showId) { result in
            switch result {
            case .success(let show):
                DispatchQueue.main.async {
                    self.showDetail = show
                }
            case .failure(let error):
                print("Failed to fetch show detail: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    VerticalShowCard(
        selectedDestination: .showDetail,
        showId: 1412
    )
}
