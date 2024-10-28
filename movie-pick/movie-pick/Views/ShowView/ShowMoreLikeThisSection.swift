//
//  ShowMoreLikeThisSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI

struct ShowMoreLikeThisSection: View {
    let showId: Int
    @State private var similarShows: [SimilarShow] = [] // Benzer dizileri saklayacağımız dizi

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("More Like This")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Spacer()

                NavigationLink(destination: ShowMoreLikeThisDetail(showId: showId)) {
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
                HStack(spacing: 10) {
                    ForEach(similarShows) { show in
                        VerticalShowCard(
                            selectedDestination: .showDetail,
                            showId: show.id
                        )
                    }
                }
                .padding(.horizontal, 0)
                .padding(.vertical, 0)
            }
        }
        .background(Color.black)
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: loadSimilarShows) // Görünüm oluşunca benzer dizileri yükler
    }

    private func loadSimilarShows() {
        TMDBService().fetchShowDetailsWithSimilarShows(showId: showId) { result in
            switch result {
            case .success(let showDetail):
                DispatchQueue.main.async {
                    self.similarShows = showDetail.similar?.results ?? []
                    print(self.similarShows)
                }
            case .failure(let error):
                print("Failed to fetch similar shows: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ShowMoreLikeThisSection(showId: 1396) // Breaking Bad ID'si
}


extension TMDBService {
    func fetchShowDetailsWithSimilarShows(showId: Int, completion: @escaping (Result<TVShowDetailModel, Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/tv/\(showId)?append_to_response=similar"
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching show details with similar shows: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for show details with similar shows")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON data: \(jsonString)")
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let showDetail = try decoder.decode(TVShowDetailModel.self, from: data)
                completion(.success(showDetail))
            } catch {
                print("Error decoding show details with similar shows: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
