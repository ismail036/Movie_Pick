//
//  DiscoverSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct DiscoverSection: View {
    var text: String
    let categories = ["Action", "Adventure", "Animation", "Comedy", "Horror", "Sci-Fi"]
    @State private var selectedCategories: Set<String> = []
    @State private var visibleCategories: [String] = []
    @State private var remainingCategories: [String] = []
    @State private var discoverMovies: [MovieModel] = []
    @State private var genresInitialized = false

    private let tmdbService = TMDBService()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Discover")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Explore Movies and uncover new favorites")
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
                                updateFilteredMovies()
                            }
                        )
                        .onTapGesture {
                            toggleCategorySelection(category)
                            updateFilteredMovies()
                        }
                    }
                    
                    NavigationLink(destination: DiscoverDetail()) {
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
                    ForEach(discoverMovies) { movie in
                        NavigationLink(destination: MovieDetail(movie: movie)) {
                            DiscoverMovieCardView(
                                movieTitle: movie.title,
                                releaseDate: movie.releaseDate ?? "Unknown",
                                rating: Int((movie.voteAverage ?? 0) / 2),
                                genres: movie.genres?.prefix(3).map { $0.name } ?? [],
                                description: movie.overview,
                                posterImageURL: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")"
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
                tmdbService.initializeGenres { result in
                    switch result {
                    case .success:
                        genresInitialized = true
                        updateFilteredMovies()
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

    private func updateFilteredMovies() {
        guard genresInitialized else { return }

        if selectedCategories.isEmpty {
            tmdbService.fetchDiscoverMoviesWithGenres { result in
                switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        self.discoverMovies = movies
                    }
                case .failure(let error):
                    print("Failed to fetch all discover movies: \(error.localizedDescription)")
                }
            }
        } else {
            tmdbService.fetchDiscoverMoviesByGenres(genres: Array(selectedCategories)) { result in
                switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        self.discoverMovies = movies
                    }
                case .failure(let error):
                    print("Failed to fetch discover movies by genres: \(error.localizedDescription)")
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


extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes).width
    }
}


#Preview {
    DiscoverSection(text: "Explore Movies and uncover new favorites")
}



extension TMDBService {
    private static var genreDictionary: [String: Int] = [:]

    func initializeGenres(completion: @escaping (Result<Void, Error>) -> Void) {
        fetchGenres { result in
            switch result {
            case .success(let genres):
                TMDBService.genreDictionary = Dictionary(uniqueKeysWithValues: genres.map { ($0.name, $0.id) })
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchDiscoverMoviesWithGenres(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        fetchDiscoverMovies { result in
            switch result {
            case .success(let movies):
                let moviesWithGenres = movies.map { movie in
                    var updatedMovie = movie
                    updatedMovie.genres = movie.genreIds?.compactMap { genreId in
                        // Genre id'yi dictionary'den bularak genre adını alıyoruz
                        if let genreName = TMDBService.genreDictionary.first(where: { $0.value == genreId })?.key {
                            return Genre(id: genreId, name: genreName)
                        }
                        return nil
                    }
                    return updatedMovie
                }
                completion(.success(moviesWithGenres))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchDiscoverMoviesByGenres(genres: [String], completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let genreIds = genres.compactMap { TMDBService.genreDictionary[$0] }
        fetchDiscoverMoviesFilteredByGenreIds(genreIds: genreIds, completion: completion)
    }

    private func fetchDiscoverMoviesFilteredByGenreIds(genreIds: [Int], completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let genreIdsString = genreIds.map { String($0) }.joined(separator: ",")
        let endpoint = "\(TMDBAPI.baseURL)/discover/movie?with_genres=\(genreIdsString)"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching discover movies by genres: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for discover movies by genres")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MovieResponse.self, from: data)
                
                // Her film için genre adlarını güncelle
                let moviesWithGenres = response.results.map { movie in
                    var updatedMovie = movie
                    updatedMovie.genres = movie.genreIds?.compactMap { genreId in
                        if let genreName = TMDBService.genreDictionary.first(where: { $0.value == genreId })?.key {
                            return Genre(id: genreId, name: genreName)
                        }
                        return nil
                    }
                    return updatedMovie
                }
                completion(.success(moviesWithGenres))
            } catch {
                print("Error decoding discover movies by genres: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
