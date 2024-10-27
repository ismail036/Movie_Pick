//
//  DiscoverShowDetail.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI

struct ShowDiscoverDetail: View {
    @Environment(\.presentationMode) var presentationMode
    let genres = ["All Genres", "Drama", "Comedy", "Action", "Thriller", "Horror", "Fantasy"]
    
    @State private var selectedGenres: [String] = []
    @State private var allShows: [TVShowModel] = []
    @State private var filteredShows: [TVShowModel] = []
    
    var body: some View {
        VStack {
            genreScrollView
            
            ScrollView {
                VStack(alignment: .leading) {
                    let cardWidth = (UIScreen.main.bounds.width - 48) / 3

                    LazyVGrid(columns: [
                        GridItem(.fixed(cardWidth), spacing: 8),
                        GridItem(.fixed(cardWidth), spacing: 8),
                        GridItem(.fixed(cardWidth), spacing: 8)
                    ], spacing: 8) {
                        ForEach(filteredShows) { show in
                            VerticalShowCard(
                                selectedDestination: .showDetail,
                                showId: show.id,
                                multiplier: 0.7
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .background(Color.mainColor1)
        .onAppear {
            fetchDiscoverShows()
        }
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
                Text("Discover Shows")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(Color.mainColor1, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    private var genreScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(genres, id: \.self) { genre in
                    Button(action: {
                        if genre == "All Genres" {
                            selectedGenres.removeAll()
                            filteredShows = allShows
                        } else {
                            if selectedGenres.contains("All Genres") {
                                selectedGenres.removeAll { $0 == "All Genres" }
                            }
                            if selectedGenres.contains(genre) {
                                selectedGenres.removeAll { $0 == genre }
                            } else {
                                selectedGenres.append(genre)
                            }
                            applyGenreFilter()
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text(genre)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(selectedGenres.contains(genre) ? Color.white : Color.blue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                            if selectedGenres.contains(genre) {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16, height: 16)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                    .background(selectedGenres.contains(genre) ? Color.blue : Color.blue.opacity(0.3))
                    .cornerRadius(20)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }

    private func fetchDiscoverShows() {
        TMDBService().fetchAllDiscoverShows { result in
            switch result {
            case .success(let shows):
                DispatchQueue.main.async {
                    self.allShows = shows
                    self.filteredShows = shows
                    self.setGenresForShows()
                }
            case .failure(let error):
                print("Failed to fetch discover shows: \(error.localizedDescription)")
            }
        }
    }

    private func applyGenreFilter() {
        if selectedGenres.isEmpty || selectedGenres.contains("All Genres") {
            filteredShows = allShows
        } else {
            filteredShows = allShows.filter { show in
                let showGenres = show.genres?.map { $0.name } ?? []
                return !Set(selectedGenres).isDisjoint(with: showGenres)
            }
        }
    }
    
    private func setGenresForShows() {
        TMDBService().fetchGenres { result in
            switch result {
            case .success(let genreList):
                DispatchQueue.main.async {
                    for index in allShows.indices {
                        allShows[index].setGenres(from: genreList)
                    }
                }
            case .failure(let error):
                print("Error setting genres for shows: \(error)")
            }
        }
    }

}

extension TVShowModel {
    mutating func setGenres(from genreList: [Genre]) {
        self.genres = genreIds?.compactMap { genreId in
            genreList.first { $0.id == genreId }
        }
    }
}

#Preview {
    ShowDiscoverDetail()
}


extension TMDBService {
    func fetchAllDiscoverShows(completion: @escaping (Result<[TVShowModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/discover/tv"
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching discover shows: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for discover shows")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(TVShowResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                print("Error decoding discover shows: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
