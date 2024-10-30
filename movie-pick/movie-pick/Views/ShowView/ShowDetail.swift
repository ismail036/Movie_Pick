//
//  ShowDetail.swift
//  movie-pick
//
//  Created by İsmail Parlak on 24.10.2024.
//

import SwiftUI

struct ShowDetail: View {
    var showId: Int
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = 0
    @State private var isSticky = false
    @State private var showDetail: TVShowDetailModel?
    private let tmdbService = TMDBService()
    let stickyThreshold = UIScreen.main.bounds.height * 0.35

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if let show = showDetail {
                    AsyncImage(url: show.backdropURL) { phase in
                        switch phase {
                        case .empty:
                            Color.gray
                                .frame(height: UIScreen.main.bounds.height * 0.25)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: UIScreen.main.bounds.height * 0.25)
                                .clipped()
                                .edgesIgnoringSafeArea(.top)
                        case .failure:
                            Color.red
                                .frame(height: UIScreen.main.bounds.height * 0.25)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Color.gray
                        .frame(height: UIScreen.main.bounds.height * 0.25)
                }

                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        if let show = showDetail {
                            AsyncImage(url: show.posterURL) { phase in
                                switch phase {
                                case .empty:
                                    Color.gray
                                        .frame(width: 120, height: 180)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .frame(width: 120, height: 180)
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                        .offset(y: 40)
                                        .padding(.horizontal, 16)
                                case .failure:
                                    Color.red
                                        .frame(width: 120, height: 180)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }

                        Spacer()

                        Button(action: {
                            fetchTrailerAndOpen()
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
                .frame(width: 0, height: 10)
            
            ScrollView {
                ShowDetailInfoSection(showId: self.showId)
                
                VStack(spacing: 20) {
                    if let show = showDetail {
                        // Additional details
                    }
                    
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
                        ShowTabButtonsView(selectedTab: $selectedTab)
                            .frame(maxWidth: .infinity)
                            .background(Color.mainColor1)
                    }

                    if selectedTab == 0 {
                        ShowOverviewTab(showId: self.showId)
                    } else if selectedTab == 1 {
                        SeasonsTab(showId: self.showId, episodeRuntime: showDetail?.episodeRunTime?.first)
                    } else if selectedTab == 2 {
                        ShowPhotosAndVideosTab(showId: showId)
                    } else {
                        ShowReviewsTab(showId: showId)
                    }

                    Spacer()
                }
            }
            .overlay(
                VStack {
                    if isSticky {
                        ShowTabButtonsView(selectedTab: $selectedTab)
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
        .onAppear {
            fetchShowDetail()
        }
    }

    private func fetchShowDetail() {
        tmdbService.fetchTVShowDetails(showId: showId) { result in
            switch result {
            case .success(let show):
                DispatchQueue.main.async {
                    self.showDetail = show
                }
            case .failure(let error):
                print("Show detail could not be fetched: \(error.localizedDescription)")
            }
        }
    }

    private func fetchTrailerAndOpen() {
        tmdbService.fetchShowTrailer(showId: showId) { result in
            switch result {
            case .success(let urlString):
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url) // YouTube URL’yi aç
                }
            case .failure(let error):
                print("Error fetching trailer: \(error.localizedDescription)")
            }
        }
    }
}

    struct ShowTabButtonsView: View {
        @Binding var selectedTab: Int
        
        var body: some View {
            HStack(spacing: 0) {
                TabButton(title: "Overview", isSelected: selectedTab == 0, fontSize: 16)
                    .onTapGesture {
                        selectedTab = 0
                    }
                    .frame(maxWidth: .infinity)
                TabButton(title: "Seasons", isSelected: selectedTab == 1, fontSize: 16)
                    .onTapGesture {
                        selectedTab = 1
                    }
                    .frame(maxWidth: .infinity)
                TabButton(title: "Photos and Videos", isSelected: selectedTab == 2, fontSize: 16)
                    .onTapGesture {
                        selectedTab = 2
                    }
                    .frame(maxWidth: .infinity)
                TabButton(title: "Reviews", isSelected: selectedTab == 3, fontSize: 16)
                    .onTapGesture {
                        selectedTab = 3
                    }
                    .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 10)
            .background(Color.mainColor1)
        }
    }

    struct SeasonsTab: View {
        var showId: Int
        var episodeRuntime: Int?
        @State private var seasons: [TVSeason] = []
        @State private var showPosterURL: URL?

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Seasons")
                    .font(.title2)
                    .bold()

                if seasons.isEmpty {
                    Text("Loading...")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(seasons) { season in
                                NavigationLink(destination: SeasonDetailView(showId: self.showId , season: season, episodeRuntime: episodeRuntime,defaultPosterURL: showPosterURL)) {
                                    SeasonRow(season: season, defaultPosterURL: showPosterURL)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .onAppear {
                fetchSeasons()
            }
        }

        private func fetchSeasons() {
            TMDBService().fetchTVShowDetails(showId: showId) { result in
                switch result {
                case .success(let showDetail):
                    DispatchQueue.main.async {
                        self.showPosterURL = showDetail.posterURL
                        self.seasons = showDetail.seasons ?? []
                    }
                case .failure(let error):
                    print("Seasons could not be loaded: \(error.localizedDescription)")
                }
            }
        }
    }

    struct SeasonRow: View {
        let season: TVSeason
        let defaultPosterURL: URL?

        var body: some View {
            HStack {
                AsyncImage(url: season.posterURL ?? defaultPosterURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 150)
                        .cornerRadius(10)
                        .clipped()
                } placeholder: {
                    Color.gray
                        .frame(width: 100, height: 150)
                        .cornerRadius(10)
                }

                VStack(alignment: .leading) {
                    Text(season.name)
                        .font(.headline)

                    Text("\(season.episodeCount) Episodes")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    if let airDate = season.formattedAirDate {
                        Text("Air Date: \(airDate)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 5)
        }
    }

    struct SeasonDetailView: View {
        let showId: Int
        let season: TVSeason
        let episodeRuntime: Int?
        let defaultPosterURL: URL?
        @State private var episodes: [Episode] = []
        @Environment(\.dismiss) var dismiss

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                // Başlık kısmı
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.backward.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text(season.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.vertical)
                
                Text("\(season.name)")
                    .font(.title2)
                    .bold()
                    .padding(.top, 8)

                Text("\(season.episodeCount) Episodes, \(formattedTotalDuration())")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                if episodes.isEmpty {
                    Text("Loading episodes...")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                } else {
                    ScrollView {
                        ForEach(episodes) { episode in
                            EpisodeRow(episode: episode,showId:showId,defaultPosterURL:defaultPosterURL)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
            .onAppear {
                fetchEpisodes()
            }
        }

        private func fetchEpisodes() {
            TMDBService().fetchEpisodes(showId: showId, seasonNumber: season.seasonNumber) { result in
                switch result {
                case .success(let fetchedEpisodes):
                    DispatchQueue.main.async {
                        self.episodes = fetchedEpisodes
                    }
                case .failure(let error):
                    print("Episodes could not be loaded: \(error.localizedDescription)")
                }
            }
        }

        private func formattedTotalDuration() -> String {
            let totalMinutes = (season.episodeCount * (episodeRuntime ?? 0))
            let hours = totalMinutes / 60
            let minutes = totalMinutes % 60
            return "\(hours) hr \(minutes) min"
        }
    }

    struct EpisodeRow: View {
        let episode: Episode
        let showId :Int
        let defaultPosterURL: URL?

        var body: some View {
            NavigationLink(destination: EpisodeDetailView(showId: showId, seasonNumber:episode.seasonNumber , episodeNumber: episode.episodeNumber)){
                HStack {
                    AsyncImage(url: episode.stillURL ?? defaultPosterURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 80)
                            .cornerRadius(10)
                            .clipped()
                    } placeholder: {
                        Color.gray
                            .frame(width: 100, height: 80)
                            .cornerRadius(10)
                    }

                    VStack(alignment: .leading) {
                        Text("S\(episode.seasonNumber) : E\(episode.episodeNumber)")
                            .font(.headline)
                            .foregroundColor(.white)

                        Text(episode.name)
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        if let airDate = episode.formattedAirDate {
                            Text(airDate)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 5)
                .padding(.horizontal)
                .onAppear() {
                    print(episode)
                }
            }
            
        }
    }

    #Preview {
        ShowDetail(showId: 1396)
    }




extension TMDBService {
    func fetchShowTrailer(showId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/tv/\(showId)/videos"
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
                
                // İlk YouTube fragman videosunu bulma
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
