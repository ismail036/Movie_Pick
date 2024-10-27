//
//  MovieDetailInfoSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct MovieDetailInfoSection: View {
    let movie: MovieModel
    @State private var title: String = ""
    @State private var genres: [String] = []
    @State private var voteAverage: Double = 0.0
    @State private var voteCount: Int = 0
    @State private var runtime: Int = 0
    @State private var releaseDate: String = ""

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
                    
                    Button(action: {}) {
                        VStack {
                            Image(systemName: "bookmark")
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
                    
                    // Runtime
                    HStack {
                        Image(systemName: "timer")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 14, height: 14)
                            .foregroundColor(.white)

                        Text("\(runtime / 60) hr \(runtime % 60) min")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .minimumScaleFactor(0.5)
                    }
                    .frame(width: geometry.size.width * 0.27, height: 30)
                    .background(Color.blue)
                    .cornerRadius(16)
                    
                    // Release Date
                    VStack {
                        Text("Release Date")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .bold()
                            .minimumScaleFactor(0.5)
                            .padding(.trailing,12)

                        
                        Text(releaseDate)
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
                        fetchMovieDetails()
                    }
        }
        .background(Color.black)
    }
        
    
    // Movie detaylarını çekmek için fonksiyon
    private func fetchMovieDetails() {
        TMDBService().fetchMovieDetails(movieId: movie.id) { result in
            switch result {
            case .success(let movieDetail):
                DispatchQueue.main.async {
                    self.title = movieDetail.title
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
    MovieDetailInfoSection(movie: MovieModel(
        id: 1184918, title: "The Wild Robot", originalTitle: Optional("The Wild Robot"), overview: "After a shipwreck, an intelligent robot called Roz is stranded on an uninhabited island. To survive the harsh environment, Roz bonds with the island\'s animals and cares for an orphaned baby goose.", posterPath: Optional("/wTnV3PCVW5O92JMrFvvrRcV39RU.jpg"), backdropPath: Optional("/417tYZ4XUyJrtyZXj7HpvWf1E8f.jpg"), releaseDate: Optional("2024-09-12"), runtime: nil, voteAverage: Optional(8.641), voteCount: Optional(1514), genreIds: Optional([16, 878, 10751]), genres: nil, popularity: Optional(5400.805), originalLanguage: Optional("en"), adult: Optional(false), budget: nil, revenue: nil, tagline: nil, homepage: nil, status: nil
    ))
}
