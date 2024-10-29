//
//  movie_pickApp.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI
import SwiftData


@main
struct movie_pickApp: App {
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            SplashView(isFirstLaunch: $isFirstLaunch)
        }
        .modelContainer(sharedModelContainer)
    }
}
