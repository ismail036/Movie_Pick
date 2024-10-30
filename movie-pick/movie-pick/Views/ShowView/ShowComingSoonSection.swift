//
//  ShowComingSoonSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI

struct ShowComingSoonSection: View {
    let categories = ["Action & Adventure", "Animation", "Comedy", "Drama", "Mystery", "Sci-Fi & Fantasy"]
    @State private var selectedCategories: Set<String> = []
    @State private var visibleCategories: [String] = []
    @State private var remainingCategories: [String] = []
    @State private var showDropdown = false
    @State private var selectedTimeFrame = "Next 30 Days"
    @State private var comingSoonShows: [TVShowModel] = []
    @State private var genresInitialized = false

    private let timeFrames = ["Next 24 Hours", "Next 30 Days", "Next 3 Months", "Next 12 Months"]
    private let tmdbService = TMDBService()

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Coming Soon Shows")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Spacer()

                    Button(action: {
                        withAnimation {
                            showDropdown.toggle()
                        }
                    }) {
                        HStack {
                            Text(selectedTimeFrame)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)

                            Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(Color.blue)
                        .cornerRadius(25)
                    }
                }
                .zIndex(1)

                Text("Unveiling Soon: Anticipated Show Releases")
                    .font(.system(size: 12))
                    .foregroundColor(Color.gray)

                GeometryReader { geometry in
                    HStack {
                        ForEach(visibleCategories, id: \.self) { category in
                            CategoryButtonView(
                                title: category,
                                isSelected: selectedCategories.contains(category),
                                onRemove: {
                                    selectedCategories.remove(category)
                                    fetchComingSoonShows()
                                }
                            )
                            .onTapGesture {
                                toggleCategorySelection(category)
                                fetchComingSoonShows()
                            }
                        }

                        if !remainingCategories.isEmpty {
                            NavigationLink(destination: ComingSoonDetail()) {
                                CategoryButtonView(title: "More...", isSelected: false)
                            }
                        }
                    }
                    .onAppear {
                        calculateVisibleCategories(for: geometry.size.width)
                    }
                    .padding(.horizontal, 0)
                }
                .frame(height: 50)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(comingSoonShows) { show in
                            NavigationLink(destination: ShowDetail(showId: show.id)) {
                                VerticalShowCard(
                                    selectedDestination: .showDetail,
                                    showId: show.id
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 0)
                    .padding(.vertical, 0)
                }
                .padding(.leading, 0)
            }
            .background(Color.mainColor1)
            .onAppear {
                if !genresInitialized {
                    tmdbService.initializeShowGenres { result in
                        switch result {
                        case .success:
                            genresInitialized = true
                            fetchComingSoonShows()
                        case .failure(let error):
                            print("Failed to initialize genres: \(error.localizedDescription)")
                        }
                    }
                }
            }

            if showDropdown {
                dropdownMenu
                    .background(Color.mainColor3)
                    .cornerRadius(12)
                    .frame(width: 200)
                    .shadow(radius: 5)
                    .offset(y: 60)
                    .transition(.opacity)
            }
        }
    }

    private var dropdownMenu: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(timeFrames, id: \.self) { timeFrame in
                Button(action: {
                    selectedTimeFrame = timeFrame
                    showDropdown = false
                    fetchComingSoonShows()
                }) {
                    HStack {
                        Text(timeFrame)
                            .foregroundColor(.white)

                        Spacer()

                        if selectedTimeFrame == timeFrame {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .frame(height: 44)
            }
        }
    }

    private func toggleCategorySelection(_ category: String) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }

    private func calculateVisibleCategories(for totalWidth: CGFloat) {
        var currentWidth: CGFloat = 0
        let buttonPadding: CGFloat = 16
        let moreButtonWidth: CGFloat = 80

        visibleCategories = []
        remainingCategories = []

        for category in categories {
            let buttonWidth = category.widthOfString(usingFont: .systemFont(ofSize: 14, weight: .bold)) + buttonPadding * 2

            if currentWidth + buttonWidth + moreButtonWidth <= totalWidth {
                visibleCategories.append(category)
                currentWidth += buttonWidth + buttonPadding
            } else {
                remainingCategories.append(category)
            }
        }
    }

    private func fetchComingSoonShows() {
        guard genresInitialized else { return }

        let (startDate, endDate) = calculateDateRange(for: selectedTimeFrame)
        let selectedGenres = Array(selectedCategories)

        if selectedGenres.isEmpty {
            tmdbService.fetchComingSoonShows(startDate: startDate, endDate: endDate) { result in
                switch result {
                case .success(let shows):
                    DispatchQueue.main.async {
                        self.comingSoonShows = shows
                    }
                case .failure(let error):
                    print("Failed to fetch coming soon shows: \(error.localizedDescription)")
                }
            }
        } else {
            tmdbService.fetchComingSoonShowsByGenres(startDate: startDate, endDate: endDate, genres: selectedGenres) { result in
                switch result {
                case .success(let shows):
                    DispatchQueue.main.async {
                        self.comingSoonShows = shows
                    }
                case .failure(let error):
                    print("Failed to fetch filtered coming soon shows: \(error.localizedDescription)")
                }
            }
        }
    }

    private func calculateDateRange(for timeFrame: String) -> (String, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let currentDate = Date()
        var endDate = currentDate

        switch timeFrame {
        case "Next 24 Hours":
            endDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        case "Next 30 Days":
            endDate = Calendar.current.date(byAdding: .day, value: 30, to: currentDate) ?? currentDate
        case "Next 3 Months":
            endDate = Calendar.current.date(byAdding: .month, value: 3, to: currentDate) ?? currentDate
        case "Next 12 Months":
            endDate = Calendar.current.date(byAdding: .year, value: 1, to: currentDate) ?? currentDate
        default:
            break
        }

        let startDateString = dateFormatter.string(from: currentDate)
        let endDateString = dateFormatter.string(from: endDate)

        return (startDateString, endDateString)
    }
}

