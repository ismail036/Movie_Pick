//
//  OnAirSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI

struct OnAirSection: View {
    var title1: String
    var title2: String
    @State private var onAirShows: [TVShowModel] = []
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
                    ForEach(onAirShows, id: \.id) { show in
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
            fetchOnAirShows()
        }
    }
    
    private func fetchOnAirShows() {
        tmdbService.fetchLast7DaysShows { result in
            switch result {
            case .success(let shows):
                DispatchQueue.main.async {
                    self.onAirShows = Array(shows.prefix(10))
                }
            case .failure(let error):
                print("Error fetching on-air shows for last 7 days: \(error)")
            }
        }
    }
}

#Preview {
    OnAirSection(title1: "On Air", title2: "TV Shows that aired in the last 7 days")
}

extension TMDBService {
    func fetchLast7DaysShows(completion: @escaping (Result<[TVShowModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/discover/tv"
        guard var urlComponents = URLComponents(string: endpoint) else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentDate = Date()
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: currentDate) ?? currentDate
        let startDateString = dateFormatter.string(from: sevenDaysAgo)
        let endDateString = dateFormatter.string(from: currentDate)

        urlComponents.queryItems = [
            URLQueryItem(name: "first_air_date.gte", value: startDateString),
            URLQueryItem(name: "first_air_date.lte", value: endDateString),
            URLQueryItem(name: "api_key", value: TMDBAPI.apiKey)
        ]
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching shows for the last 7 days: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for shows in last 7 days")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(TVShowResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                print("Error decoding shows for the last 7 days: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
