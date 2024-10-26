//
//  MovieDetail.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct MovieDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = 0
    @State private var isSticky = false
    let stickyThreshold = UIScreen.main.bounds.height * 0.35
    let movie: MovieModel 

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if let backdropURL = movie.backdropURL {
                    AsyncImage(url: backdropURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: UIScreen.main.bounds.height * 0.25)
                            .clipped()
                            .edgesIgnoringSafeArea(.top)
                    } placeholder: {
                        Color.gray
                            .frame(height: UIScreen.main.bounds.height * 0.25)
                            .clipped()
                            .edgesIgnoringSafeArea(.top)
                    }
                }

                VStack {
                    Spacer()

                    HStack(alignment: .center) {
                        if let posterURL = movie.posterURL {
                            AsyncImage(url: posterURL) { image in
                                image
                                    .resizable()
                                    .frame(width: 120, height: 180)
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                                    .offset(y: 40)
                                    .padding(.horizontal, 16)
                            } placeholder: {
                                Color.gray
                                    .frame(width: 120, height: 180)
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                                    .offset(y: 40)
                                    .padding(.horizontal, 16)
                            }
                        }

                        Spacer()

                        Button(action: {}) {
                            Image("movie_icon")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .shadow(radius: 5)
                        }
                        .offset(y: 50)
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 10)
            }
            .frame(height: UIScreen.main.bounds.height * 0.30)

            Rectangle()
                .frame(width: 0, height: 35)

            ScrollView {
                VStack(spacing: 20) {
                    // Movie Detail Info Section
                    MovieDetailInfoSection(movie: self.movie) // Movie detayları burada gösteriliyor

                    GeometryReader { geo in
                        let offset = geo.frame(in: .global).minY
                        Color.clear
                            .onAppear {
                                self.isSticky = offset <= stickyThreshold
                            }
                            .onChange(of: offset) { newValue in
                                self.isSticky = newValue <= stickyThreshold
                            }
                    }
                    .frame(height: 0)
                    
                    if !isSticky {
                        TabButtonsView(selectedTab: $selectedTab)
                            .frame(maxWidth: .infinity)
                            .background(Color.mainColor1)
                    }
                    
                    if selectedTab == 0 {
                        OverviewTab(movieID: movie.id,movieModel:self.movie)
                    } else if selectedTab == 1 {
                        PhotosAndVideosTab(movieId: movie.id)
                    } else {
                        ReviewsTab(movieId: movie.id)
                    }

                    Spacer()
                }
            }
            .overlay(
                VStack {
                    if isSticky {
                        TabButtonsView(selectedTab: $selectedTab)
                            .frame(maxWidth: .infinity)
                            .background(Color.mainColor1)
                            .padding(.top, 0)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .animation(.easeInOut, value: isSticky)
            )

            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 26, height: 26)
                        .foregroundColor(.white)
                }
            }
        }
        .toolbarBackground(Color.clear, for: .navigationBar)
        .edgesIgnoringSafeArea(.top)
        .background(Color.mainColor1)
    }
}
// Sticky TabButtons Bileşeni
struct TabButtonsView: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack(spacing: 0) {
            TabButton(title: "Overview", isSelected: selectedTab == 0, fontSize: 16)
                .onTapGesture {
                    selectedTab = 0
                }
                .frame(maxWidth: .infinity)
            TabButton(title: "Photos and Videos", isSelected: selectedTab == 1, fontSize: 16)
                .onTapGesture {
                    selectedTab = 1
                }
                .frame(maxWidth: .infinity)

            TabButton(title: "Reviews", isSelected: selectedTab == 2, fontSize: 16)
                .onTapGesture {
                    selectedTab = 2
                }
                .frame(maxWidth: .infinity) 
        }
        .padding(.vertical, 10)
        .background(Color.mainColor1)
    }
}

// TabButton Bileşeni
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let fontSize: Int

    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: CGFloat(fontSize)))
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .blue : .gray)
                .padding(.bottom, 4)
                .frame(maxWidth: .infinity, alignment: .center)

            Rectangle()
                .frame(height: 2)
                .foregroundColor(isSelected ? Color.blue : Color.clear)
        }
        .animation(.easeInOut, value: isSelected)
        .padding(.top, 3)
        .padding(.horizontal, 10)
        .fixedSize(horizontal: true, vertical: false)
    }
}

#Preview {
        MovieDetail(movie: MovieModel(id: 1184918, title: "The Wild Robot", originalTitle: Optional("The Wild Robot"), overview: "After a shipwreck, an intelligent robot called Roz is stranded on an uninhabited island. To survive the harsh environment, Roz bonds with the island\'s animals and cares for an orphaned baby goose.", posterPath: Optional("/wTnV3PCVW5O92JMrFvvrRcV39RU.jpg"), backdropPath: Optional("/417tYZ4XUyJrtyZXj7HpvWf1E8f.jpg"), releaseDate: Optional("2024-09-12"), runtime: nil, voteAverage: Optional(8.641), voteCount: Optional(1514), genreIds: Optional([16, 878, 10751]), genres: nil, popularity: Optional(5400.805), originalLanguage: Optional("en"), adult: Optional(false), budget: nil, revenue: nil, tagline: nil, homepage: nil, status: nil))

}
