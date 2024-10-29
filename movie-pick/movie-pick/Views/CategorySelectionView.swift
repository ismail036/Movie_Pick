//
//  SwiftUIView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI

struct CategorySelectionView: View {
    @Binding var isFirstLaunch: Bool
    @State private var selectedCategories: Set<String> = []
    @State private var popularMovies: [String: MovieModelOnboarding] = [:]
    
    let categories = [
        "Action", "Adventure", "Animation", "Comedy", "Crime",
        "Drama", "Documentary", "Fantasy", "History", "Horror", "Music",
        "Sci-Fi", "Thriller", "Western", "Family", "Romance"
    ]

    var body: some View {
        ZStack {
            Color.mainColor1.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Pick Category")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)

                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            CategoryCardView(
                                title: category,
                                image: popularMovies[category]?.posterPath ?? "",
                                isSelected: selectedCategories.contains(category)
                            ) {
                                toggleCategory(category)
                            }
                            .onAppear {
                                fetchPopularMovie(for: category)
                            }
                        }
                    }
                    .padding()
                }
                
                Button(action: {
                    isFirstLaunch = false
                }) {
                    Text("Done")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedCategories.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }
                .disabled(selectedCategories.isEmpty)
            }
        }
    }

    private func toggleCategory(_ category: String) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }

    private func fetchPopularMovie(for category: String) {
        TMDBService().fetchPopularMovieOnboarding(for: category) { result in
            switch result {
            case .success(let movie):
                DispatchQueue.main.async {
                    popularMovies[category] = movie
                }
            case .failure(let error):
                print("Error fetching movie for \(category): \(error)")
            }
        }
    }
}

struct CategoryCardView: View {
    let title: String
    let image: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        ZStack(alignment: .center) {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(image)")) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .aspectRatio(contentMode: .fill)
            .cornerRadius(12)
            .overlay(
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(8),
                alignment: .center
            )
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .padding(10)
                    .position(x: UIScreen.main.bounds.width / 3 - 30, y: 20)
            }
        }
        .frame(width: UIScreen.main.bounds.width / 3 - 20, height: 150)
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    CategorySelectionView(isFirstLaunch: .constant(true))
}

extension TMDBService {
    func fetchPopularMovieOnboarding(for category: String, completion: @escaping (Result<MovieModelOnboarding, Error>) -> Void) {
        let genreIDs: [String: Int] = [
            "Action": 28, "Adventure": 12, "Animation": 16, "Comedy": 35, "Crime": 80,
            "Drama": 18, "Documentary": 99, "Fantasy": 14, "History": 36, "Horror": 27,
            "Music": 10402, "Sci-Fi": 878, "Thriller": 53, "Western": 37, "Family": 10751, "Romance": 10749
        ]
        
        // Belirtilen kategorinin genre ID'sini al
        guard let genreId = genreIDs[category] else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid category"])))
            return
        }

        let endpoint = "\(TMDBAPI.baseURL)/discover/movie"
        guard var urlComponents = URLComponents(string: endpoint) else {
            print("Invalid URL Components")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "with_genres", value: "\(genreId)"),
            URLQueryItem(name: "sort_by", value: "popularity.desc"),
            URLQueryItem(name: "page", value: "1")
        ]
        
        guard let url = urlComponents.url else {
            print("URL oluşumunda hata")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MovieResponseOnboarding.self, from: data)
                if let firstMovie = response.results.first {
                    completion(.success(firstMovie))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No movie found"])))
                }
            } catch {
                print("Decoding Error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}


struct MovieResponseOnboarding: Codable {
    let results: [MovieModelOnboarding]
}

struct MovieModelOnboarding: Codable {
    let id: Int
    let title: String
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
    }
}
