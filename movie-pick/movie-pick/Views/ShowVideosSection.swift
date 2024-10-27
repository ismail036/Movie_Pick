//
//  ShowVideosSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI

struct ShowVideosSection: View {
    @State private var selectedVideo: TVShowVideo?
    @State private var videos: [TVShowVideo] = []
    
    let showId: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Videos")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
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
        .onAppear {
            TMDBService().fetchShowDetailsWithVideos(showId: showId) { result in
                switch result {
                case .success(let showDetail):
                    DispatchQueue.main.async {
                        self.videos = showDetail.videos?.results ?? []
                    }
                case .failure(let error):
                    print("Failed to fetch show videos: \(error.localizedDescription)")
                }
            }
        }

    }
}

#Preview {
    ShowVideosSection(showId: 1396)
}



extension TMDBService {
    func fetchShowDetailsWithVideos(showId: Int, completion: @escaping (Result<TVShowDetailModel, Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/tv/\(showId)?append_to_response=videos"
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching show details with videos: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for show details with videos")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            // JSON yanıtını ham veri olarak yazdırıyoruz
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON data: \(jsonString)")
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let showDetail = try decoder.decode(TVShowDetailModel.self, from: data)
                completion(.success(showDetail))
            } catch {
                print("Error decoding show details with videos: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
