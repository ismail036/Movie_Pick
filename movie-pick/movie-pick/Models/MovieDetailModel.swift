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
}

// Benzer Filmler (More Like This)
struct SimilarMoviesResponse: Codable {
    let results: [SimilarMovie]?
}

struct SimilarMovie: Codable, Identifiable {
    let id: Int
    let title: String
    let posterPath: String?
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}

struct MovieGenre: Codable, Identifiable {
    let id: Int
    let name: String
}
