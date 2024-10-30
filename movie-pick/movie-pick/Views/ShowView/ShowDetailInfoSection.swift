//
//  ShowDetailInfoSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 27.10.2024.
//

import SwiftUI
import EventKit
import EventKitUI

struct ShowDetailInfoSection: View {
    var showId: Int
    @State  var title: String = ""
    @State  var genres: [String] = []
    @State  var voteAverage: Double = 0.0
    @State  var voteCount: Int = 0
    @State  var episodeRunTime: Int = 0
    @State  var firstAirDate: String = ""
    @State  var isBookmarked: Bool = false
    @State  var showSettingsAlert = false
    @State  var showEventEditView = false
    @State  var isReminded: Bool = false
    private var eventStore = EKEventStore()
    @State private var showPopup = false // Popup state

    init(showId:Int){
        self.showId = showId
    }

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
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 10)
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                        showPopup = true
                                    }
                            }
                            .padding(10)
                            .background(Color.gray.opacity(0.2)) // Replace with Color.mainColor3 if defined
                            .cornerRadius(40)
                            .padding(.horizontal)
                        }
                        .sheet(isPresented: $showPopup) {
                            ShowPopupView(showId: showId)
                                .background(Color.mainColor1.edgesIgnoringSafeArea(.all))
                                .presentationDetents([.fraction(0.5)])
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
                            message: Text("Hatırlatıcıya erişim izni vermeniz gerekiyor. Lütfen Ayarlar'dan izin verin."),
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

                        Text(firstAirDate)
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .bold()
                            .minimumScaleFactor(0.5)
                    }
                    .frame(width: geometry.size.width * 0.25, height: 30, alignment: .trailing)
                }
                .padding(.horizontal, 100)
                .frame(width: geometry.size.width)
            }
            .frame(height: 40)
            .onAppear {
                fetchShowDetails()
                checkIfBookmarked()
                checkIfReminded()
            }
        }
        .background(Color.black)
        .sheet(isPresented: $showEventEditView) {
            ShowEventEditView(eventStore: eventStore, showId: showId, title: title) { title, showId, startDate in
                saveReminderToUserDefaults(title: title, showId: showId, startDate: startDate)
            }
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
        if let data = userDefaults.data(forKey: "showReminders"),
           let reminders = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: Any]],
           let reminderData = reminders[String(showId)],
           let startDateTimeInterval = reminderData["startDate"] as? TimeInterval {
            isReminded = true
            let startDate = Date(timeIntervalSince1970: startDateTimeInterval)
            print("Reminder exists for Show ID \(showId): \(reminderData), Start Date: \(startDate)")
        }
    }
    
    private func saveReminderToUserDefaults(title: String, showId: Int, startDate: Date) {
        let userDefaults = UserDefaults.standard
        let reminderInfo: [String: Any] = [
            "title": title,
            "startDate": startDate.timeIntervalSince1970
        ]

        var reminders = userDefaults.data(forKey: "showReminders") != nil ?
            (try? JSONSerialization.jsonObject(with: userDefaults.data(forKey: "showReminders")!, options: []) as? [String: [String: Any]]) ?? [:] : [:]
        
        reminders[String(showId)] = reminderInfo

        if let jsonData = try? JSONSerialization.data(withJSONObject: reminders, options: []) {
            userDefaults.set(jsonData, forKey: "showReminders")
        }

        isReminded = true
        print("Reminder saved for Show ID \(showId): \(reminderInfo)")
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

struct ShowEventEditView: UIViewControllerRepresentable {
    let eventStore: EKEventStore
    let showId: Int
    let title: String
    var onReminderAdded: (String, Int, Date) -> Void

    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let eventEditVC = EKEventEditViewController()
        eventEditVC.eventStore = eventStore
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = Date()
        event.endDate = Date().addingTimeInterval(3600)
        event.notes = "Show: \(title)"
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
        var parent: ShowEventEditView

        init(_ parent: ShowEventEditView) {
            self.parent = parent
        }

        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            if action == .saved {
                let title = parent.title
                let showId = parent.showId
                let startDate = controller.event?.startDate ?? Date()
                parent.onReminderAdded(title, showId, startDate)
            }
            controller.dismiss(animated: true)
        }
    }
}

#Preview {
    ShowDetailInfoSection(showId: 1412)
}

extension TMDBService {
    func fetchProvidersForShow(showId: Int, completion: @escaping (Result<[Provider], Error>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/\(showId)/watch/providers") else { return }
        
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
                        
                        if let flatrateProviders = regionProviders["flatrate"] as? [[String: Any]] {
                            let flatrate = flatrateProviders.compactMap { Provider(dictionary: $0, category: "flatrate") }
                            providers.append(contentsOf: flatrate)
                        }
                        
                        if let rentProviders = regionProviders["rent"] as? [[String: Any]] {
                            let rent = rentProviders.compactMap { Provider(dictionary: $0, category: "rent") }
                            providers.append(contentsOf: rent)
                        }
                        
                        if let buyProviders = regionProviders["buy"] as? [[String: Any]] {
                            let buy = buyProviders.compactMap { Provider(dictionary: $0, category: "buy") }
                            providers.append(contentsOf: buy)
                        }
                    }
                }
                
                let uniqueProviders = Array(Set(providers))
                completion(.success(uniqueProviders))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

import SwiftUI

struct ShowPopupView: View {
    @State private var providers: [Provider] = []
    @State private var selectedCategory: String = "Stream"
    let showId: Int
    @Environment(\.presentationMode) var presentationMode // Popup kapatma için

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: 40, height: 5)
                    .padding(0)
                Spacer()
            }
            .padding(.bottom, 1)

            HStack {
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Popup'ı kapatır
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
        .cornerRadius(20)
        .onAppear {
            fetchProviders()
        }
    }
    
    private func categoryButton(title: String, count: Int) -> some View {
        Button(action: {
            selectedCategory = title
        }) {
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
        TMDBService().fetchProvidersForShow(showId: showId) { result in
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
