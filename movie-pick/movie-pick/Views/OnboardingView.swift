//
//  OnboardingView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isFirstLaunch: Bool
    @State private var showCategorySelection = false
    @State private var selectedOptions: Set<String> = []

    let options = [
        ("Movies", "movie"),
        ("TV Show", "show")
    ]
    
    var body: some View {
        ZStack {
            Color.mainColor1.edgesIgnoringSafeArea(.all)

            VStack {
                Text("Pick What You'd Like To Watch")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)

                ForEach(options, id: \.0) { option in
                    OptionCard(title: option.0, imageName: option.1, isSelected: selectedOptions.contains(option.0)) {
                        toggleOption(option.0)
                    }
                }
                
                Button(action: {
                    showCategorySelection = true
                }) {
                    Text("Next")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedOptions.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }
                .disabled(selectedOptions.isEmpty)
                .fullScreenCover(isPresented: $showCategorySelection) {
                    CategorySelectionView(isFirstLaunch: $isFirstLaunch)
                }
            }
        }
    }
    
    private func toggleOption(_ option: String) {
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            selectedOptions.insert(option)
        }
    }
}

struct OptionCard: View {
    let title: String
    let imageName: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .cornerRadius(12)
                .overlay(
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
                        .padding(.bottom, 16),
                    alignment: .bottom
                )
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .padding(10)
            }
        }
        .padding(.horizontal, 16)
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    OnboardingView(isFirstLaunch: .constant(true))
}
