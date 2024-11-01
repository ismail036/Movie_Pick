//
//  ShowStreamingProvidersSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI

struct ShowStreamingProvidersSection: View {
    @State private var shows: [TVShowModel] = []
    @State private var selectedProviders: [(name: String, id: Int)] = []
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
                        HStack {
                            Text(provider.0)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                            
                            if selectedProviders.contains(where: { $0.name == provider.0 }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white)
                                    .padding(.leading, 4)
                                    .onTapGesture {
                                        removeProvider(provider)
                                    }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            provider.2
                                .opacity(selectedProviders.contains(where: { $0.name == provider.0 }) ? 1.0 : 0.6)
                        )
                        .cornerRadius(20)
                        .onTapGesture {
                            toggleProviderSelection(provider)
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
        .background(Color.mainColor1)
        .onAppear {
            fetchShows()
        }
    }
    
    private func toggleProviderSelection(_ provider: (name: String, id: Int, color: Color)) {
        if let index = selectedProviders.firstIndex(where: { $0.id == provider.id }) {
            selectedProviders.remove(at: index)
        } else {
            selectedProviders.append((provider.0, provider.1))
        }
        fetchShows()
    }
    
    private func removeProvider(_ provider: (name: String, id: Int, color: Color)) {
        selectedProviders.removeAll { $0.name == provider.0 }
        fetchShows()
    }
    
    private func fetchShows() {
        let providerIds = selectedProviders.map { $0.id }
        if providerIds.isEmpty {
            // Varsayılan olarak Netflix içerikleri çek
            tmdbService.fetchShowsByProvider(providerId: 8) { result in
                switch result {
                case .success(let fetchedShows):
                    shows = Array(fetchedShows.prefix(10))
                case .failure(let error):
                    print("Error fetching shows: \(error)")
                }
            }
        } else {
            tmdbService.fetchShowsByProviders(providerIds: providerIds) { result in
                switch result {
                case .success(let fetchedShows):
                    shows = Array(fetchedShows.prefix(10))
                case .failure(let error):
                    print("Error fetching shows by providers: \(error)")
                }
            }
        }
    }
}

#Preview {
    ShowStreamingProvidersSection()
}

extension TMDBService {
    func fetchShowsByProviders(providerIds: [Int], completion: @escaping (Result<[TVShowModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/discover/tv"
        guard var urlComponents = URLComponents(string: endpoint) else { return }
        
        let providerIdsString = providerIds.map { String($0) }.joined(separator: "|")
        
        urlComponents.queryItems = [
            URLQueryItem(name: "with_watch_providers", value: providerIdsString),
            URLQueryItem(name: "watch_region", value: "US")
        ]
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching shows by providers: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received for shows by providers")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(TVShowResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                print("Error decoding shows by providers: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
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
