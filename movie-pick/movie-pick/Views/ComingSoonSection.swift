//
//  ComingSoonSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct ComingSoonSection: View {
    let categories = ["Action", "Adventure", "Animation", "Comedy", "Horror", "Sci-Fi"]
    @State private var visibleCategories: [String] = []
    @State private var remainingCategories: [String] = []
    
    @State private var showDropdown = false
    @State private var selectedTimeFrame = "Next 30 Days"

    var timeFrames = ["Next 24 Hours", "Next 30 Days", "Next 3 Months", "Next 12 Months"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Coming Soon")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()

                ZStack(alignment: .topTrailing) {
                    Button(action: {
                        withAnimation {
                            showDropdown.toggle()
                        }
                    }) {
                        HStack {
                            Text(selectedTimeFrame)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                            
                            Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(Color.blue)
                        .cornerRadius(25)
                    }

                    if showDropdown {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(timeFrames, id: \.self) { timeFrame in
                                Button(action: {
                                    selectedTimeFrame = timeFrame
                                    showDropdown = false
                                }) {
                                    HStack {
                                        Text(timeFrame)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        if selectedTimeFrame == timeFrame {
                                            Image(systemName: "circle.fill")
                                                .foregroundColor(.blue)
                                        } else {
                                            Image(systemName: "circle")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                                .frame(height: 44)
                            }
                        }
                        .background(Color.mainColor3)
                        .cornerRadius(12)
                        .frame(width: 200 , height: 0)
                        .shadow(radius: 5)
                        .offset(y: 140)
                        .zIndex(1)
                    }
                }
            }.zIndex(1)
            
            Text("Unveiling Soon: Anticipated Movie Releases")
                .font(.system(size: 12))
                .foregroundColor(Color.gray)
            
            GeometryReader { geometry in
                HStack {
                    ForEach(visibleCategories, id: \.self) { category in
                        CategoryButtonView(title: category)
                    }
                    
                    if !remainingCategories.isEmpty {
                        NavigationLink(destination: ComingSoonDetail()) {
                            CategoryButtonView(title: "More...")
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            print("NavigationLink to DiscoverDetail was tapped")
                        })
                    }
                }
                .onAppear {
                    calculateVisibleCategories(for: geometry.size.width)
                }
                .padding(.horizontal, 0)
            }
            .frame(height: 50)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    VerticalMovieCard(
                        movieTitle: "S.O.S. Bikini Bottom : Une mission pour Sandy Écureuil",
                        moviePoster: "bikini_bottom",
                        rating: 0,
                        releaseYear: "2024"
                    )
                    
                    VerticalMovieCard(
                        movieTitle: "Venom: The Last Dance",
                        moviePoster: "venom",
                        rating: 0,
                        releaseYear: "2024"
                    )
                    
                    VerticalMovieCard(
                        movieTitle: "Smile 2",
                        moviePoster: "smile",
                        rating: 0,
                        releaseYear: "2024"
                    )
                }
                .padding(.horizontal, 0)
                .padding(.vertical, 0)
            }
            .padding(.leading, 0)
        }
        .background(Color.mainColor1)
    }

    private func calculateVisibleCategories(for totalWidth: CGFloat) {
        var currentWidth: CGFloat = 0
        let buttonPadding: CGFloat = 16
        let moreButtonWidth: CGFloat = 80
        
        visibleCategories = []
        remainingCategories = []
        
        for category in categories {
            let buttonWidth = category.widthOfString(usingFont: .systemFont(ofSize: 14, weight: .bold)) + buttonPadding * 2
            
            if currentWidth + buttonWidth + moreButtonWidth <= totalWidth {
                visibleCategories.append(category)
                currentWidth += buttonWidth + buttonPadding
            } else {
                remainingCategories.append(category)
            }
        }
    }
}


#Preview {
    ComingSoonSection()
}
