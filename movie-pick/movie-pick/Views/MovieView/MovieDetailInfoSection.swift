//
//  MovieDetailInfoSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI
import EventKit
import EventKitUI

struct MovieDetailInfoSection: View {
    let movie: MovieModel
    @State var title: String = ""
    @State var genres: [String] = []
    @State var voteAverage: Double = 0.0
    @State var voteCount: Int = 0
    @State var runtime: Int = 0
    @State var releaseDate: String = ""
    @State var isBookmarked: Bool = false
    @State var showSettingsAlert = false
    @State var showEventEditView = false
    @State var isReminded: Bool = false
    private var eventStore = EKEventStore()
    @State private var showPopup = false
    
    @State var showProviderPopup = false // Yeni popup için state

    private let tmdbService = TMDBService()
    
    init(movie: MovieModel) {
        self.movie = movie
    }

    var body: some View {
        VStack(spacing: 10) {
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
                    Image(systemName: "chevron.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10)
                        .foregroundColor(.gray)
                }
                .padding(10)
                .background(Color.gray.opacity(0.2)) // Replace with Color.mainColor3 if defined
                .cornerRadius(40)
                .padding(.horizontal)
                .onTapGesture {
                    showPopup = true
                }
            }
            .sheet(isPresented: $showPopup) {
                PopupView(movieId: movie.id)
                    .background(Color.mainColor1.edgesIgnoringSafeArea(.all))
                    .presentationDetents([.fraction(0.5)])
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundStyle(Color.white)
                        .font(.title)
                        .bold()
                        .padding(.bottom, 2)

                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        requestReminderAccess()
                    }) {
                        VStack {
                            Image(systemName: isReminded ? "bell.fill" : "bell")
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
                    .alert(isPresented: $showSettingsAlert) {
                        Alert(
                            title: Text("Permission Needed"),
                            message: Text("You need to grant permission to access the reminder. Please grant permission from Settings."),
                            primaryButton: .default(Text("Ayarlar"), action: {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            }),
                            secondaryButton: .cancel(Text("İptal"))
                        )
                    }
                    
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
            
            HStack(alignment: .center) {
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
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.bottom,5)

            GeometryReader { geometry in
                HStack(spacing: 10) {
                    HStack {
                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                            .foregroundColor(.white)
                        Text(String(format: "%.1f", voteAverage))
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .minimumScaleFactor(0.5)
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 1, height: 18)
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 14, height: 14)
                            .foregroundColor(.white)
                        Text("\(voteCount)")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .minimumScaleFactor(0.5)
                    }
                    .frame(width: geometry.size.width * 0.33, height: 30)
                    .background(Color.green)
                    .cornerRadius(16)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
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
                    
                    VStack {
                        Text("Release Date")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .bold()
                            .minimumScaleFactor(0.5)
                            .padding(.trailing, 12)
                        Text(releaseDate)
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .bold()
                            .minimumScaleFactor(0.5)
                            .padding(.trailing, 12)
                    }
                    .frame(width: geometry.size.width * 0.3, height: 30, alignment: .trailing)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 14)
                .frame(width: geometry.size.width)
            }
            .frame(height: 33)
            .onAppear {
                fetchMovieDetails()
                checkIfBookmarked()
                checkIfReminded()
            }
        }
        .background(Color.mainColor1)
        .sheet(isPresented: $showEventEditView) {
            EventEditView(eventStore: eventStore, movie: movie) { title, movieId, startDate in
                saveReminderToUserDefaults(title: title, movieId: movieId, startDate: startDate)
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



    
    private func requestReminderAccess() {
        eventStore.requestAccess(to: .reminder) { granted, error in
            if let error = error {
                print("Error requesting access: \(error.localizedDescription)")
                return
            }
            
            if granted {
                DispatchQueue.main.async {
                    self.showEventEditView = true
                }
            } else {
                DispatchQueue.main.async {
                    self.showSettingsAlert = true
                }
            }
        }
    }

    private func checkIfReminded() {
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.data(forKey: "reminders"),
           let reminders = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: Any]],
           let reminderData = reminders[String(movie.id)],
           let startDateTimeInterval = reminderData["startDate"] as? TimeInterval {
            isReminded = true
            let startDate = Date(timeIntervalSince1970: startDateTimeInterval)
            print("Reminder exists for Movie ID \(movie.id): \(reminderData), Start Date: \(startDate)")
        }
    }
    

    
    private func saveToFavorites() {
        var favoriteMovies = UserDefaults.standard.array(forKey: "favoriteMovieIds") as? [Int] ?? []
        favoriteMovies.append(movie.id)
        UserDefaults.standard.set(favoriteMovies, forKey: "favoriteMovieIds")
    }
    
    private func removeFromFavorites() {
        var favoriteMovies = UserDefaults.standard.array(forKey: "favoriteMovieIds") as? [Int] ?? []
        favoriteMovies.removeAll { $0 == movie.id }
        UserDefaults.standard.set(favoriteMovies, forKey: "favoriteMovieIds")
    }
    
    private func checkIfBookmarked() {
        let favoriteMovies = UserDefaults.standard.array(forKey: "favoriteMovieIds") as? [Int] ?? []
        isBookmarked = favoriteMovies.contains(movie.id)
    }

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
    
    private func saveReminderToUserDefaults(title: String, movieId: Int, startDate: Date) {
        let userDefaults = UserDefaults.standard
        let reminderInfo: [String: Any] = [
            "title": title,
            "startDate": startDate.timeIntervalSince1970
        ]

        var reminders = userDefaults.data(forKey: "reminders") != nil ?
            (try? JSONSerialization.jsonObject(with: userDefaults.data(forKey: "reminders")!, options: []) as? [String: [String: Any]]) ?? [:] : [:]
        
        reminders[String(movieId)] = reminderInfo

        if let jsonData = try? JSONSerialization.data(withJSONObject: reminders, options: []) {
            userDefaults.set(jsonData, forKey: "reminders")
        }

        isReminded = true
        print("Reminder saved for Movie ID \(movieId): \(reminderInfo)")
    }
}







