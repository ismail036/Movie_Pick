//
//  ContentView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.mainColor1)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        ZStack {
            Color.mainColor1
                .ignoresSafeArea()
            
            TabView {
                MovieView()
                    .tabItem { Image(systemName: "list.bullet") }
            }
            .background(Color.mainColor1)
            .ignoresSafeArea(edges: .bottom) 
        }
    }
}

#Preview {
    ContentView()
}
