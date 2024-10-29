    //
    //  LibraryView.swift
    //  movie-pick
    //
    //  Created by İsmail Parlak on 26.10.2024.
    //

    import SwiftUI

    struct LibraryView: View {
        @State private var selectedTab = 0
        @State private var isSticky = false
        var body: some View {
            
            VStack {
                if !isSticky {
                    LibraryTabButtonsView(selectedTab: $selectedTab)
                        .frame(maxWidth: .infinity)
                        .background(Color.mainColor1)
                }
                
                VStack {
                    if selectedTab == 0 {
                        WatchlistTab()
                    } else if selectedTab == 1 {
                        RemindersTab()
                    }
                    Spacer()
                }
                .background(Color.mainColor1)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.mainColor1)
        }
    }

    struct LibraryTabButtonsView: View {
        @Binding var selectedTab: Int

        var body: some View {
            HStack(spacing: 0) {
                TabButton(title: "Watchlist", isSelected: selectedTab == 0, fontSize: 16)
                    .onTapGesture {
                        selectedTab = 0
                    }
                    .frame(maxWidth: .infinity)
                TabButton(title: "Reminders", isSelected: selectedTab == 1, fontSize: 16)
                    .onTapGesture {
                        selectedTab = 1
                    }
                    .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 10)
            .background(Color.mainColor1)
        }
    }


    struct WatchlistTab: View {
        @State private var bookmarkedMovies: [MovieDetailModel] = []
        @State private var bookmarkedShows: [TVShowDetailModel] = []

        var body: some View {
            VStack {
                if bookmarkedMovies.isEmpty && bookmarkedShows.isEmpty {
                    Spacer()
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 120))
                        .background(Color.cyanBlue)
                        .cornerRadius(20)
                        .padding(.bottom,10)
                    
                    Text("No Movies or Shows Tracked Yet")
                        .foregroundColor(.white)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom,5)
                    
                    Text("Begin Tracking your Favorite Movies or TV Shows.")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom,5)
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("Add")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 20))
                            .padding(.all, 10)
                    }
                    .background(Color.gray)
                    .cornerRadius(20)
                    
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(bookmarkedMovies, id: \.id) { movie in
                                MovieRow(movie: movie)
                                    .padding(0)
                            }
                            
                            ForEach(bookmarkedShows, id: \.id) { show in
                                ShowRow(show: show)
                                    .padding(0)
                            }
                        }
                        .padding(0)
                        .background(Color.mainColor1)
                    }
                    .background(Color.mainColor1)
                    .padding(0)
                }
            }
            .onAppear(perform: fetchBookmarkedItems)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 10)
            .background(Color.mainColor1)
        }

        private func fetchBookmarkedItems() {
            fetchBookmarkedMovies()
            fetchBookmarkedShows()
        }

        private func fetchBookmarkedMovies() {
            let movieIds = UserDefaults.standard.array(forKey: "favoriteMovieIds") as? [Int] ?? []
            var movies: [MovieDetailModel] = []
            let dispatchGroup = DispatchGroup()
            
            for movieId in movieIds {
                dispatchGroup.enter()
                TMDBService().fetchMovieDetails(movieId: movieId) { result in
                    switch result {
                    case .success(let movie):
                        movies.append(movie)
                    case .failure(let error):
                        print("Failed to fetch movie: \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.bookmarkedMovies = movies
            }
        }
        
        private func fetchBookmarkedShows() {
            let showIds = UserDefaults.standard.array(forKey: "favoriteShowIds") as? [Int] ?? []
            var shows: [TVShowDetailModel] = []
            let dispatchGroup = DispatchGroup()
            
            for showId in showIds {
                dispatchGroup.enter()
                TMDBService().fetchTVShowDetails(showId: showId) { result in
                    switch result {
                    case .success(let show):
                        shows.append(show)
                    case .failure(let error):
                        print("Failed to fetch show: \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.bookmarkedShows = shows
            }
        }
    }

    struct ShowRow: View {
        let show: TVShowDetailModel
        @State private var showDetail: TVShowModel?

        var body: some View {
            VStack {
                if let showDetail = showDetail {
                    NavigationLink(destination: ShowDetail(showId: showDetail.id)) {
                        rowContent
                    }
                } else {
                    rowContent
                        .onAppear {
                            fetchShowDetail()
                        }
                }
            }
        }
        
        private var rowContent: some View {
            HStack(spacing: 16) {
                if let posterPath = show.posterURL, let url = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 150)
                            .cornerRadius(8)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 100, height: 150)
                            .cornerRadius(8)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(show.name)
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    let genreText = show.genres?.prefix(3).map { $0.name }.joined(separator: " / ") ?? ""
                                   Text(genreText)
                                       .foregroundColor(.gray)
                                       .font(.subheadline)
                    
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(.white)
                        .font(.title3)
                }
                
                Spacer()
            }
            .frame(alignment: .leading)
            .background(Color.mainColor1)
            .cornerRadius(12)
            .shadow(radius: 4)
        }

        private func fetchShowDetail() {
            TMDBService().fetchShowById(showId: show.id) { result in
                switch result {
                case .success(let detail):
                    self.showDetail = detail
                case .failure(let error):
                    print("Failed to fetch show detail: \(error.localizedDescription)")
                }
            }
        }
    }

    struct MovieRow: View {
        let movie: MovieDetailModel
        @State private var movieDetail: MovieModel?

        var body: some View {
            VStack {
                if let movieDetail = movieDetail {
                    NavigationLink(destination: MovieDetail(movie: movieDetail)) {
                        rowContent
                    }
                } else {
                    rowContent
                        .onAppear {
                            fetchMovieDetail()
                        }
                }
            }
        }
        
        private var rowContent: some View {
            HStack(spacing: 16) {
                if let posterPath = movie.images?.posters.first?.url, let url = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 150)
                            .cornerRadius(8)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 100, height: 150)
                            .cornerRadius(8)
                    }
                }


                    VStack(alignment: .leading, spacing: 4) {
                        Text(movie.title)
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        let genreText = movie.genres?.prefix(2).map { $0.name }.joined(separator: " / ") ?? ""
                        
                        Text(genreText)
                            .foregroundColor(.gray)
                            .font(.subheadline)

                        Image(systemName: "bookmark.fill")
                            .foregroundColor(.white)
                            .font(.title3)
                    }
                    .frame(width: 200,alignment: .leading)

                Spacer()
                
                
            }
            .padding(0)
            .frame(alignment: .leading)
            .background(Color.mainColor1)
            .cornerRadius(12)
            .shadow(radius: 4)
        }

        private func fetchMovieDetail() {
            TMDBService().fetchMovieById(movieId: movie.id) { result in
                switch result {
                case .success(let detail):
                    self.movieDetail = detail
                case .failure(let error):
                    print("Failed to fetch movie detail: \(error.localizedDescription)")
                }
            }
        }
    }



