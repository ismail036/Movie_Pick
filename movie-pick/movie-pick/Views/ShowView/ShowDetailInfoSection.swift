//
//  ShowDetailInfoSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 27.10.2024.
//

//
//  ShowDetailInfoSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 27.10.2024.
//

import SwiftUI

struct ShowDetailInfoSection: View {
    let showId: Int
    @State private var title: String = ""
    @State private var genres: [String] = []
    @State private var voteAverage: Double = 0.0
    @State private var voteCount: Int = 0
    @State private var episodeRunTime: Int = 0
    @State private var firstAirDate: String = ""
    @State private var isBookmarked: Bool = false

    var body: some View {
        VStack(spacing: 10) {
            // Platform Icons
            HStack {
                Spacer()
                HStack(spacing: -20) {
                    Image("netflix_icon")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                    
                    Image("hulu_icon")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                    
                    Image("hbo_icon")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                    
                    Rectangle()
                        .frame(width: 50, height: 0)
                    
                    Button(action: {}) {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 10)
                            .foregroundColor(.gray)
                    }
                }
                .padding(10)
                .background(Color.mainColor3)
                .cornerRadius(40)
                .padding(.horizontal)
            }
            
            // Title and Genre Tags
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundStyle(Color.white)
                        .font(.title)
                        .bold()
                        .padding(.bottom, 2)
                    
                    HStack {
                        ForEach(genres.prefix(3), id: \.self) { genre in
                            Text(genre)
                                .foregroundStyle(Color.cyan)
                                .font(.caption)
                                .bold()
                            
                            if genre != genres.prefix(3).last {
                                Text("•")
                                    .foregroundStyle(Color.cyan)
                                    .font(.caption)
                                    .bold()
                            }
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    Button(action: {}) {
                        VStack {
                            Image(systemName: "bell")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 4)
                            
                            Text("Reminder")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .bold()
                        }
                    }
                    .padding(.horizontal, 5)
                    
                    Button(action: {
                        toggleBookmark()
                    }) {
                        VStack {
                            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 4)
                            
                            Text("Bookmark")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .bold()
                        }
                    }
                    .padding(.horizontal, 5)
                }
            }
            .padding(.horizontal, 16)
            
            // Vote, Runtime, Release Date Section
            GeometryReader { geometry in
                HStack(spacing: 10) {
                    // Vote Average and Vote Count
                    HStack {
                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                            .foregroundColor(.white)
                            .padding(0)
                        
                        Text(String(format: "%.1f", voteAverage))
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .minimumScaleFactor(0.5)
                            .padding(0)
                        
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 1, height: 18)
                            .padding(.horizontal, 0)

                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 14, height: 14)
                            .foregroundColor(.white)
                            .padding(0)

                        Text("\(voteCount)")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .minimumScaleFactor(0.5)
                            .padding(0)
                    }
                    .frame(width: geometry.size.width * 0.33, height: 30)
                    .background(Color.green)
                    .cornerRadius(16)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Episode Runtime
                    HStack {
                        Image(systemName: "timer")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 14, height: 14)
                            .foregroundColor(.white)

                        Text("\(episodeRunTime / 60) hr \(episodeRunTime % 60) min")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .minimumScaleFactor(0.5)
                    }
                    .frame(width: geometry.size.width * 0.27, height: 30)
                    .background(Color.blue)
                    .cornerRadius(16)
                    
                    // First Air Date
                    VStack {
                        Text("First Air Date")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .bold()
                            .minimumScaleFactor(0.5)
                            .padding(.trailing,12)

                        
                        Text(firstAirDate)
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .bold()
                            .minimumScaleFactor(0.5)
                            .padding(.trailing,12)

                    }
                    .frame(width: geometry.size.width * 0.3, height: 30,alignment: .trailing)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 14)
                .frame(width: geometry.size.width)
            }
            .frame(height: 40)
            .onAppear {
                        fetchShowDetails()
                        checkIfBookmarked()
                    }
        }
        .background(Color.black)
    }
        
    private func fetchShowDetails() {
        TMDBService().fetchTVShowDetails(showId: showId) { result in
            switch result {
            case .success(let showDetail):
                DispatchQueue.main.async {
                    self.title = showDetail.name
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
    
    private func toggleBookmark() {
        isBookmarked.toggle()
        if isBookmarked {
            saveToFavorites()
        } else {
            removeFromFavorites()
        }
    }
    
    private func saveToFavorites() {
        var favoriteShows = UserDefaults.standard.array(forKey: "favoriteShowIds") as? [Int] ?? []
        favoriteShows.append(showId)
        
        UserDefaults.standard.set(favoriteShows, forKey: "favoriteShowIds")
    }
    
    private func removeFromFavorites() {
        var favoriteShows = UserDefaults.standard.array(forKey: "favoriteShowIds") as? [Int] ?? []
        favoriteShows.removeAll { $0 == showId }
        
        UserDefaults.standard.set(favoriteShows, forKey: "favoriteShowIds")
    }
    
    private func checkIfBookmarked() {
        let favoriteShows = UserDefaults.standard.array(forKey: "favoriteShowIds") as? [Int] ?? []
        isBookmarked = favoriteShows.contains(showId)
    }
}

#Preview {
    ShowDetailInfoSection(showId: 1412)
}