struct EventEditView: UIViewControllerRepresentable {
    let eventStore: EKEventStore
    let movie: MovieModel
    var onReminderAdded: (String, Int, Date) -> Void

    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let eventEditVC = EKEventEditViewController()
        eventEditVC.eventStore = eventStore
        let event = EKEvent(eventStore: eventStore)
        event.title = movie.title
        event.startDate = Date()
        event.endDate = Date().addingTimeInterval(3600)
        event.notes = "Movie: \(movie.title)\nVotes: \(movie.voteAverage) of 10"
        event.calendar = eventStore.defaultCalendarForNewEvents
        eventEditVC.event = event
        eventEditVC.editViewDelegate = context.coordinator
        return eventEditVC
    }

    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: EventEditView

        init(_ parent: EventEditView) {
            self.parent = parent
        }

        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            if action == .saved {
                let title = parent.movie.title
                let movieId = parent.movie.id
                let startDate = controller.event?.startDate ?? Date()
                parent.onReminderAdded(title, movieId, startDate)
            }
            controller.dismiss(animated: true)
        }
    }
    
    

}






import SwiftUI


struct PopupView: View {
    let movieId: Int
    @State private var providers: [Provider] = []
    @State private var selectedCategory: String = "Stream"
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: 40, height: 5)
                Spacer()
            }
            .padding(.bottom, 1)

            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            
            Text("Where to Watch")
                .font(.headline)
                .padding(.top, 5)
                .foregroundStyle(Color.white)
            
            HStack(spacing: 10) {
                categoryButton(title: "Stream", count: providersCount(for: "flatrate"))
                categoryButton(title: "Rent", count: providersCount(for: "rent"))
                categoryButton(title: "Buy", count: providersCount(for: "buy"))
            }
            .padding(.vertical)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(filteredProviders, id: \.id) { provider in
                        VStack {
                            AsyncImage(url: URL(string: provider.logoPath)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                            VStack(spacing: 0) {
                                let words = provider.name.split(separator: " ")
                                if words.count > 2 {
                                    Text(words.prefix(2).joined(separator: " "))
                                        .font(.caption)
                                        .foregroundColor(.white)
                                    Text(words.dropFirst(2).joined(separator: " "))
                                        .font(.caption)
                                        .foregroundColor(.white)
                                } else {
                                    Text(provider.name)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            HStack {
                Text("Provided by")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Image("tmdb")
                
                Spacer()
                
                Text("Powered by")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Image("justWatch")
            }
            .padding(.top,20)
            
            Spacer()
        }
        .padding()
        .background(Color.mainColor3)
        .cornerRadius(10)
        .onAppear {
            fetchProviders()
        }
    }
    
    private func categoryButton(title: String, count: Int) -> some View {
        Button(action: { selectedCategory = title }) {
            HStack {
                Text(title)
                    .foregroundColor(selectedCategory == title ? .black : .gray)
                    .cornerRadius(15)
                Text("\(count)")
                    .foregroundColor(selectedCategory == title ? .black : .gray)
                    .cornerRadius(15)
            }
            .font(.subheadline)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(selectedCategory == title ? Color.white : Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white, lineWidth: 1)
            )
            .cornerRadius(12)
        }
    }

    private func providersCount(for category: String) -> Int {
        providers.filter { $0.category == category }.count
    }
    
    private var filteredProviders: [Provider] {
        providers.filter { provider in
            switch selectedCategory {
            case "Stream":
                return provider.category == "flatrate"
            case "Rent":
                return provider.category == "rent"
            case "Buy":
                return provider.category == "buy"
            default:
                return false
            }
        }
    }
    
    private func fetchProviders() {
        TMDBService().fetchProvidersForMovie(movieId: movieId) { result in
            switch result {
            case .success(let providers):
                DispatchQueue.main.async {
                    self.providers = providers
                }
            case .failure(let error):
                print("Failed to fetch providers: \(error.localizedDescription)")
            }
        }
    }
}


extension TMDBService {
    func fetchProvidersForMovie(movieId: Int, completion: @escaping (Result<[Provider], Error>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/watch/providers") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data is nil"])))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let results = json?["results"] as? [String: Any]
                
                var providers: [Provider] = []
                
                for (_, value) in results ?? [:] {
                    if let regionProviders = value as? [String: Any] {
                        // Stream, Rent, Buy providers ayrımı
                        if let flatrateProviders = regionProviders["flatrate"] as? [[String: Any]] {
                            providers.append(contentsOf: flatrateProviders.compactMap { Provider(dictionary: $0, category: "flatrate") })
                        }
                        if let rentProviders = regionProviders["rent"] as? [[String: Any]] {
                            providers.append(contentsOf: rentProviders.compactMap { Provider(dictionary: $0, category: "rent") })
                        }
                        if let buyProviders = regionProviders["buy"] as? [[String: Any]] {
                            providers.append(contentsOf: buyProviders.compactMap { Provider(dictionary: $0, category: "buy") })
                        }
                    }
                }

                // Benzersiz id'lere göre filtreleme
                let uniqueProviders = Array(
                    Dictionary(grouping: providers, by: { $0.id })
                        .compactMapValues { $0.first }
                        .values
                )
                
                completion(.success(uniqueProviders))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}



