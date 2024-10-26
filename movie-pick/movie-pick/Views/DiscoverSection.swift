//
//  DiscoverSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct DiscoverSection: View {
    
    
    var text:String

    let categories = ["Action", "Adventure", "Animation", "Comedy", "Horror", "Sci-Fi"]
    @State private var visibleCategories: [String] = []
    @State private var remainingCategories: [String] = []

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
                        .simultaneousGesture(TapGesture().onEnded {
                            print("NavigationLink to DiscoverDetail was tapped")
                        })
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
                    NavigationLink(destination: MovieDetail(movie:  MovieModel(id: 1184918, title: "The Wild Robot", originalTitle: Optional("The Wild Robot"), overview: "After a shipwreck, an intelligent robot called Roz is stranded on an uninhabited island. To survive the harsh environment, Roz bonds with the island\'s animals and cares for an orphaned baby goose.", posterPath: Optional("/wTnV3PCVW5O92JMrFvvrRcV39RU.jpg"), backdropPath: Optional("/417tYZ4XUyJrtyZXj7HpvWf1E8f.jpg"), releaseDate: Optional("2024-09-12"), runtime: nil, voteAverage: Optional(8.641), voteCount: Optional(1514), genreIds: Optional([16, 878, 10751]), genres: nil, popularity: Optional(5400.805), originalLanguage: Optional("en"), adult: Optional(false), budget: nil, revenue: nil, tagline: nil, homepage: nil, status: nil))){
                        DiscoverMovieCardView(
                            movieTitle: "Beetlejuice Beetlejuice Beetlejuice",
                            releaseDate: "2023 Jul, 21",
                            rating: 4,
                            genres: ["Action", "Adventure", "Animation"],
                            description: "After a family tragedy, three generations of the Deetz family return home to Winter River.",
                            posterImage: "beetlejuice"
                        )
                        .frame(width: UIScreen.main.bounds.width * 0.95)
                    }
                }
                .padding(.horizontal, 0)
                .padding(.vertical, 0)
            }
            .padding(.leading, 0)
        }
        .background(Color.mainColor1)
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




