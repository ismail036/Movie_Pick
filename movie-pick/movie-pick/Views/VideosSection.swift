//
//  VideosSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//


import SwiftUI
import AVKit

// Video Modeli: Her bir videonun bilgilerini içerir
struct Video: Identifiable {
    let id = UUID()
    let videoURL: URL // Video URL'si
    let thumbnailURL: URL // Kapak resminin URL'si
    let title: String // Video başlığı
    let daysAgo: String // Video yayın tarihi bilgisi
}

struct VideosSection: View {
    @State private var selectedVideo: Video? // Seçili video oynatıcıda gösterilecek
    
    let videos = [
        Video(videoURL: URL(string: "https://www.youtube.com/watch?v=RlfooqeZcdY")!,
              thumbnailURL: URL(string: "https://s3-alpha-sig.figma.com/img/f3ad/bfae/4cfc63a9fe738d63aeb88f08dc8ec8be?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=SafOjwuVnNNWDomkoHBKpRb3HQshFRxdPZSM6EiHE6Eub8-MG75XhZXQ0m0MFztfzMiLdtgph9dgmYqA-qqVk6PamrXbQwPGqkAdYID3sErR6doQc8TPsWGj9NbFx5g17SA7rr1Z5Mh7iQgXx2e5hoBpBZEloluuH4JzEXshJfbcqykDRvp46gQRFaFUa8yn~BcKxV1cxqlomAZ1pvkYqOiZcHKfu6Vmg3WY5SQHtnXMvfJriZH2glN26u9O4OhsDmrn-h68wM1tG4mYm-TKQr6oNe344Bd0YnsUKKaPCDOrXyg5kiDdv1BM~1zbx3ghIFiuZFQ7J3zUGWIiDueMFA__")!,
              title: "Official Trailer (Subtitled)",
              daysAgo: "2 days ago"),
        
        Video(videoURL: URL(string: "https://www.youtube.com/watch?v=RlfooqeZcdY")!,
              thumbnailURL: URL(string: "https://s3-alpha-sig.figma.com/img/31db/39f1/09fd6f6fc8d9a78f2f8887de8e10287a?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=MpwnSpeDCrP3njKESpaAR8DbScPeG9wUinTnHDicw71kkhfPE0B4rokA9ORLnP2EY0lJ-RO3mYRW5iO9Rw3M5ud~4uz-jLrXi-U4etzwmgQquMGjHldKrm0y1B74t2Re5qJSwTjMPV~lGuhn2iiWGEJGFA5yIRK5XCqU0TF5ijZlUbZGbh8MVgZ6QgFKKPPUmWhB-hlzip0h9AozvhVFp4CjoWeXp4pgzIgDAGOLFrg~8V5A3qNj44ewnAotvd9dZ0wD7wwgqaQAl0N0rkWe07qFcnZcE0yt3zqJwc9fZgNB-ZLLctddp3NMavZF9W6hsAx8tg~p~nLaxy7sMDrHtg__")!,
              title: "Exclusive Clip (Subtitled)",
              daysAgo: "5 days ago")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Videos")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                NavigationLink(destination: VideosDetail()){
                    HStack {
                            Text("View More")
                            Image(systemName: "chevron.right")
                        }
                    }
                    .foregroundColor(.blue)
                    .navigationBarBackButtonHidden(true)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(videos) { video in
                        VStack(alignment: .leading) {
                            ZStack(alignment: .center) {
                                ImageLoader(url: video.thumbnailURL.absoluteString)
                                    .frame(width: 180, height: 100)
                                    .cornerRadius(8)
                                    .clipped()
                                
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
                            
                            Text(video.title)
                                .font(.body)
                                .foregroundColor(.white)
                                .padding(.top, 5)
                            
                            Text(video.daysAgo)
                                .font(.caption)
                                .foregroundColor(.gray)
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
            AVPlayerViewControllerRepresented(player: AVPlayer(url: video.videoURL))
        }
    }
}

struct ImageLoader: View {
    let url: String
    
    @State private var image: UIImage? = nil
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            Rectangle()
                .foregroundColor(.gray)
                .onAppear {
                    loadImage(from: url)
                }
        }
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let loadedImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = loadedImage
            }
        }
        task.resume()
    }
}

struct AVPlayerViewControllerRepresented: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

#Preview {
    VideosSection()
}
