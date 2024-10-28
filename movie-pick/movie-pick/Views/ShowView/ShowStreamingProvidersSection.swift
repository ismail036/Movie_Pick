//
//  ShowStreamingProvidersSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI

struct ShowStreamingProvidersSection: View {
    @State private var shows: [TVShowModel] = []
    @State private var selectedProvider: (name: String, id: Int)? = nil
    private let tmdbService = TMDBService()
    
    let providers = [
        ("Netflix", 8, Color.red),
        ("Disney+", 337, Color.blue),
        ("Apple TV+", 350, Color.black),
        ("Hulu", 15, Color.green),
        ("Amazon Prime", 9, Color.blue.opacity(0.7)),
        ("Max", 384, Color.gray),
        ("Paramount+", 531, Color.blue),
        ("Crunchyroll", 283, Color.orange),
        ("Peacock Premium", 386, Color.blue.opacity(0.5))
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Streaming Providers")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Find Shows from your favorite streaming services")
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
                            .background(provider.2)
                            .cornerRadius(20)
                            .onTapGesture {
                                selectedProvider = (provider.0, provider.1)
                                fetchShows(forProviderId: provider.1)
                            }
                    }
                }
                .padding(.top, 10)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(shows, id: \.id) { show in
                        VerticalShowCard(
                            selectedDestination: .showDetail,
                            showId: show.id
                        )
                    }
                }
            }
        }
        .background(Color.black)
        .onAppear {
            fetchShows(forProviderId: nil)
        }
    }
    
    func fetchShows(forProviderId providerId: Int?) {
        if let providerId = providerId {
            print("Fetching shows for provider ID: \(providerId)")
            tmdbService.fetchShowsByProvider(providerId: providerId) { result in
                switch result {
                case .success(let fetchedShows):
                    shows = Array(fetchedShows.prefix(10))
                case .failure(let error):
                    print("Error fetching shows for provider ID \(providerId): \(error)")
                }
            }
        } else {
            print("Fetching random shows from all providers")
            tmdbService.fetchShowsByProvider(providerId: 8) { result in
                switch result {
                case .success(let fetchedShows):
                    shows = Array(fetchedShows.prefix(10))
                case .failure(let error):
                    print("Error fetching shows for provider ID \(providerId): \(error)")
                }
            }
        }
    }
}

#Preview {
    ShowStreamingProvidersSection()
}

extension TMDBService {
    func fetchShowsByProvider(providerId: Int, completion: @escaping (Result<[TVShowModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/discover/tv"
        guard var urlComponents = URLComponents(string: endpoint) else { return }

        urlComponents.queryItems = [
            URLQueryItem(name: "with_watch_providers", value: "\(providerId)"),
            URLQueryItem(name: "watch_region", value: "US"),
            URLQueryItem(name: "api_key", value: TMDBAPI.apiKey)
        ]
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching shows by provider: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for shows by provider")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(TVShowResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                print("Error decoding shows by provider: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
