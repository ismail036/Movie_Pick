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
    var moviePoster: String
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
                        .lineLimit(2)
                        .padding(.leading, 8 * multiplier)
                    
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
                .offset(y: 40 * multiplier)
                
                Image(moviePoster)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220 * multiplier)
                    .cornerRadius(12 * multiplier)
                    .offset(y: -45 * multiplier)
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
            MovieDetail()
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
        moviePoster: "deadpool_wolverine",
        rating: 4,
        releaseYear: "2024"
    )
}

