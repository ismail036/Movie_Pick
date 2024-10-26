//
//  WelcomeSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct WelcomeSection: View {
    @State private var topTwoMovies: [MovieModel] = []
    var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.clear)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("MainColor2Primary"), Color("MainColor2Secondary")]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(
                        Text(text)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    )
                )

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(topTwoMovies) { movie in
                        MainMovieCardView(movie: movie)
                            .frame(width: UIScreen.main.bounds.width * 0.95)
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.mainColor1)
        .onAppear {
            TMDBService().fetchTopTwoMovies { result in
                switch result {
                case .success(let movies):
                    topTwoMovies = movies
                case .failure(let error):
                    print("Error fetching top two movies: \(error)")
                }
            }
        }
    }
}

#Preview {
    WelcomeSection(text: "Welcome")
}
