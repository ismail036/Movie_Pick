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
            .frame(height: 40)
            .onAppear {
                fetchMovieDetails()
                checkIfBookmarked()
                checkIfReminded()
            }
        }
        .background(Color.black)
        .sheet(isPresented: $showEventEditView) {
            EventEditView(eventStore: eventStore, movie: movie) { title, movieId, startDate in
                saveReminderToUserDefaults(title: title, movieId: movieId, startDate: startDate)
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
        if let data = userDefaults.data(forKey: "reminders"),
           let reminders = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: Any]],
           let reminderData = reminders[String(movie.id)],
           let startDateTimeInterval = reminderData["startDate"] as? TimeInterval {
            isReminded = true
            let startDate = Date(timeIntervalSince1970: startDateTimeInterval)
            print("Reminder exists for Movie ID \(movie.id): \(reminderData), Start Date: \(startDate)")
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

#Preview {
    MovieDetailInfoSection(movie: MovieModel(
        id: 1184918, title: "The Wild Robot", originalTitle: Optional("The Wild Robot"),overview: "After a shipwreck, an intelligent robot called Roz is stranded on an uninhabited island. To survive the harsh environment, Roz bonds with the island's animals and cares for an orphaned baby goose.", posterPath: Optional("/wTnV3PCVW5O92JMrFvvrRcV39RU.jpg"), backdropPath: Optional("/417tYZ4XUyJrtyZXj7HpvWf1E8f.jpg"), releaseDate: Optional("2024-09-12"), runtime: nil, voteAverage: Optional(8.641), voteCount: Optional(1514), genreIds: Optional([16, 878, 10751]), genres: nil, popularity: Optional(5400.805), originalLanguage: Optional("en"), adult: Optional(false), budget: nil, revenue: nil, tagline: nil, homepage: nil, status: nil
    ))
}
