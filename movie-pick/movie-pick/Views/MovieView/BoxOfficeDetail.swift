//
//  BoxOfficeDetail.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

func formatCurrencyInMillions(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = "USD"
    formatter.maximumFractionDigits = 0
    
    if value >= 1_000_000 {
        let millionValue = value / 1_000_000
        return (formatter.string(from: NSNumber(value: millionValue)) ?? "$0") + "M"
    } else {
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}


struct BoxOfficeDetail: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var movies: [MovieModel] = []
    private let tmdbService = TMDBService()

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(movies, id: \.id) { movie in
                        NavigationLink(destination:MovieDetail(movie: movie)){
                            BoxOfficeMovieCard(
                                posterImage: movie.posterURL?.absoluteString ?? "",
                                movieTitle: movie.title,
                                totalGross: formatCurrencyInMillions(Double(movie.revenue ?? 0)),
                                weekendGross: formatCurrencyInMillions(Double(movie.weekendGross ?? 0)), // weekendGross formatlama
                                week: movie.weeksInTheater ?? 1
                            )
                        }
                    }
                }
            }
        }
        .background(Color.mainColor1)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("World Box Office")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(Color.mainColor1, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            tmdbService.fetchWeeklyBoxOfficeWithRevenue { result in
                switch result {
                case .success(let movies):
                    self.movies = movies
                case .failure(let error):
                    print("Error fetching weekly box office details: \(error)")
                }
            }
        }
    }
}

#Preview {
    BoxOfficeDetail()
}

