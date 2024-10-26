//
//  TMDBService,.swift
//  movie-pick
//
//  Created by İsmail Parlak on 26.10.2024.
//

import Foundation

struct TMDBAPI {
    static let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhY2Q2MzUxNmZkYTRlYjEzMDZhZmE0NGM0MTVjZTIyMyIsIm5iZiI6MTcyOTkzOTE4MS40Nzk4MjksInN1YiI6IjVhOGM4MmJkYzNhMzY4NjIwNzA5M2Q3OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.JUItyR7n4_y3r7JKxZiKNQgQyIxMtNrWS4ipzyJ8mvA" // Burada Bearer Token'ı kullanıyoruz
    static let baseURL = "https://api.themoviedb.org/3"
}


class TMDBService {
    func fetchPopularMovies(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        print("Fetching popular movies...")
        let endpoint = "\(TMDBAPI.baseURL)/movie/popular"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MovieResponse.self, from: data)
                print("Movies fetched successfully")
                completion(.success(response.results))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }


    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetailModel, Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/movie/\(movieId)?append_to_response=credits,videos,similar,images"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movieDetails = try decoder.decode(MovieDetailModel.self, from: data)
                print("Movie details fetched successfully for ID \(movieId)")
                completion(.success(movieDetails))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }


    func fetchTopTwoMovies(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/movie/popular"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MovieResponse.self, from: data)
                let currentTopTwoMovies = Array(response.results.prefix(2))
                print("Top two movies fetched successfully")
                completion(.success(currentTopTwoMovies))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchMovieGenres(movieId: Int, completion: @escaping (Result<[String], Error>) -> Void) {
            fetchMovieDetails(movieId: movieId) { result in
                switch result {
                case .success(let movieDetail):
                    // Genres listesini isim olarak döndürüyoruz
                    let genres = movieDetail.genres?.map { $0.name } ?? []
                    completion(.success(genres))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    
    func fetchGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/genre/movie/list"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching genres: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for genres")
                return
            }

            do {
                let decoder = JSONDecoder()
                let genreResponse = try decoder.decode(GenreResponse.self, from: data)
                completion(.success(genreResponse.genres))
            } catch {
                print("Error decoding genres: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchAllMovieReviews(movieId: Int, completion: @escaping (Result<[FetchedReview], Error>) -> Void) {
        var allReviews: [FetchedReview] = []
        var currentPage = 1
        
        func fetchPage() {
            let endpoint = "\(TMDBAPI.baseURL)/movie/\(movieId)/reviews?page=\(currentPage)"
            guard let url = URL(string: endpoint) else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error fetching reviews: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    print("No data received for reviews")
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let reviewResponse = try decoder.decode(ReviewResponse.self, from: data)
                    allReviews.append(contentsOf: reviewResponse.results)
                    
                    if reviewResponse.results.isEmpty || currentPage >= (reviewResponse.totalPages ?? 1) {
                        completion(.success(allReviews))
                    } else {
                        currentPage += 1
                        fetchPage() // Bir sonraki sayfayı çek
                    }
                } catch {
                    print("Error decoding reviews: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        
        fetchPage()
    }
    
    
    func fetchTrendingMovies(timeWindow: String, completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/trending/movie/\(timeWindow)"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching trending movies: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for trending movies")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                print("Error decoding trending movies: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    
    func fetchMovieById(movieId: Int, completion: @escaping (Result<MovieModel, Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/movie/\(movieId)"
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching movie by ID: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for movie by ID")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movie = try decoder.decode(MovieModel.self, from: data)
                completion(.success(movie))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    

    
    func fetchDiscoverMovies(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/discover/movie"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching discover movies: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for discover movies")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MovieResponse.self, from: data)
                let discoverMovies = Array(response.results.prefix(2)) // Sadece 2 film al
                completion(.success(discoverMovies))
            } catch {
                print("Error decoding discover movies: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchAllDiscoverMovies(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/discover/movie"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching discover movies: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for discover movies")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MovieResponse.self, from: data)
                let discoverMovies = Array(response.results) // Sadece 2 film al
                completion(.success(discoverMovies))
            } catch {
                print("Error decoding discover movies: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func fetchComingSoonMovies(startDate: String, endDate: String, completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/discover/movie?primary_release_date.gte=\(startDate)&primary_release_date.lte=\(endDate)"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching coming soon movies: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for coming soon movies")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                print("Error decoding coming soon movies: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

}

struct GenreResponse: Codable {
    let genres: [Genre]
}

struct ReviewResponse: Codable {
    let results: [FetchedReview]
    let totalPages: Int?
}

struct FetchedReview: Codable, Identifiable {
    let id: String
    let author: String
    let authorDetails: AuthorDetails
    let content: String
    let createdAt: String

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: createdAt) {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
        return createdAt
    }

    var profileImageURL: URL? {
        guard let path = authorDetails.avatarPath else { return nil }
        let fixedPath = path.hasPrefix("/https") ? String(path.dropFirst()) : path
        return URL(string: "https://image.tmdb.org/t/p/w185\(fixedPath)")
    }

    var rating: Int {
        return Int(authorDetails.rating ?? 0)
    }
}

struct AuthorDetails: Codable {
    let avatarPath: String?
    let rating: Double?
}

