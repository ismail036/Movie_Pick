//
//  VideosSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//


import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct VideosSection: View {
    @State private var selectedVideo: MovieVideo? // Seçili video
    @State private var videos: [MovieVideo] = [] // Videoları burada saklayacağız
    
    let movieId: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Videos")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
              /*  NavigationLink(destination: VideosDetail()) {
                    HStack {
                        Text("View More")
                        Image(systemName: "chevron.right")
                    }
                }
                .foregroundColor(.blue)
                .navigationBarBackButtonHidden(true) */
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(videos) { video in
                        VStack(alignment: .leading) {
                            ZStack(alignment: .center) {
                                AsyncImage(url: video.thumbnailURL) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 180, height: 100)
                                        .cornerRadius(8)
                                } placeholder: {
                                    Color.gray
                                        .frame(width: 180, height: 100)
                                        .cornerRadius(8)
                                }
                                
                                Button(action: {
                                    selectedVideo = video
                                }) {
                                    Image(systemName: "play.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.white)
                                        .shadow(radius: 10)
                                }
                            }
                            
                            Text(video.name ?? "Unknown Title")
                                .font(.body)
                                .foregroundColor(.white)
                                .padding(.top, 5)
                                .lineLimit(2)

                        }
                        .frame(width: 180)
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.black)
        .navigationBarBackButtonHidden(true)
        .sheet(item: $selectedVideo) { video in
            if let url = video.videoURL {
                WebView(url: url)
            }
        }
        .onAppear(perform: loadVideos)
    }
    
    private func loadVideos() {
        TMDBService().fetchMovieDetails(movieId: movieId) { result in
            switch result {
            case .success(let movieDetail):
                DispatchQueue.main.async {
                    self.videos = movieDetail.videos?.results ?? []
                }
            case .failure(let error):
                print("Failed to fetch videos: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    VideosSection(movieId: 1184918)
}
