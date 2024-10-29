//
//  EpisodeDetailView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 24.10.2024.
//

import SwiftUI

struct EpisodeDetailView: View {
    
    @State private var showFullText = false
    @State private var episodeDetail: Episode?
    
    let showId: Int
    let seasonNumber: Int
    let episodeNumber: Int
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    ZStack(alignment: .leading) {
                        if let imageUrl = episodeDetail?.stillURL {
                            AsyncImage(url: imageUrl) { image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width)
                                    .clipped()
                            } placeholder: {
                                Color.gray
                            }
                        } else {
                            Color.gray
                                .frame(width: geometry.size.width)
                        }
                        
                        VStack(alignment: .center) {
                            Text(episodeDetail?.name ?? "")
                                .font(.system(size: 24))
                                .bold()
                                .foregroundColor(.white)
                                .padding([.top], 16)
                            Spacer()
                        }
                        .frame(width: geometry.size.width)
                        
                        VStack(alignment: .leading) {
                            Spacer()
                            if let seasonNumber = episodeDetail?.seasonNumber, let episodeNumber = episodeDetail?.episodeNumber {
                                VStack(alignment: .leading) {
                                    Text("S\(seasonNumber) : E\(episodeNumber)")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .padding(.bottom, 8)
                                    
                                    Text(episodeDetail?.name ?? "Episode Title")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.cyanBlue)
                                }
                                .padding(.bottom, 8)
                                .padding(.horizontal, 14)
                            }
                        }
                    }
                    .frame(width: geometry.size.width)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(episodeDetail?.formattedAirDate ?? "Air Date")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            HStack {
                                Image(systemName: "clock")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.gray)
                                Text("\(episodeDetail?.runtime ?? 0) Min")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.top, 8)
                        
                        VStack(alignment: .leading) {
                            Text("Storyline")
                                .foregroundColor(Color.white)
                                .font(.headline)
                            
                            Text(showFullText ? episodeDetail?.overview ?? "" : truncatedDescription() + "... ")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 14))
                            
                            Button(action: {
                                showFullText.toggle()
                            }) {
                                Text(showFullText ? "read less" : "Read More")
                                    .foregroundColor(Color.blue)
                                    .font(.system(size: 14))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .frame(width: geometry.size.width)
            .background(Color.black.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .onAppear {
                fetchEpisodeDetail()
            }
        }
    }
    
    var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "arrow.backward.circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
        }
    }
    
    func truncatedDescription() -> String {
        let limit = 150
        if let description = episodeDetail?.overview, description.count > limit {
            let endIndex = description.index(description.startIndex, offsetBy: limit)
            return String(description[..<endIndex])
        }
        return episodeDetail?.overview ?? ""
    }
    
    private func fetchEpisodeDetail() {
        TMDBService().fetchEpisodeDetail(showId: showId, seasonNumber: seasonNumber, episodeNumber: episodeNumber) { result in
            switch result {
            case .success(let episode):
                DispatchQueue.main.async {
                    self.episodeDetail = episode
                }
            case .failure(let error):
                print("Episode details could not be loaded: \(error.localizedDescription)")
            }
        }
    }
}
// TMDBService içinde fetchEpisodeDetail fonksiyonunu ekle
extension TMDBService {
    func fetchEpisodeDetail(showId: Int, seasonNumber: Int, episodeNumber: Int, completion: @escaping (Result<Episode, Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/tv/\(showId)/season/\(seasonNumber)/episode/\(episodeNumber)"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching episode details: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for episode details")
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON data: \(jsonString)")
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let episodeDetail = try decoder.decode(Episode.self, from: data)
                completion(.success(episodeDetail))
            } catch {
                print("Error decoding episode details: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}


#Preview {
    EpisodeDetailView(showId: 1396, seasonNumber: 1, episodeNumber: 1)
}


struct Episode: Codable, Identifiable {
    let id: Int
    let name: String
    let overview: String
    let episodeNumber: Int
    let seasonNumber: Int
    let airDate: String?
    let runtime: Int?
    let stillPath: String?
    
    var stillURL: URL? {
        guard let path = stillPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w300\(path)")
    }
    
    var formattedAirDate: String? {
        guard let airDate = airDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: airDate) {
            formatter.dateStyle = .short
            return formatter.string(from: date)
        }
        return airDate
    }
    
    var formattedRuntime: String {
        guard let runtime = runtime else { return "N/A" }
        let hours = runtime / 60
        let minutes = runtime % 60
        return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
    }
}

// EpisodeDetail Extension (Eğer ek bilgiler gerekiyorsa)
extension Episode {
    var episodeTitleFormatted: String {
        return "S\(seasonNumber) : E\(episodeNumber) - \(name)"
    }
}
