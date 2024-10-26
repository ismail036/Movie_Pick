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
        let endpoint = "\(TMDBAPI.baseURL)/movie/\(movieId)?append_to_response=credits,videos,similar"
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
}
