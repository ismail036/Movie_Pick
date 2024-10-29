//
//  SplashView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        ZStack {
            Color.mainColor1.edgesIgnoringSafeArea(.all)
            
            if isActive {
                if isFirstLaunch {
                    OnboardingView(isFirstLaunch: $isFirstLaunch)
                } else {
                    ContentView()
                }
            } else {
                VStack {
                    Image("splashIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                }
                .transition(.scale)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView(isFirstLaunch: .constant(true))
}
