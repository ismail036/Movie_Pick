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
    @State private var selectedCategories: Set<String> = []
    @State private var visibleCategories: [String] = []
    @State private var remainingCategories: [String] = []
    @State private var discoverShows: [TVShowModel] = []
    @State private var genresInitialized = false

    private let tmdbService = TMDBService()

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
                        CategoryButtonView(
                            title: category,
                            isSelected: selectedCategories.contains(category),
                            onRemove: {
                                selectedCategories.remove(category)
                                updateFilteredShows()
                            }
                        )
                        .onTapGesture {
                            toggleCategorySelection(category)
                            updateFilteredShows()
                        }
                    }
                    
                    NavigationLink(destination: ShowDiscoverDetail()) {
                        CategoryButtonView(title: "More...", isSelected: false)
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
                                genres: show.genres?.prefix(3).map { $0.name } ?? [],
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
            if !genresInitialized {
                tmdbService.initializeShowGenres { result in
                    switch result {
                    case .success:
                        genresInitialized = true
                        updateFilteredShows()
                    case .failure(let error):
                        print("Failed to initialize genres: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    private func toggleCategorySelection(_ category: String) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }

    private func updateFilteredShows() {
        guard genresInitialized else { return }

        if selectedCategories.isEmpty {
            tmdbService.fetchDiscoverShowsWithGenres { result in
                switch result {
                case .success(let shows):
                    DispatchQueue.main.async {
                        self.discoverShows = shows
                    }
                case .failure(let error):
                    print("Failed to fetch all discover shows: \(error.localizedDescription)")
                }
            }
        } else {
            tmdbService.fetchDiscoverShowsByGenres(genres: Array(selectedCategories)) { result in
                switch result {
                case .success(let shows):
                    DispatchQueue.main.async {
                        self.discoverShows = shows
                    }
                case .failure(let error):
                    print("Failed to fetch discover shows by genres: \(error.localizedDescription)")
                }
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
    private static var showGenreDictionary: [String: Int] = [:]

    func initializeShowGenres(completion: @escaping (Result<Void, Error>) -> Void) {
        fetchTVGenres { result in
            switch result {
            case .success(let genres):
                TMDBService.showGenreDictionary = Dictionary(uniqueKeysWithValues: genres.map { ($0.name, $0.id) })
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchDiscoverShowsWithGenres(completion: @escaping (Result<[TVShowModel], Error>) -> Void) {
        fetchDiscoverShows { result in
            switch result {
            case .success(let shows):
                let showsWithGenres = shows.map { show in
                    var updatedShow = show
                    updatedShow.genres = show.genreIds?.compactMap { genreId in
                        // Map genre ID to genre name using the genre dictionary
                        if let genreName = TMDBService.showGenreDictionary.first(where: { $0.value == genreId })?.key {
                            return Genre(id: genreId, name: genreName)
                        }
                        return nil
                    }
                    return updatedShow
                }
                completion(.success(showsWithGenres))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchDiscoverShowsByGenres(genres: [String], completion: @escaping (Result<[TVShowModel], Error>) -> Void) {
        let genreIds = genres.compactMap { TMDBService.showGenreDictionary[$0] }
        fetchDiscoverShowsFilteredByGenreIds(genreIds: genreIds, completion: completion)
    }

    private func fetchDiscoverShowsFilteredByGenreIds(genreIds: [Int], completion: @escaping (Result<[TVShowModel], Error>) -> Void) {
        let genreIdsString = genreIds.map { String($0) }.joined(separator: ",")
        let endpoint = "\(TMDBAPI.baseURL)/discover/tv?with_genres=\(genreIdsString)"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching discover shows by genres: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for discover shows by genres")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(TVShowResponse.self, from: data)
                
                // Map genres for each show
                let showsWithGenres = response.results.map { show in
                    var updatedShow = show
                    updatedShow.genres = show.genreIds?.compactMap { genreId in
                        if let genreName = TMDBService.showGenreDictionary.first(where: { $0.value == genreId })?.key {
                            return Genre(id: genreId, name: genreName)
                        }
                        return nil
                    }
                    return updatedShow
                }
                completion(.success(showsWithGenres))
            } catch {
                print("Error decoding discover shows by genres: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func fetchTVGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/genre/tv/list"
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching TV genres: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for TV genres")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(GenreResponse.self, from: data)
                completion(.success(response.genres))
            } catch {
                print("Error decoding TV genres: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func fetchDiscoverShows(completion: @escaping (Result<[TVShowModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/discover/tv"
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

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
