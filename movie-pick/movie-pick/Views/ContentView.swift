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
            UITabBar.appearance().backgroundColor = UIColor(Color.mainColor1)
            UITabBar.appearance().isTranslucent = false
        }

    var body: some View {
        ZStack {
            
            Color.mainColor1
            
            TabView {
                MovieView()
                    .tabItem { Image(systemName: "list.bullet") }
                
            }
            .background(
                Color.mainColor1
            )
            .ignoresSafeArea(edges: [])
        } 
    }
    
}

#Preview {
    ContentView()
}
