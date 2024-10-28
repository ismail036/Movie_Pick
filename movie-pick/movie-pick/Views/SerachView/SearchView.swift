//
//  SearchView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 26.10.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [SearchResult] = []
    private let tmdbService = TMDBService()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Search")
                .foregroundStyle(Color.white)
                .font(.title)
                .padding(.horizontal, 10)
            
            Text("Find Movies, TV Shows, and Celebrities")
                .foregroundStyle(Color.white)
                .font(.subheadline)
                .padding(.horizontal, 10)
            
            HStack {
                TextField("Search", text: $searchText, onCommit: {
                    fetchSearchResults()
                })
                .onChange(of: searchText) { _ in
                    fetchSearchResults()
                }
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color.mainColor3)
                .foregroundStyle(Color.cyanBlue)
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                self.searchText = ""
                                self.searchResults = []
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
            }
            .padding(.bottom,15)
            
           if searchText.isEmpty {
                SearchTrendingSection()
            } else {
                SearchResultView(searchResults: searchResults, searchText: searchText)
            }
            
            Spacer()
        }
        .background(Color.mainColor1)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }

    private func fetchSearchResults() {
        tmdbService.fetchSearchResults(query: searchText) { result in
            switch result {
            case .success(let results):
                DispatchQueue.main.async {
                    self.searchResults = results
                }
            case .failure(let error):
                print("Failed to fetch search results: \(error)")
            }
        }
    }
}

struct SearchResultView: View {
    var searchResults: [SearchResult]
    var searchText: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Search Results for '\(searchText)'")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .foregroundColor(.white)
                
                ForEach(searchResults, id: \.id) { result in
                    SearchResultCard(result: result)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                }
            }
        }
    }
}

struct SearchResultCard: View {
    var result: SearchResult
    @State private var movie: MovieModel?
    @State private var errorMessage: String?
    private let tmdbService = TMDBService() // Create an instance of TMDBService

    var body: some View {
        HStack {
            if result.subtitle == "Movie" {
                NavigationLink(destination: {
                    if let movie = movie {
                        MovieDetail(movie: movie)
                    } else if let errorMessage = errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    } else {
                        ProgressView("Loading...")
                    }
                }) {
                    if let imageURL = result.imageURL {
                        WebImage(url: imageURL)
                            .resizable()
                            .frame(width: 80, height: 120)
                            .cornerRadius(8)
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text(result.title)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(result.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(result.year)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .onAppear {
                    tmdbService.fetchMovieById(movieId: result.id) { result in
                        switch result {
                        case .success(let fetchedMovie):
                            self.movie = fetchedMovie
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }
            }else{
                NavigationLink(destination: {
                    if let movie = movie {
                        ShowDetail(showId: result.id)
                    } else if let errorMessage = errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    } else {
                        ProgressView("Loading...")
                    }
                }) {
                    if let imageURL = result.imageURL {
                        WebImage(url: imageURL)
                            .resizable()
                            .frame(width: 80, height: 120)
                            .cornerRadius(8)
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text(result.title)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(result.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(result.year)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .onAppear {
                    tmdbService.fetchMovieById(movieId: result.id) { result in
                        switch result {
                        case .success(let fetchedMovie):
                            self.movie = fetchedMovie
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.mainColor1)
        .cornerRadius(8)
    }
}

#Preview {
    SearchView()
}


extension TMDBService {
    func fetchSearchResults(query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/search/multi"
        guard var urlComponents = URLComponents(string: endpoint) else { return }

        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "api_key", value: TMDBAPI.apiKey),
            URLQueryItem(name: "include_adult", value: "false")
        ]
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching search results: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received for search results")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                let results = searchResponse.results.map { SearchResult(from: $0) }
                completion(.success(results))
            } catch {
                print("Error decoding search results: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

struct SearchResponse: Codable {
    let results: [SearchResultAPI]
}

struct SearchResultAPI: Codable {
    let id: Int
    let mediaType: String
    let title: String?
    let name: String?
    let releaseDate: String?
    let firstAirDate: String?
    let posterPath: String?
    let profilePath: String?
    
    var imageURL: URL? {
        if let posterPath = posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        }
        if let profilePath = profilePath {
            return URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)")
        }
        return nil
    }
}

struct SearchResult {
    let id: Int
    let title: String
    let subtitle: String
    let year: String
    let imageURL: URL?
    
    init(from apiResult: SearchResultAPI) {
        self.id = apiResult.id
        self.title = apiResult.title ?? apiResult.name ?? "Unknown"
        self.subtitle = apiResult.mediaType.capitalized
        self.year = apiResult.releaseDate ?? apiResult.firstAirDate ?? "N/A"
        self.imageURL = apiResult.imageURL
    }
}
