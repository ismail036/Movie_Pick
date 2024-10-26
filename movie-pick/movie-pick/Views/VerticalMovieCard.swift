//
//  TrendingMovieCardView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct VerticalMovieCard: View {
    var selectedDestination: Destination = .movieDetail
    var movieId: Int
    @State private var movieDetail: MovieModel? // Film detayı için state
    var multiplier: CGFloat = 0.8

    var body: some View {
        NavigationLink(destination: destinationView) {
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Spacer()

                    Text(movieDetail?.title ?? "Loading...")
                        .font(.system(size: 14 * multiplier))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .padding(.leading, 8 * multiplier)
                        .padding(.bottom, 1 * multiplier)

                    HStack {
                        HStack(spacing: 2 * multiplier) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int((movieDetail?.voteAverage ?? 0) / 2) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 12 * multiplier))
                            }
                        }

                        Spacer()

                        Text(String(movieDetail?.releaseDate?.prefix(4) ?? "N/A"))
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

                AsyncImage(url: movieDetail?.posterURL) { image in
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
            fetchMovieDetail()
        }
        .navigationBarBackButtonHidden(true)
    }

    @ViewBuilder
    private var destinationView: some View {
        if let movie = movieDetail {
            MovieDetail(movie: movie) // Dinamik olarak çekilen film detayı MovieDetail'e gönderiliyor
        } else {
            Text("Loading...")
        }
    }

    private func fetchMovieDetail() {
        TMDBService().fetchMovieById(movieId: movieId) { result in
            switch result {
            case .success(let movie):
                DispatchQueue.main.async {
                    self.movieDetail = movie
                }
            case .failure(let error):
                print("Failed to fetch movie detail: \(error.localizedDescription)")
            }
        }
    }
}

enum Destination {
    case movieDetail
    case showDetail
}

#Preview {
    VerticalMovieCard(
        selectedDestination: .movieDetail,
        movieId: 1232454
    )
}
