//
//  Movie.swift
//  movie-pick
//
//  Created by İsmail Parlak on 26.10.2024.
//

import Foundation

struct MovieResponse: Codable {
    let results: [MovieModel]
}

struct MovieModel: Codable, Identifiable {
    let id: Int
    let title: String
    let originalTitle: String?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let runtime: Int?
    let voteAverage: Double?
    let voteCount: Int?
    let genreIds: [Int]?
    let genres: [Genre]?
    let popularity: Double?
    let originalLanguage: String?
    let adult: Bool?
    let budget: Int?
    let revenue: Int?
    let tagline: String?
    let homepage: String?
    let status: String?
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
    }
}

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}