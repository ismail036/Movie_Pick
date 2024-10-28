//
//  ShowComingSoonSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI

struct ShowComingSoonSection: View {
    let categories = ["Action", "Adventure", "Animation", "Comedy", "Horror", "Sci-Fi"]
    @State private var visibleCategories: [String] = []
    @State private var remainingCategories: [String] = []
    
    @State private var showDropdown = false
    @State private var selectedTimeFrame = "Next 30 Days"
    @State private var comingSoonShows: [TVShowModel] = [] // Coming soon dizilerini tutar
    
    let timeFrames = ["Next 24 Hours", "Next 30 Days", "Next 3 Months", "Next 12 Months"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Coming Soon Shows")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()

                ZStack(alignment: .topTrailing) {
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

                    if showDropdown {
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
                        .background(Color.mainColor3)
                        .cornerRadius(12)
                        .frame(width: 200)
                        .shadow(radius: 5)
                        .offset(y: 140)
                        .zIndex(1)
                    }
                }
            }.zIndex(1)
            
            Text("Unveiling Soon: Anticipated Show Releases")
                .font(.system(size: 12))
                .foregroundColor(Color.gray)
            
            GeometryReader { geometry in
                HStack {
                    ForEach(visibleCategories, id: \.self) { category in
                        CategoryButtonView(title: category)
                    }
                    
                    if !remainingCategories.isEmpty {
                        NavigationLink(destination: ComingSoonDetail()) {
                            CategoryButtonView(title: "More...")
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
                        VerticalShowCard(
                            selectedDestination: .showDetail,
                            showId: show.id
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
            fetchComingSoonShows()
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
        let (startDate, endDate) = calculateDateRange(for: selectedTimeFrame)
        TMDBService().fetchComingSoonShows(startDate: startDate, endDate: endDate) { result in
            switch result {
            case .success(let shows):
                DispatchQueue.main.async {
                    self.comingSoonShows = shows
                }
            case .failure(let error):
                print("Failed to fetch coming soon shows: \(error.localizedDescription)")
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
    func fetchComingSoonShows(startDate: String, endDate: String, completion: @escaping (Result<[TVShowModel], Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/discover/tv?first_air_date.gte=\(startDate)&first_air_date.lte=\(endDate)"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

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
