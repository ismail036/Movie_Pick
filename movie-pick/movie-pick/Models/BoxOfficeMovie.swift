//
//  BoxOfficeMovie..swift
//  movie-pick
//
//  Created by İsmail Parlak on 26.10.2024.
//

import Foundation

struct BoxOfficeMovie: Codable, Identifiable {
    let id = UUID()
    let movieId: Int
    let movieName: String
    let rank: Int
    let weekendGross: Int
    let totalGross: Int
    let weeksInRelease: Int
    var posterImageURL: String = ""

    enum CodingKeys: String, CodingKey {
        case movieId = "movie_id"
        case movieName = "movie_name"
        case rank
        case weekendGross = "weekend_gross"
        case totalGross = "total_gross"
        case weeksInRelease = "weeks_in_release"
    }

    var weekendGrossFormatted: String {
        return formatCurrency(value: weekendGross)
    }

    var totalGrossFormatted: String {
        return formatCurrency(value: totalGross)
    }

    private func formatCurrency(value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}
