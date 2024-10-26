//
//  DiscoverSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct DiscoverSection: View {
    var text: String
    let categories = ["Action", "Adventure", "Animation", "Comedy", "Horror", "Sci-Fi"]
    @State private var visibleCategories: [String] = []
    @State private var remainingCategories: [String] = []
    @State private var discoverMovies: [MovieModel] = [] // API'den gelen filmler

    var body: some View {
        VStack(alignment: .leading) {
            Text("Discover")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Explore Movies and uncover new favorites")
                .font(.system(size: 12))
                .foregroundColor(Color.cyanBlue)

            GeometryReader { geometry in
                HStack {
                    ForEach(visibleCategories, id: \.self) { category in
                        CategoryButtonView(title: category)
                    }

                    if !remainingCategories.isEmpty {
                        NavigationLink(destination: DiscoverDetail()) {
                            CategoryButtonView(title: "More...")
                        }
                    }
                }
                .onAppear {
                    calculateVisibleCategories(for: geometry.size.width)
                }
                .padding(.horizontal, 0)
            }
            .frame(height: 50)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(discoverMovies) { movie in
                        NavigationLink(destination: MovieDetail(movie: movie)) {
                            DiscoverMovieCardView(
                                movieTitle: movie.title,
                                releaseDate: movie.releaseDate ?? "Unknown",
                                rating: Int((movie.voteAverage ?? 0) / 2),
                                genres: movie.genres?.map { $0.name } ?? [],
                                description: movie.overview,
                                posterImageURL: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")" // Tam URL yapısı
                            )
                            .frame(width: UIScreen.main.bounds.width * 0.95)
                        }
                    }
                }
                .padding(.horizontal, 0)
                .padding(.vertical, 0)
            }
            .padding(.leading, 0)
        }
        .background(Color.mainColor1)
        .onAppear {
            fetchDiscoverMovies()
        }
    }

    private func fetchDiscoverMovies() {
        TMDBService().fetchDiscoverMovies { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self.discoverMovies = movies
                }
            case .failure(let error):
                print("Failed to fetch discover movies: \(error.localizedDescription)")
            }
        }
    }

    private func calculateVisibleCategories(for totalWidth: CGFloat) {
        var currentWidth: CGFloat = 0
        let buttonPadding: CGFloat = 16
        let moreButtonWidth: CGFloat = 80

        visibleCategories = []
        remainingCategories = []

        for category in categories {
            let buttonWidth = category.widthOfString(usingFont: .systemFont(ofSize: 14, weight: .bold)) + buttonPadding * 2

            if currentWidth + buttonWidth + moreButtonWidth <= totalWidth {
                visibleCategories.append(category)
                currentWidth += buttonWidth + buttonPadding
            } else {
                remainingCategories.append(category)
            }
        }
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes).width
    }
}

#Preview {
    DiscoverSection(text: "Explore Movies and uncover new favorites")
}