struct RemindersTab: View {
    @State private var reminders: [(title: String, date: String, movieId: Int, posterURL: String?, genres: String, remainingTime: String)] = []

    var body: some View {
        VStack {
            if reminders.isEmpty {
                Spacer()
                Image(systemName: "bell.fill")
                    .font(.system(size: 120))
                    .background(Color.cyanBlue)
                    .cornerRadius(20)
                    .padding(.bottom, 10)

                Text("No Reminders set")
                    .foregroundColor(.white)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 5)

                Text("Plan your watching schedule by adding movies or TV shows here.")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 5)

                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(reminders, id: \.title) { reminder in
                            HStack(spacing: 16) {
                                if let posterURL = reminder.posterURL, let url = URL(string: posterURL) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 150)
                                            .cornerRadius(8)
                                    } placeholder: {
                                        Rectangle()
                                            .fill(Color.gray)
                                            .frame(width: 100, height: 150)
                                            .cornerRadius(8)
                                    }
                                } else {
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(width: 100, height: 150)
                                        .cornerRadius(8)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(reminder.title)
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    
                                    Text(reminder.genres) // Türler burada gösterilecek
                                        .foregroundColor(.gray)
                                        .font(.subheadline)

                                    
                                    HStack {
                                        Image(systemName: "bell.fill")
                                            .foregroundColor(.white)
                                        Text(reminder.remainingTime) // Kalan zaman burada gösterilecek
                                            .foregroundColor(.gray)
                                            .font(.subheadline)
                                    }
                                }
                                .padding(.leading, 10)
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                            .shadow(radius: 4)
                        }
                    }
                    .padding()
                }
                .background(Color.mainColor1)
            }
        }
        .onAppear(perform: loadReminders)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 10)
        .background(Color.mainColor1)
    }

    private func loadReminders() {
        if let data = UserDefaults.standard.data(forKey: "reminders"),
           let savedReminders = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: Any]] {
            
            var tempReminders: [(title: String, date: String, movieId: Int, posterURL: String?, genres: String, remainingTime: String)] = []
            let dispatchGroup = DispatchGroup()
            
            for (key, dict) in savedReminders {
                guard let title = dict["title"] as? String,
                      let startDate = dict["startDate"] as? TimeInterval,
                      let movieId = Int(key) else { continue }

                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .short
                let date = dateFormatter.string(from: Date(timeIntervalSince1970: startDate))
                
                let reminderDate = Date(timeIntervalSince1970: startDate)
                let remainingTime = calculateRemainingTime(from: reminderDate)
                
                dispatchGroup.enter()
                TMDBService().fetchMovieById(movieId: movieId) { result in
                    var posterURL: String?
                    var genresString: String = ""
                    switch result {
                    case .success(let movie):
                        posterURL = movie.posterPath != nil ? "https://image.tmdb.org/t/p/w200\(movie.posterPath!)" : nil
                        genresString = movie.genres?.map { $0.name }.joined(separator: " / ") ?? ""
                    case .failure(let error):
                        print("Failed to fetch movie: \(error.localizedDescription)")
                    }
                    tempReminders.append((title: title, date: date, movieId: movieId, posterURL: posterURL, genres: genresString, remainingTime: remainingTime))
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.reminders = tempReminders
            }
        }
    }

    private func calculateRemainingTime(from reminderDate: Date) -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let components = calendar.dateComponents([.day, .hour], from: currentDate, to: reminderDate)
        
        if let days = components.day, days > 0 {
            return "\(days) Days"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) Hours"
        } else {
            return "Due Now"
        }
    }
}
