//
//  AiringTodaySection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 27.10.2024.
//

import SwiftUI

struct AiringTodaySection: View {
    @State private var shows: [TVShowModel] = []
    private let tmdbService = TMDBService()

    private var todayDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Airing Today")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Watch the newest episodes on \(todayDate)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(shows, id: \.id) { show in
                        VerticalShowCard(
                            showId: show.id
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.mainColor1)
        .onAppear {
            fetchAiringTodayShows()
        }
    }
    
    private func fetchAiringTodayShows() {
        tmdbService.fetchAiringTodayShows { result in
            switch result {
            case .success(let fetchedShows):
                DispatchQueue.main.async {
                    self.shows = fetchedShows
                }
            case .failure(let error):
                print("Failed to fetch airing today shows: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    AiringTodaySection()
}

