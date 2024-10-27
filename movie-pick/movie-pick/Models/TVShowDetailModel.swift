//
//  TVShowDetailModel.swift
//  movie-pick
//
//  Created by İsmail Parlak on 27.10.2024.
//

import Foundation

struct TVShowDetailModel: Codable, Identifiable {
    let id: Int
    let name: String
    let genres: [TVShowGenre]?
    let voteAverage: Double?
    let voteCount: Int?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let originalLanguage: String?
    let overview: String?
    let images: Images?
    let posterPath: String?
    let backdropPath: String?
    
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
    
    // Formatlanmış alanlar
    var firstAirDateFormatted: String? {
        guard let firstAirDate = firstAirDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: firstAirDate) {
            formatter.dateStyle = .short
            return formatter.string(from: date)
        }
        return firstAirDate
    }
    
    var voteAverageFormatted: String {
        return String(format: "%.1f", voteAverage ?? 0.0)
    }
    
    // Poster ve Backdrop URL'leri
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
    }
    
    // Oy sayısını beş yıldız üzerinden ayarlama
    var rating: Int {
        return Int((voteAverage ?? 0.0) / 2)
    }
    
    // Dizinin türlerini formatlama
    var genreNames: String {
        return genres?.compactMap { $0.name }.joined(separator: ", ") ?? "N/A"
    }
}

// Dizi türleri için model
struct TVShowGenre: Codable, Identifiable {
    let id: Int
    let name: String
}
