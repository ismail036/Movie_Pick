//
//  StreamingProvidersSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

import SwiftUI

struct StreamingProvidersSection: View {
    let providers = [
        ("Netflix", Color.red),
        ("Disney+", Color.blue),
        ("Apple TV+", Color.black),
        ("Hulu", Color.green),
        ("Amazon Prime", Color.blue.opacity(0.7)),
        ("Max", Color.gray),
        ("Paramount+", Color.blue),
        ("Crunchyroll", Color.orange),
        ("Peacock Premium", Color.blue.opacity(0.5))
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Streaming Providers")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Find Movies from your favorite streaming services")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(providers, id: \.0) { provider in
                        Text(provider.0)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(provider.1)
                            .cornerRadius(20)
                    }
                }
                .padding(.top, 10)
            }
            
            ScrollView(.horizontal) {
                HStack {
                    VerticalMovieCard(
                        selectedDestination: .movieDetail,
                        movieId: 1232454
                    )
                    VerticalMovieCard(
                        selectedDestination: .movieDetail,
                        movieId: 1232454
                    )
                    VerticalMovieCard(
                        selectedDestination: .movieDetail,
                        movieId: 1232454
                    )
                    VerticalMovieCard(
                        selectedDestination: .movieDetail,
                        movieId: 1232454
                    )
                }
            }
        }
        .background(Color.black)
    }
}

#Preview {
    StreamingProvidersSection()
}
