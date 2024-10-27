//
//  TVShowDetailModel.swift
//  movie-pick
//
//  Created by İsmail Parlak on 27.10.2024.
//

// TVShowDetailModel.swift
import Foundation

struct TVShowDetailModel: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String?
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
    let seasons: [TVSeason]?
    let credits: TVCredits?  // Cast ve Crew bilgilerini tutan alan
    let videos: TVShowVideos?
    let similar: SimilarShowResponse?
    
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
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
    }
    
    var rating: Int {
        return Int((voteAverage ?? 0.0) / 2)
    }
    
    var genreNames: String {
        return genres?.compactMap { $0.name }.joined(separator: ", ") ?? "N/A"
    }
}

// Dizi türü için model
struct TVShowGenre: Codable, Identifiable {
    let id: Int
    let name: String
}

// Dizi sezon bilgisi için model
struct TVSeason: Codable, Identifiable {
    let id: Int
    let seasonNumber: Int
    let name: String
    let episodeCount: Int
    let airDate: String?
    let posterPath: String?
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
    }
    
    var formattedAirDate: String? {
        guard let airDate = airDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: airDate) {
            formatter.dateStyle = .short
            return formatter.string(from: date)
        }
        return airDate
    }
}

// Sezon detayları için model
struct TVSeasonDetail: Codable {
    let episodes: [Episode]
}

// Cast ve Crew bilgilerini tutan model
struct TVCredits: Codable {
    let cast: [TVCastMember]
    let crew: [TVCrewMember]
}

// Cast üyesi için model
struct TVCastMember: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String?
    let profilePath: String?
    
    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
    }
}

// Crew üyesi için model
struct TVCrewMember: Codable, Identifiable {
    let id: Int
    let name: String
    let job: String?
    let profilePath: String?
    
    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
    }
}

struct TVShowVideo: Codable, Identifiable {
    let id: String
    let key: String
    let name: String?
    let site: String?
    let type: String?
    
    var videoURL: URL? {
        guard site == "YouTube" else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
    
    var thumbnailURL: URL? {
        guard site == "YouTube" else { return nil }
        return URL(string: "https://img.youtube.com/vi/\(key)/hqdefault.jpg")
    }
}

// TVShowVideos Model to hold an array of videos
struct TVShowVideos: Codable {
    let results: [TVShowVideo]
}

struct SimilarShowResponse: Codable {
    let results: [SimilarShow]
}

struct SimilarShow: Codable, Identifiable {
    let id: Int
    let name: String
    let posterPath: String?
    var genreIds: [Int]?
    var genres: [String]?

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    mutating func setGenres(from genreList: [Genre]) {
        self.genres = genreList.compactMap { genre in
            genreList.contains(where: { $0.id == genre.id }) ? genre.name : nil
        }
    }
}


