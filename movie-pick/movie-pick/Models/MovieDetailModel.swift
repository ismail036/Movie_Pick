//
//  MovieDetailModel.swift
//  movie-pick
//
//  Created by İsmail Parlak on 26.10.2024.
//

import Foundation

struct MovieDetailModel: Codable, Identifiable {
    let id: Int
    let title: String
    let genres: [MovieGenre]?
    let voteAverage: Double?
    let voteCount: Int?
    let runtime: Int?
    let releaseDate: String?
    let originalLanguage: String?
    let budget: Int?
    let revenue: Int?
    let status: String?
    let overview: String?
    let images: Images?
    
    struct Images: Codable {
            let posters: [ImageItem]
            let backdrops: [ImageItem]
        }
    
    struct ImageItem: Codable {
            let filePath: String
            
            var url: String {
                return "https://image.tmdb.org/t/p/w500\(filePath)"
            }
        }
    
    // Eklenen alanlar
    let credits: Credits?
    let videos: VideoResponse?
    let similar: SimilarMoviesResponse?
    
    // Formatlanmış alanlar
    var releaseDateFormatted: String? {
        guard let releaseDate = releaseDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: releaseDate) {
            formatter.dateStyle = .short
            return formatter.string(from: date)
        }
        return releaseDate
    }
    
    var budgetFormatted: String {
        guard let budget = budget else { return "N/A" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencySymbol = "$"
        return formatter.string(from: NSNumber(value: budget)) ?? "N/A"
    }
    
    var revenueFormatted: String {
        guard let revenue = revenue else { return "N/A" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencySymbol = "$"
        return formatter.string(from: NSNumber(value: revenue)) ?? "N/A"
    }
}

// Credits (Oyuncular ve Yapım Ekibi)
struct Credits: Codable {
    let cast: [MovieCastMember]?
    let crew: [MovieCrewMember]?
}

struct MovieCastMember: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String?
    let profilePath: String?
    
    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }
}

struct MovieCrewMember: Codable, Identifiable {
    let id: Int
    let name: String
    let job: String?
    let profilePath: String?
    
    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }
}

// Videolar
struct VideoResponse: Codable {
    let results: [MovieVideo]?
}

struct MovieVideo: Codable, Identifiable {
    let id: String
    let key: String
    let name: String?
    let site: String?
    let type: String?
    
    var videoURL: URL? {
        if site == "YouTube" {
            return URL(string: "https://www.youtube.com/watch?v=\(key)")
        } else {
            return nil
        }
    }

    var thumbnailURL: URL? {
        if site == "YouTube" {
            return URL(string: "https://img.youtube.com/vi/\(key)/hqdefault.jpg")
        } else {
            return nil
        }
    }
}


//
//  SimilarMovie.swift
//  movie-pick
//
//  Created by İsmail Parlak on 26.10.2024.
//

import Foundation

struct SimilarMoviesResponse: Codable {
    let results: [SimilarMovie]
}

struct SimilarMovie: Codable, Identifiable {
    let id: Int
    let title: String
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let runtime: Int?
    let voteAverage: Double?
    let voteCount: Int?
    let genreIds: [Int]?
    var genres: [String]?
    let popularity: Double?
    let originalLanguage: String?
    let adult: Bool?
    let budget: Int?
    let revenue: Int?
    let tagline: String?
    let homepage: String?
    let status: String?
    let images: Images?
    
    struct Images: Codable {
            let posters: [ImageItem]
            let backdrops: [ImageItem]
        }
    
    struct ImageItem: Codable {
            let filePath: String
            
            var url: String {
                return "https://image.tmdb.org/t/p/w500\(filePath)"
            }
        }
    
    // URL'ler
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
    }
    
    // Formatlanmış Alanlar
    var releaseYear: String {
        return String(releaseDate?.prefix(4) ?? "N/A")
    }
    
    var voteAverageFormatted: String {
        return String(format: "%.1f", voteAverage ?? 0.0)
    }
    
    var popularityFormatted: String {
        guard let popularity = popularity else { return "N/A" }
        return String(format: "%.1f", popularity)
    }
    
    var rating: Int {
            return Int((voteAverage ?? 0.0) / 2) // 10 üzerinden olan oylamayı 5 üzerinden ayarlama
        }
    
    mutating func setGenres(from genreList: [Genre]) {
            self.genres = genreIds?.compactMap { id in
                genreList.first { $0.id == id }?.name
            }
        }
}


struct MovieGenre: Codable, Identifiable {
    let id: Int
    let name: String
}