struct Provider: Identifiable, Hashable {
    let id: Int
    let name: String
    let logoPath: String
    let category: String
    
    init?(dictionary: [String: Any], category: String) {
        guard let id = dictionary["provider_id"] as? Int,
              let name = dictionary["provider_name"] as? String,
              let logoPath = dictionary["logo_path"] as? String else {
            return nil
        }
        self.id = id
        self.name = name
        self.logoPath = "https://image.tmdb.org/t/p/w500\(logoPath)"
        self.category = category
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Provider, rhs: Provider) -> Bool {
        return lhs.id == rhs.id
    }
}



#Preview {
    PopupView(movieId: 278)
}


#Preview {
    MovieDetailInfoSection(movie: MovieModel(
        id: 1184918, title: "The Wild Robot", originalTitle: Optional("The Wild Robot"),overview: "After a shipwreck, an intelligent robot called Roz is stranded on an uninhabited island. To survive the harsh environment, Roz bonds with the island's animals and cares for an orphaned baby goose.", posterPath: Optional("/wTnV3PCVW5O92JMrFvvrRcV39RU.jpg"), backdropPath: Optional("/417tYZ4XUyJrtyZXj7HpvWf1E8f.jpg"), releaseDate: Optional("2024-09-12"), runtime: nil, voteAverage: Optional(8.641), voteCount: Optional(1514), genreIds: Optional([16, 878, 10751]), genres: nil, popularity: Optional(5400.805), originalLanguage: Optional("en"), adult: Optional(false), budget: nil, revenue: nil, tagline: nil, homepage: nil, status: nil
    ))
}
