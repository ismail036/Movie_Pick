//
//  TVShowModel.swift
//  movie-pick
//
//  Created by İsmail Parlak on 27.10.2024.
//

import Foundation

struct TVShowResponse: Codable {
    let results: [TVShowModel]
    let totalPages: Int?
}

struct TVShowModel: Codable, Identifiable {
    let id: Int
    let name: String
    let originalName: String?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let firstAirDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    let genreIds: [Int]?
    let genres: [Genre]?
    let popularity: Double?
    let originalLanguage: String?
    let episodeRunTime: [Int]?
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
    }
    
    // Yayın yılı
    var releaseYear: String {
        return String(firstAirDate?.prefix(4) ?? "N/A")
    }
    
    // Oylama puanını formatlama
    var voteAverageFormatted: String {
        return String(format: "%.1f", voteAverage ?? 0.0)
    }
    
    // Popülerlik puanını formatlama
    var popularityFormatted: String {
        guard let popularity = popularity else { return "N/A" }
        return String(format: "%.1f", popularity)
    }
    
    // Oy sayısını beş yıldız üzerinden ayarlama
    var rating: Int {
        return Int((voteAverage ?? 0.0) / 2)
    }
}
