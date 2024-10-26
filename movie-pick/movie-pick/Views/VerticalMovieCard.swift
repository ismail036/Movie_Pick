//
//  TrendingMovieCardView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

//
//  TrendingMovieCardView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct VerticalMovieCard: View {
    var selectedDestination: Destination = .movieDetail
    var movieTitle: String
    var moviePoster: String // Poster URL'si
    var rating: Int
    var releaseYear: String
    var multiplier: CGFloat = 0.8
    
    var body: some View {
        NavigationLink(destination: destinationView) {
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Spacer()
                    
                    Text(movieTitle)
                        .font(.system(size: 14 * multiplier))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .padding(.leading, 8 * multiplier)
                        .padding(.bottom, 1 * multiplier)
                    
                    HStack {
                        HStack(spacing: 2 * multiplier) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < rating ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 12 * multiplier))
                            }
                        }
                        
                        Spacer()
                        
                        Text(releaseYear)
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
                
                AsyncImage(url: URL(string: moviePoster)) { image in
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
        .simultaneousGesture(TapGesture().onEnded {
            print("NavigationLink to \(selectedDestination) was tapped")
        })
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    private var destinationView: some View {
        switch selectedDestination {
        case .movieDetail:
            MovieDetail(movie:  MovieModel(id: 1184918, title: "The Wild Robot", originalTitle: Optional("The Wild Robot"), overview: "After a shipwreck, an intelligent robot called Roz is stranded on an uninhabited island. To survive the harsh environment, Roz bonds with the island\'s animals and cares for an orphaned baby goose.", posterPath: Optional("/wTnV3PCVW5O92JMrFvvrRcV39RU.jpg"), backdropPath: Optional("/417tYZ4XUyJrtyZXj7HpvWf1E8f.jpg"), releaseDate: Optional("2024-09-12"), runtime: nil, voteAverage: Optional(8.641), voteCount: Optional(1514), genreIds: Optional([16, 878, 10751]), genres: nil, popularity: Optional(5400.805), originalLanguage: Optional("en"), adult: Optional(false), budget: nil, revenue: nil, tagline: nil, homepage: nil, status: nil))
        case .showDetail:
            ShowDetail()
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
        movieTitle: "Deadpool & Wolverine",
        moviePoster: "https://image.tmdb.org/t/p/w500/deadpool_wolverine.jpg",
        rating: 4,
        releaseYear: "2024"
    )
}
