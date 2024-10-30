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
        VStack(alignment: .leading) {
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
            
            Text("Weekend of Oct 4 - 6, 2024")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            
            ForEach(movies.prefix(5), id: \.id) { movie in
                
                NavigationLink(destination: MovieDetail(movie: movie)){
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
}



#Preview {
    BoxOfficeView()
}
