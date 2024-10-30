//
//  MovieDetail.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct MovieDetail: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = 0
    @State private var isSticky = false
    @State private var trailerURL: URL?
    let stickyThreshold = UIScreen.main.bounds.height * 0.35
    let movie: MovieModel
    private let tmdbService = TMDBService()
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if let backdropURL = movie.backdropURL {
                    AsyncImage(url: backdropURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: UIScreen.main.bounds.height * 0.25)
                            .clipped()
                            .edgesIgnoringSafeArea(.top)
                    } placeholder: {
                        Color.gray
                            .frame(height: UIScreen.main.bounds.height * 0.25)
                            .clipped()
                            .edgesIgnoringSafeArea(.top)
                    }
                }

                VStack {
                    Spacer()

                    HStack(alignment: .center) {
                        if let posterURL = movie.posterURL {
                            AsyncImage(url: posterURL) { image in
                                image
                                    .resizable()
                                    .frame(width: 120, height: 180)
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                                    .offset(y: 40)
                                    .padding(.horizontal, 16)
                            } placeholder: {
                                Color.gray
                                    .frame(width: 120, height: 180)
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                                    .offset(y: 40)
                                    .padding(.horizontal, 16)
                            }
                        }

                        Spacer()

                        Button(action: {
                            fetchTrailer()
                        }) {
                            Image("movie_icon")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .shadow(radius: 5)
                        }
                        .offset(y: 50)
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 10)
            }
            .frame(height: UIScreen.main.bounds.height * 0.30)

            Rectangle()
                .frame(width: 0, height: 35)

            ScrollView {
                VStack(spacing: 5) {
                    MovieDetailInfoSection(movie: self.movie)
                    
                    GeometryReader { geo in
                        let offset = geo.frame(in: .global).minY
                        Color.clear
                            .onAppear {
                                self.isSticky = offset <= stickyThreshold
                            }
                            .onChange(of: offset) { newValue in
                                self.isSticky = newValue <= stickyThreshold
                            }
                    }
                    .frame(height: 0)
                    
                    if !isSticky {
                        TabButtonsView(selectedTab: $selectedTab)
                            .frame(maxWidth: .infinity)
                            .background(Color.mainColor1)
                    }
                    
                    if selectedTab == 0 {
                        OverviewTab(movieID: movie.id, movieModel: self.movie)
                    } else if selectedTab == 1 {
                        PhotosAndVideosTab(movieId: movie.id)
                    } else if selectedTab == 2 {
                        ReviewsTab(movieId: movie.id)
                            .navigationBarBackButtonHidden(true)
                    }

                    Spacer()
                }
            }
            .overlay(
                VStack {
                    if isSticky {
                        TabButtonsView(selectedTab: $selectedTab)
                            .frame(maxWidth: .infinity)
                            .background(Color.mainColor1)
                            .padding(.top, 0)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .animation(.easeInOut, value: isSticky)
            )

            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 26, height: 26)
                        .foregroundColor(.white)
                }
            }
        }
        .toolbarBackground(Color.clear, for: .navigationBar)
        .edgesIgnoringSafeArea(.top)
        .background(Color.mainColor1)
    }
    
    private func fetchTrailer() {
        tmdbService.fetchMovieTrailer(movieId: movie.id) { result in
            switch result {
            case .success(let urlString):
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url) // URL'yi doğrudan aç
                }
            case .failure(let error):
                print("Error fetching trailer: \(error.localizedDescription)")
            }
        }
    }
}


extension TMDBService {
    func fetchMovieTrailer(movieId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/movie/\(movieId)/videos"
        guard var urlComponents = URLComponents(string: endpoint) else { return }

        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: TMDBAPI.apiKey),
            URLQueryItem(name: "language", value: "en-US")
        ]
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(VideoResponse.self, from: data)
                
                // Optional binding to safely access the first video if it exists
                if let trailer = response.results?.first(where: { $0.type == "Trailer" && $0.site == "YouTube" }) {
                    let trailerURL = "https://www.youtube.com/watch?v=\(trailer.key)"
                    completion(.success(trailerURL))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Trailer not found"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}



// Sticky TabButtons Bileşeni
struct TabButtonsView: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack(spacing: 0) {
            TabButton(title: "Overview", isSelected: selectedTab == 0, fontSize: 16)
                .onTapGesture {
                    selectedTab = 0
                }
                .frame(maxWidth: .infinity)
            TabButton(title: "Photos and Videos", isSelected: selectedTab == 1, fontSize: 16)
                .onTapGesture {
                    selectedTab = 1
                }
                .frame(maxWidth: .infinity)

            TabButton(title: "Reviews", isSelected: selectedTab == 2, fontSize: 16)
                .onTapGesture {
                    selectedTab = 2
                }
                .frame(maxWidth: .infinity) 
        }
        .padding(.vertical, 10)
        .background(Color.mainColor1)
    }
}

// TabButton Bileşeni
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let fontSize: Int

    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: CGFloat(fontSize)))
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .blue : .gray)
                .padding(.bottom, 4)
                .frame(maxWidth: .infinity, alignment: .center)

            Rectangle()
                .frame(height: 2)
                .foregroundColor(isSelected ? Color.blue : Color.clear)
        }
        .animation(.easeInOut, value: isSelected)
        .padding(.top, 3)
        .padding(.horizontal, 10)
        .fixedSize(horizontal: true, vertical: false)
    }
}

#Preview {
        MovieDetail(movie: MovieModel(id: 1184918, title: "The Wild Robot", originalTitle: Optional("The Wild Robot"), overview: "After a shipwreck, an intelligent robot called Roz is stranded on an uninhabited island. To survive the harsh environment, Roz bonds with the island\'s animals and cares for an orphaned baby goose.", posterPath: Optional("/wTnV3PCVW5O92JMrFvvrRcV39RU.jpg"), backdropPath: Optional("/417tYZ4XUyJrtyZXj7HpvWf1E8f.jpg"), releaseDate: Optional("2024-09-12"), runtime: nil, voteAverage: Optional(8.641), voteCount: Optional(1514), genreIds: Optional([16, 878, 10751]), genres: nil, popularity: Optional(5400.805), originalLanguage: Optional("en"), adult: Optional(false), budget: nil, revenue: nil, tagline: nil, homepage: nil, status: nil))

}
