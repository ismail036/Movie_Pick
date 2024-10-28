//
//  ShowTopRatedSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI

struct ShowTopRatedSection: View {
    var title1: String
    var title2: String
    @State private var topRatedShows: [TVShowModel] = []
    private let tmdbService = TMDBService()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title1)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title2)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(topRatedShows, id: \.id) { show in
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
            fetchTopRatedShows()
        }
    }
    
    private func fetchTopRatedShows() {
        tmdbService.fetchTopRatedShows { result in
            switch result {
            case .success(let shows):
                DispatchQueue.main.async {
                    self.topRatedShows = Array(shows.prefix(10))
                }
            case .failure(let error):
                print("Error fetching top-rated shows: \(error)")
            }
        }
    }
}

#Preview {
    ShowTopRatedSection(title1: "Top Rated", title2: "The Best-Ranked Series Out There")
}

extension TMDBService {
    func fetchTopRatedShows(completion: @escaping (Result<[TVShowModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/tv/top_rated"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching top-rated shows: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for top-rated shows")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(TVShowResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                print("Error decoding top-rated shows: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
