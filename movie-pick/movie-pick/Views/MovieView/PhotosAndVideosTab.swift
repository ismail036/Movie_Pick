//
//  PhotosAndVideosTab.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct PhotosAndVideosTab: View {
    var movieId: Int
    @State private var posters: [String] = []
    @State private var backdrops: [String] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Posters Section
                if !posters.isEmpty {
                    SectionHeaderView(title: "Posters", movieId: movieId)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(posters, id: \.self) { poster in
                                WebImage(url: URL(string: poster))
                                    .resizable()
                                    .frame(width: 120, height: 180)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Backdrops Section
                if !backdrops.isEmpty {
                    SectionHeaderView(title: "Backdrops", movieId: movieId)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(backdrops, id: \.self) { backdrop in
                                WebImage(url: URL(string: backdrop))
                                    .resizable()
                                    .frame(width: 250, height: 140)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Videos Section
                VideosSection(movieId: movieId)
            }
            .padding(.top, 16)
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            fetchImages()
        }
    }
    
    private func fetchImages() {
        TMDBService().fetchMovieDetails(movieId: movieId) { result in
            switch result {
            case .success(let movieDetail):
                DispatchQueue.main.async {
                    self.posters = movieDetail.images?.posters.compactMap { $0.url } ?? []
                    self.backdrops = movieDetail.images?.backdrops.compactMap { $0.url } ?? []
                }
            case .failure(let error):
                print("Failed to fetch movie images: \(error.localizedDescription)")
            }
        }
    }
}

struct SectionHeaderView: View {
    let title: String
    var movieId: Int
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            NavigationLink(destination: PosterAndBackdropView(movieId: self.movieId)) {
                HStack {
                    Text("View More")
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    PhotosAndVideosTab(movieId: 1184918)
}
