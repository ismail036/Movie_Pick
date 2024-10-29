import SwiftUI
import EventKit
import UserNotifications

struct ContentView: View {
    @State private var selectedTab = 0
    private let tmdbService = TMDBService()
    private var eventStore = EKEventStore()
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.mainColor1)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                MovieView()
            }
            .tabItem {
                VStack {
                    if selectedTab == 0 {
                        Image("movieSelectedIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Movies")
                    } else {
                        Image("MovieIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("")
                    }
                }
            }
            .tag(0)
            
            NavigationView {
                ShowView()
            }
            .tabItem {
                VStack {
                    if selectedTab == 1 {
                        Image("showSelectedIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Shows")
                    } else {
                        Image("showIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("")
                    }
                }
            }
            .tag(1)
            
            NavigationView {
                SearchView()
            }
            .tabItem {
                VStack {
                    if selectedTab == 2 {
                        Image("searchIconSelected")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Search")
                    } else {
                        Image("SearchIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("")
                    }
                }
            }
            .tag(2)
            
            NavigationView {
                LibraryView()
            }
            .tabItem {
                VStack {
                    if selectedTab == 3 {
                        Image("libraryIconSelected")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Library")
                    } else {
                        Image("libraryIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("")
                    }
                }
            }
            .tag(3)
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                VStack {
                    if selectedTab == 4 {
                        Image("settingsIconSelected")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Settings")
                    } else {
                        Image("settingsIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("")
                    }
                }
            }
            .tag(4)
        }
        .background(Color.mainColor1)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            fetchPermissions()
            fetchPopularMovies()
        }
    }
    
    private func fetchPermissions() {
        requestCalendarAccess()
        requestReminderAccess()
        requestNotificationAccess()
    }
    
    private func requestCalendarAccess() {
        eventStore.requestAccess(to: .event) { granted, error in
            if granted {
                print("Calendar access granted.")
            } else {
                print("Calendar access denied: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    private func requestReminderAccess() {
        eventStore.requestAccess(to: .reminder) { granted, error in
            if granted {
                print("Reminder access granted.")
            } else {
                print("Reminder access denied: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    private func requestNotificationAccess() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification access granted.")
            } else {
                print("Notification access denied: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    private func fetchPopularMovies() {
        tmdbService.fetchPopularMovies { result in
            switch result {
            case .success(let movies):
                print("Fetched popular movies:", movies)
            case .failure(let error):
                print("Error fetching popular movies:", error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
}
