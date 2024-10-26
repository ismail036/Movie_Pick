//
//  OverviewTab.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct OverviewTab: View {
    
    @State private var showFullText = false
    var movieID : Int
    @State private var overview: String = ""
    
    
    
    
    @State private var genres: [String] = []
    @State private var voteAverage: Double = 0.0
    @State private var voteCount: Int = 0
    @State private var runtime: Int = 0
    @State private var releaseDate: String = ""
    

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Storyline")
                    .foregroundColor(Color.white)
                    .font(.headline)
                
                Text(showFullText ? overview : truncatedDescription() + "... ")
                    .foregroundColor(Color.gray)
                    .font(.body)
                
                Button(action: {
                    showFullText.toggle()
                }) {
                    Text(showFullText ? "read less" : "read more")
                        .foregroundColor(Color.blue)
                        .font(.body)
                }
            }
            .padding()
            
            CastCrewSection(movieId:1184918)

            VideosSection(movieId:1184918)
            
            MoreLikeThisSection(movieId: 1184918)
            
            MovieDetailInfoCard(movieId: 1184918)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.mainColor1)
        .onAppear(perform: fetchMovieDetails)
    }
    
    func truncatedDescription() -> String {
        let limit = 150 // Approximate character count to fit 3 lines
        if overview.count > limit {
            let endIndex = overview.index(overview.startIndex, offsetBy: limit)
            return String(overview[..<endIndex])
        }
        return overview
    }
    
    private func fetchMovieDetails() {
        TMDBService().fetchMovieDetails(movieId: movieID) { result in
            switch result {
            case .success(let movieDetail):
                DispatchQueue.main.async {
                    self.overview = movieDetail.overview ?? ""
                    self.genres = movieDetail.genres?.map { $0.name } ?? []
                    self.voteAverage = movieDetail.voteAverage ?? 0.0
                    self.voteCount = movieDetail.voteCount ?? 0
                    self.runtime = movieDetail.runtime ?? 0
                    self.releaseDate = movieDetail.releaseDate ?? "N/A"
                }
            case .failure(let error):
                print("Failed to fetch movie details: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    OverviewTab(movieID: 1184918)
}
