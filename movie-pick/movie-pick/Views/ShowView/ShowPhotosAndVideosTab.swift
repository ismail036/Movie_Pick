//
//  ShowPhotosAndVideosTab.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ShowPhotosAndVideosTab: View {
    var showId: Int
    @State private var posters: [String] = []
    @State private var backdrops: [String] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if !posters.isEmpty {
                    ShowSectionHeaderView(title: "Posters", showId: showId)
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
                
                if !backdrops.isEmpty {
                    ShowSectionHeaderView(title: "Backdrops", showId: showId)
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
                
                ShowVideosSection(showId: showId)
            }
            .padding(.top, 16)
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            fetchImages()
        }
    }
    
    private func fetchImages() {
        TMDBService().fetchTVShowDetails(showId: showId) { result in
            switch result {
            case .success(let showDetail):
                DispatchQueue.main.async {
                    self.posters = showDetail.images?.posters.compactMap { $0.url } ?? []
                    self.backdrops = showDetail.images?.backdrops.compactMap { $0.url } ?? []
                }
            case .failure(let error):
                print("Failed to fetch show images: \(error.localizedDescription)")
            }
        }
    }
}

struct ShowSectionHeaderView: View {
    let title: String
    var showId: Int
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            NavigationLink(destination: PosterAndBackdropView(movieId: self.showId)) {
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
    ShowPhotosAndVideosTab(showId: 1396) 
}