#Preview {
    ShowComingSoonSection()
}



extension TMDBService {
    private static var showGenreDictionary: [String: Int] = [:]


    func fetchComingSoonShowsByGenres(startDate: String, endDate: String, genres: [String], completion: @escaping (Result<[TVShowModel], Error>) -> Void) {
        let genreIds = genres.compactMap { TMDBService.showGenreDictionary[$0] }.map { String($0) }.joined(separator: ",")
        let endpoint = "\(TMDBAPI.baseURL)/discover/tv"
        guard var urlComponents = URLComponents(string: endpoint) else { return }

        urlComponents.queryItems = [
            URLQueryItem(name: "first_air_date.gte", value: startDate),
            URLQueryItem(name: "first_air_date.lte", value: endDate),
            URLQueryItem(name: "with_genres", value: genreIds),
            URLQueryItem(name: "with_origin_country", value: "US")
        ]

        guard let url = urlComponents.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        print("Fetching shows with URL: \(url)")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching coming soon shows by genres: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for coming soon shows by genres")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(TVShowResponse.self, from: data)
                // Map genres to the shows
                let showsWithGenres = response.results.map { show in
                    var updatedShow = show
                    updatedShow.genres = show.genreIds?.compactMap { genreId in
                        if let genreName = TMDBService.showGenreDictionary.first(where: { $0.value == genreId })?.key {
                            return Genre(id: genreId, name: genreName)
                        }
                        return nil
                    }
                    return updatedShow
                }
                completion(.success(showsWithGenres))
            } catch {
                print("Error decoding coming soon shows by genres: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func fetchComingSoonShows(startDate: String, endDate: String, completion: @escaping (Result<[TVShowModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/discover/tv"
        guard var urlComponents = URLComponents(string: endpoint) else { return }

        urlComponents.queryItems = [
            URLQueryItem(name: "first_air_date.gte", value: startDate),
            URLQueryItem(name: "first_air_date.lte", value: endDate),
            URLQueryItem(name: "with_origin_country", value: "US")
        ]

        guard let url = urlComponents.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        print("Fetching shows with URL: \(url)")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching coming soon shows: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for coming soon shows")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(TVShowResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                print("Error decoding coming soon shows: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

}
