//
//  ShowDiscoverSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI

struct ShowDiscoverSection: View {
    var text: String
    let categories = ["Drama", "Crime", "Fantasy", "Comedy", "Thriller", "Mystery"]
    @State private var visibleCategories: [String] = []
    @State private var remainingCategories: [String] = []
    @State private var discoverShows: [TVShowModel] = [] // API'den gelen diziler

    var body: some View {
        VStack(alignment: .leading) {
            Text("Discover Shows")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Explore TV Shows and uncover new favorites")
                .font(.system(size: 12))
                .foregroundColor(Color.cyanBlue)

            GeometryReader { geometry in
                HStack {
                    ForEach(visibleCategories, id: \.self) { category in
                        CategoryButtonView(title: category)
                    }

                    if !remainingCategories.isEmpty {
                        NavigationLink(destination: ShowDiscoverDetail()) {
                            CategoryButtonView(title: "More...")
                        }
                    }
                }
                .onAppear {
                    calculateVisibleCategories(for: geometry.size.width)
                }
                .padding(.horizontal, 0)
            }
            .frame(height: 50)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(discoverShows) { show in
                        NavigationLink(destination: ShowDetail(showId: show.id)) {
                            DiscoverShowCardView(
                                showTitle: show.name,
                                firstAirDate: show.firstAirDate ?? "Unknown",
                                rating: Int((show.voteAverage ?? 0) / 2),
                                genres: show.genres?.map { $0.name } ?? [],
                                description: show.overview,
                                posterImageURL: "https://image.tmdb.org/t/p/w500\(show.posterPath ?? "")"
                            )
                            .frame(width: UIScreen.main.bounds.width * 0.95)
                        }
                    }
                }
                .padding(.horizontal, 0)
                .padding(.vertical, 0)
            }
            .padding(.leading, 0)
        }
        .background(Color.mainColor1)
        .onAppear {
            fetchDiscoverShows()
        }
    }

    private func fetchDiscoverShows() {
        TMDBService().fetchDiscoverShows { result in
            switch result {
            case .success(let shows):
                DispatchQueue.main.async {
                    self.discoverShows = shows
                }
            case .failure(let error):
                print("Failed to fetch discover shows: \(error.localizedDescription)")
            }
        }
    }

    private func calculateVisibleCategories(for totalWidth: CGFloat) {
        var currentWidth: CGFloat = 0
        let buttonPadding: CGFloat = 16
        let moreButtonWidth: CGFloat = 80

        visibleCategories = []
        remainingCategories = []

        for category in categories {
            let buttonWidth = category.widthOfString(usingFont: .systemFont(ofSize: 14, weight: .bold)) + buttonPadding * 2

            if currentWidth + buttonWidth + moreButtonWidth <= totalWidth {
                visibleCategories.append(category)
                currentWidth += buttonWidth + buttonPadding
            } else {
                remainingCategories.append(category)
            }
        }
    }
}

#Preview {
    ShowDiscoverSection(text: "Explore TV Shows and uncover new favorites")
}

extension TMDBService {
    func fetchDiscoverShows(completion: @escaping (Result<[TVShowModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/discover/tv"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching discover shows: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for discover shows")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(TVShowResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                print("Error decoding discover shows: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

