//
//  ShowOverviewTab.swift
//  movie-pick
//
//  Created by İsmail Parlak on 27.10.2024.
//

import SwiftUI

struct ShowOverviewTab: View {
    
    @State private var showFullText = false
    var showId: Int
    @State private var overview: String = ""
    
    @State private var genres: [String] = []
    @State private var voteAverage: Double = 0.0
    @State private var voteCount: Int = 0
    @State private var episodeRunTime: Int = 0
    @State private var firstAirDate: String = ""
    
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
            
            ShowCastCrewSection(showId: self.showId)

            ShowVideosSection(showId: self.showId)
            
            ShowMoreLikeThisSection(showId: self.showId)
            
            ShowDetailInfoCard(showId: self.showId)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.mainColor1)
        .onAppear(perform: fetchShowDetails)
    }
    
    func truncatedDescription() -> String {
        let limit = 150 
        if overview.count > limit {
            let endIndex = overview.index(overview.startIndex, offsetBy: limit)
            return String(overview[..<endIndex])
        }
        return overview
    }
    
    private func fetchShowDetails() {
        TMDBService().fetchTVShowDetails(showId: showId) { result in
            switch result {
            case .success(let showDetail):
                DispatchQueue.main.async {
                    self.overview = showDetail.overview ?? ""
                    self.genres = showDetail.genres?.map { $0.name } ?? []
                    self.voteAverage = showDetail.voteAverage ?? 0.0
                    self.voteCount = showDetail.voteCount ?? 0
                    self.episodeRunTime = showDetail.episodeRunTime?.first ?? 0
                    self.firstAirDate = showDetail.firstAirDateFormatted ?? "N/A"
                }
            case .failure(let error):
                print("Failed to fetch show details: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ShowOverviewTab(showId: 1412)
}
