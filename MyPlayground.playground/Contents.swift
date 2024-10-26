import UIKit

let service = TMDBService()

// Popüler filmleri çekme test
service.fetchPopularMovies { result in
    switch result {
    case .success(let movies):
        print("Popular Movies:", movies)
    case .failure(let error):
        print("Error fetching popular movies:", error.localizedDescription)
    }
}
