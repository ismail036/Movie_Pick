//
//  BoxOfficeSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct BoxOfficeView: View {
    @State private var movies: [MovieModel] = []
    private let tmdbService = TMDBService()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("World Box Office")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                NavigationLink(destination: BoxOfficeDetail()) {
                    Text("View More")
                        .foregroundColor(.blue)
                }
            }
            
            Text(getPreviousWeekendDateRange())
                .font(.caption)
                .foregroundColor(.white)
                .padding(.bottom, 10)

            ForEach(movies.prefix(5), id: \.id) { movie in
                NavigationLink(destination: MovieDetail(movie: movie)) {
                    HStack {
                        Text("\(movies.firstIndex(where: { $0.id == movie.id })! + 1)")
                            .font(.system(size: 28))
                            .fontWeight(.bold)
                            .foregroundColor(Color.cyanBlue)
                        
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color("MainColor2Primary"), Color("MainColor2Secondary")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(width: 2, height: 16)
                        
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Text("Total Gross: $\(movie.revenue ?? 0)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(0 )
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            tmdbService.fetchWeeklyBoxOfficeWithRevenue { result in
                switch result {
                case .success(let movies):
                    self.movies = movies
                case .failure(let error):
                    print("Error fetching weekly box office movies: \(error)")
                }
            }
        }
    }
    
    func getPreviousWeekendDateRange() -> String {
        let calendar = Calendar.current
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"

        guard let lastWeek = calendar.date(byAdding: .day, value: -7, to: today) else {
            print("Couldn't calculate last week's date")
            return ""
        }

        var components = calendar.dateComponents([.year, .month, .day, .weekday], from: lastWeek)
        components.weekday = 6
        guard let friday = calendar.nextDate(after: lastWeek, matching: components, matchingPolicy: .nextTime, direction: .backward) else {
            print("Couldn't find Friday for last week")
            return ""
        }

        guard let sunday = calendar.date(byAdding: .day, value: 2, to: friday) else {
            print("Sunday date not found")
            return ""
        }
        
        let fridayString = formatter.string(from: friday)
        let sundayString = formatter.string(from: sunday)
        let year = calendar.component(.year, from: friday)
        
        let dateRange = "Weekend of \(fridayString) - \(sundayString), \(year)"
        print("Date range calculated: \(dateRange)")
        return dateRange
    }


}

#Preview {
    BoxOfficeView()
}
