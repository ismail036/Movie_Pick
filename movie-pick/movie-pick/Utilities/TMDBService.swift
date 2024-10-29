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
    
    
    func fetchWeeklyBoxOffice(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/movie/now_playing"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching weekly box office movies: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for weekly box office movies")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                print("Error decoding weekly box office movies: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }


    func fetchWeeklyBoxOfficeWithRevenue(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        fetchWeeklyBoxOffice { result in
            switch result {
            case .success(let movies):
                var moviesWithRevenue: [MovieModel] = []
                let dispatchGroup = DispatchGroup()
                
                for movie in movies {
                    dispatchGroup.enter()
                    self.fetchMovieById(movieId: movie.id) { result in
                        switch result {
                        case .success(let detailedMovie):
                            moviesWithRevenue.append(detailedMovie)
                        case .failure(let error):
                            print("Error fetching revenue for movie \(movie.id): \(error)")
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(.success(moviesWithRevenue))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    
    func fetchPopularPeople(completion: @escaping (Result<[PersonModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/person/popular"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching popular people: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for popular people")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(PeopleResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                print("Error decoding popular people: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func fetchStreamingProviders(movieId: Int, completion: @escaping (Result<[ProviderModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/movie/\(movieId)/watch/providers"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching streaming providers: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for streaming providers")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            print("Raw JSON data: \(String(data: data, encoding: .utf8) ?? "No data")")

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ProviderResponse.self, from: data)
                
                // Sağlayıcıları "US" ülke kodu ile alıp `flatrate`, `buy`, `rent` seçeneklerini kontrol ediyoruz
                if let usProviders = response.results["US"] {
                    if let flatrate = usProviders.flatrate {
                        completion(.success(flatrate))
                    } else if let buy = usProviders.buy {
                        completion(.success(buy))
                    } else if let rent = usProviders.rent {
                        completion(.success(rent))
                    } else {
                        print("No providers found for US under flatrate, buy, or rent")
                        completion(.success([]))
                    }
                } else {
                    print("No providers found for US")
                    completion(.success([]))
                }
                
            } catch {
                print("Error decoding streaming providers: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func fetchMoviesByProvider(providerId: Int, completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/discover/movie"
        guard var urlComponents = URLComponents(string: endpoint) else { return }

        urlComponents.queryItems = [
            URLQueryItem(name: "with_watch_providers", value: "\(providerId)"),
            URLQueryItem(name: "watch_region", value: "US"), // ABD bölgesi
            URLQueryItem(name: "api_key", value: TMDBAPI.apiKey)
        ]
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching movies by provider: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for movies by provider")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                print("Error decoding movies by provider: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func fetchNowPlayingMovies(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/movie/now_playing"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching now playing movies: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for now playing movies")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                print("Error decoding now playing movies: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchAiringTodayShows(completion: @escaping (Result<[TVShowModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/tv/airing_today"
        guard var urlComponents = URLComponents(string: endpoint) else { return }

        // "region" parametresini "us" olarak ekleyelim
        urlComponents.queryItems = [
            URLQueryItem(name: "region", value: "US")
        ]
        
        guard let url = urlComponents.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching airing today shows: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for airing today shows")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(TVShowResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                print("Error decoding airing today shows: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }




    func fetchTVShowDetails(showId: Int, completion: @escaping (Result<TVShowDetailModel, Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/tv/\(showId)?append_to_response=images"
        guard var urlComponents = URLComponents(string: endpoint) else { return }

        // "region" parametresini "us" olarak ekleyelim
        urlComponents.queryItems = [
            URLQueryItem(name: "region", value: "US")
        ]
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching TV show details: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for TV show details")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let showDetails = try decoder.decode(TVShowDetailModel.self, from: data)
                print("Fetched images for show ID \(showId):", showDetails.images ?? "No images found")
                completion(.success(showDetails))
            } catch {
                print("Error decoding TV show details: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    
    
    
    func fetchShowById(showId: Int, completion: @escaping (Result<TVShowModel, Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/tv/\(showId)"
        guard var urlComponents = URLComponents(string: endpoint) else { return }

        urlComponents.queryItems = [
            URLQueryItem(name: "region", value: "US")
        ]
        
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching show by ID: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for show by ID")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let show = try decoder.decode(TVShowModel.self, from: data)
                completion(.success(show))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    
    func fetchShowSeasons(showId: Int, completion: @escaping (Result<[TVSeason], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/tv/\(showId)?append_to_response=seasons"
        guard var urlComponents = URLComponents(string: endpoint) else { return }

        // "region" parametresini "us" olarak ekleyelim
        urlComponents.queryItems = [
            URLQueryItem(name: "region", value: "US")
        ]
        
        guard let url = urlComponents.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching seasons: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for seasons")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let showDetail = try decoder.decode(TVShowDetailModel.self, from: data)
                completion(.success(showDetail.seasons ?? []))
            } catch {
                print("Error decoding seasons: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    

    func fetchEpisodes(showId: Int, seasonNumber: Int, completion: @escaping (Result<[Episode], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/tv/\(showId)/season/\(seasonNumber)"
        guard var urlComponents = URLComponents(string: endpoint) else { return }

        // "region" parametresini "us" olarak ekleyelim
        urlComponents.queryItems = [
            URLQueryItem(name: "region", value: "US")
        ]
        
        guard let url = urlComponents.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching episodes: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for episodes")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let seasonDetail = try decoder.decode(TVSeasonDetail.self, from: data)
                completion(.success(seasonDetail.episodes))
            } catch {
                print("Error decoding episodes: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func fetchAllShowReviews(showId: Int, completion: @escaping (Result<[FetchedReview], Error>) -> Void) {
        var allReviews: [FetchedReview] = []
        var currentPage = 1

        func fetchPage() {
            let endpoint = "\(TMDBAPI.baseURL)/tv/\(showId)/reviews?page=\(currentPage)"
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
                        fetchPage()
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
    
    
    func fetchPopularMoviesByGenre(genreId: Int, completion: @escaping (Result<MovieModel, Error>) -> Void) {
        let endpoint = "https://api.themoviedb.org/3/discover/movie"
        guard var urlComponents = URLComponents(string: endpoint) else {
            print("Invalid URL Components")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: TMDBAPI.apiKey),
            URLQueryItem(name: "with_genres", value: "\(genreId)"),
            URLQueryItem(name: "sort_by", value: "popularity.desc"),
            URLQueryItem(name: "page", value: "1")
        ]
        
        guard let url = urlComponents.url else {
            print("URL oluşumunda hata")
            return
        }
        
        print("Request URL: \(url)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
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

struct PeopleResponse: Codable {
    let results: [PersonModel]
}

struct PersonModel: Codable, Identifiable {
    let id: Int
    let name: String
    let profilePath: String?
    
    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
    }
}


struct ProviderResponse: Codable {
    let results: [String: CountryProviders]
}

struct CountryProviders: Codable {
    let flatrate: [ProviderModel]?
    let buy: [ProviderModel]?
    let rent: [ProviderModel]?
}

struct ProviderModel: Codable, Identifiable {
    let id: Int
    let providerName: String
    let logoPath: String?

    var logoURL: URL? {
        guard let path = logoPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
    }
}
