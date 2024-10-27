//
//  PosterAndBackdropView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct PosterAndBackdropView: View {
    var movieId: Int
    @State private var selectedTab = 0 // 0: Posters, 1: Backdrops
    @Environment(\.presentationMode) var presentationMode
    @State private var posters: [String] = []
    @State private var backdrops: [String] = []

    var body: some View {
        VStack(spacing: 0) {

            // Tab Bar
            HStack(spacing: 0) {
                
                TabButton(title: "Posters", isSelected: selectedTab == 0, fontSize: 16)
                    .onTapGesture {
                        selectedTab = 0
                    }
                
                TabButton(title: "Backdrops", isSelected: selectedTab == 1, fontSize: 16)
                    .onTapGesture {
                        selectedTab = 1
                    }
                
            }
            .padding(10)
            
            // Content
            if selectedTab == 0 {
                PosterGallery(images: posters)
            } else {
                PosterGallery(images: backdrops)
            }
            
            Spacer()
        }
        .background(Color.mainColor1)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Poster and Backdrops")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(Color.mainColor1, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
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

struct PosterGallery: View {
    let images: [String]
    
    var body: some View {
        TabView {
            ForEach(images, id: \.self) { image in
                ZStack(alignment: .topTrailing) {
                    WebImage(url: URL(string: image))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.6)
                        .cornerRadius(10)
                        .clipped()
                    
                    VStack {
                        Button(action: {
                            // Save button action
                        }) {
                            HStack {
                                Image(systemName: "arrow.down.to.line.alt")
                                    .foregroundColor(.yellow)
                                Text("Save")
                                    .foregroundColor(.yellow)
                            }
                        }
                        .padding(8)
                    }
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(10)
                    .padding(8)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

#Preview {
    PosterAndBackdropView(movieId: 1184918)
}

