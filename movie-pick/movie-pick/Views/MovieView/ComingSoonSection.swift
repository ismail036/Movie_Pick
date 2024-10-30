//
//  ComingSoonSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct ComingSoonSection: View {
    let categories = ["Action", "Adventure", "Animation", "Comedy", "Horror", "Sci-Fi"]
    @State private var selectedCategories: Set<String> = []
    @State private var visibleCategories: [String] = []
    @State private var remainingCategories: [String] = []
    
    @State private var showDropdown = false
    @State private var selectedTimeFrame = "Next 30 Days"
    @State private var comingSoonMovies: [MovieModel] = []
    
    let timeFrames = ["Next 24 Hours", "Next 30 Days", "Next 3 Months", "Next 12 Months"]
    
    var body: some View {
        ZStack(alignment: .topTrailing) { // Use ZStack for absolute positioning
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Coming Soon")
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
                
                Text("Unveiling Soon: Anticipated Movie Releases")
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
                                    fetchComingSoonMovies()
                                }
                            )
                            .onTapGesture {
                                toggleCategorySelection(category)
                                fetchComingSoonMovies()
                            }
                        }
                        
                        if !remainingCategories.isEmpty {
                            NavigationLink(destination: ComingSoonDetail()) {
                                CategoryButtonView(title: "More...", isSelected: false)
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                print("NavigationLink to ComingSoonDetail was tapped")
                            })
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
                        ForEach(comingSoonMovies) { movie in
                            VerticalMovieCard(
                                selectedDestination: .movieDetail,
                                movieId: movie.id
                            )
                        }
                    }
                    .padding(.horizontal, 0)
                    .padding(.vertical, 0)
                }
                .padding(.leading, 0)
            }
            .background(Color.mainColor1)
            .onAppear {
                fetchComingSoonMovies()
            }
            
            if showDropdown {
                dropdownMenu
                    .background(Color.mainColor3)
                    .cornerRadius(12)
                    .frame(width: 200)
                    .shadow(radius: 5)
                    .offset(y: 60) // Adjust offset to position dropdown below the button
                    .transition(.opacity) // Optional fade-in effect
            }
        }
    }

    private var dropdownMenu: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(timeFrames, id: \.self) { timeFrame in
                Button(action: {
                    selectedTimeFrame = timeFrame
                    showDropdown = false
                    fetchComingSoonMovies()
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

    private func fetchComingSoonMovies() {
        let (startDate, endDate) = calculateDateRange(for: selectedTimeFrame)
        let selectedGenres = Array(selectedCategories)

        if selectedGenres.isEmpty {
            TMDBService().fetchComingSoonMovies(startDate: startDate, endDate: endDate) { result in
                switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        self.comingSoonMovies = movies
                    }
                case .failure(let error):
                    print("Failed to fetch coming soon movies: \(error.localizedDescription)")
                }
            }
        } else {
            TMDBService().fetchComingSoonMoviesByGenres(startDate: startDate, endDate: endDate, genres: selectedGenres) { result in
                switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        self.comingSoonMovies = movies
                    }
                case .failure(let error):
                    print("Failed to fetch filtered coming soon movies: \(error.localizedDescription)")
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
    ComingSoonSection()
}


extension TMDBService {
    func fetchComingSoonMoviesByGenres(startDate: String, endDate: String, genres: [String], completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/discover/movie"
        guard var urlComponents = URLComponents(string: endpoint) else { return }
        

        let genreIds = genres.compactMap { Genre.allGenres[$0] }.map { String($0) }.joined(separator: ",")
        
        urlComponents.queryItems = [
            URLQueryItem(name: "primary_release_date.gte", value: startDate),
            URLQueryItem(name: "primary_release_date.lte", value: endDate),
            URLQueryItem(name: "with_genres", value: genreIds)
        ]
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching coming soon movies by genres: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received for coming soon movies by genres")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                print("Error decoding coming soon movies by genres: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
