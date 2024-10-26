//
//  ShowDetail.swift
//  movie-pick
//
//  Created by İsmail Parlak on 24.10.2024.
//

import SwiftUI

struct ShowDetail: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = 0
    @State private var isSticky = false
    let stickyThreshold = UIScreen.main.bounds.height * 0.35

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // Background Image from URL
                AsyncImage(url: URL(string: "https://s3-alpha-sig.figma.com/img/6f95/8357/949e996437e93aed145c0a1d23b87f3b?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=FfkKv4wFvrtHllImfMUrVl-EhD3WI8bfsHzYEyyS9WWRl~k0DA6Grp77Y47CBsmErN1OIdAq1Pttt3D7ZzCq0stpRqdHTz3buPZ-IVrlUFITwjXo~w50qpQtwUkKk4t~AU9Ot0KF3gIrEw5kniPK7b81NcFVap2Qnyg0os00tsJQxgHoFpLEaoGQe7B-XBpn2ET8E28BbwJLIy5nyJwWLl~Wf2B2jOqG0zH7PkJL5381th4Ovz5v~Qk9EAz6TUVR-rEbQdcAlryNJED4z0BE~I1IvAt2tzYEBPrx2nxeizgkBuB1-k3Mguo-WqMWusyT~mY25LfDZmblaqol-TOGAg__")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: UIScreen.main.bounds.height * 0.25)
                        .clipped()
                        .edgesIgnoringSafeArea(.top)
                } placeholder: {
                    Color.gray
                        .frame(height: UIScreen.main.bounds.height * 0.25) // Placeholder
                }

                VStack {
                    Spacer()

                    HStack(alignment: .center) {
                        // Poster Image from URL
                        Image("img1")
                                .resizable()
                                .frame(width: 120, height: 180)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                                .offset(y: 40)
                                .padding(.horizontal, 16)
                        

                        Spacer()

                        // Button Icon Image from URL
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
                    MovieDetailInfoSection(movie: MovieModel(
                        id: 1184918, title: "The Wild Robot", originalTitle: Optional("The Wild Robot"), overview: "After a shipwreck, an intelligent robot called Roz is stranded on an uninhabited island. To survive the harsh environment, Roz bonds with the island\'s animals and cares for an orphaned baby goose.", posterPath: Optional("/wTnV3PCVW5O92JMrFvvrRcV39RU.jpg"), backdropPath: Optional("/417tYZ4XUyJrtyZXj7HpvWf1E8f.jpg"), releaseDate: Optional("2024-09-12"), runtime: nil, voteAverage: Optional(8.641), voteCount: Optional(1514), genreIds: Optional([16, 878, 10751]), genres: nil, popularity: Optional(5400.805), originalLanguage: Optional("en"), adult: Optional(false), budget: nil, revenue: nil, tagline: nil, homepage: nil, status: nil
                    ))

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
                        ShowTabButtonsView(selectedTab: $selectedTab)
                            .frame(maxWidth: .infinity)
                            .background(Color.mainColor1)
                    }
                    
                    if selectedTab == 0 {
                        OverviewTab(movieID: 1184918)
                    } else if selectedTab == 1 {
                        SeasonsTab()
                    }else if selectedTab == 2 {
                        PhotosAndVideosTab()
                    }  else {
                        ReviewsTab()
                    }

                    Spacer()
                }
            }
            .overlay(
                VStack {
                    if isSticky {
                        ShowTabButtonsView(selectedTab: $selectedTab)
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
        .navigationBarBackButtonHidden(true)
    }
}


struct ShowTabButtonsView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabButton(title: "Overview", isSelected: selectedTab == 0, fontSize: 14)
                .onTapGesture {
                    selectedTab = 0
                }
                .frame(maxWidth: .infinity)
            TabButton(title: "Seasons", isSelected: selectedTab == 1, fontSize: 14)
                .onTapGesture {
                    selectedTab = 1
                }
                .frame(maxWidth: .infinity)
            TabButton(title: "Photos and Videos", isSelected: selectedTab == 2, fontSize: 14)
                .onTapGesture {
                    selectedTab = 2
                }
                .frame(maxWidth: .infinity)
            
            TabButton(title: "Reviews", isSelected: selectedTab == 3, fontSize: 14)
                .onTapGesture {
                    selectedTab = 3
                }
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 10)
        .background(Color.mainColor1)
    }
}


struct SeasonsTab: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Seasons")
                .font(.title2)
                .bold()

            Text("Episodes: 30 Episodes / 20 hr 11 min")
                .font(.subheadline)
                .foregroundColor(.gray)

            ScrollView {
                VStack(spacing: 10) {
                    NavigationLink(destination: SeasonDetailView(season: Season(seasonName: "Seasons 1", episodeCount: 10, duration: "8 hr 26 min", imageURL: "https://miro.medium.com/v2/resize:fit:1400/1*39M4XbHXCTfBenNNqLLyLA@2x.jpeg"))) {
                        SeasonRow(season: Season(seasonName: "Seasons 1", episodeCount: 10, duration: "8 hr 26 min", imageURL: "https://miro.medium.com/v2/resize:fit:1400/1*39M4XbHXCTfBenNNqLLyLA@2x.jpeg"))
                    }

                    NavigationLink(destination: SeasonDetailView(season: Season(seasonName: "Seasons 2", episodeCount: 10, duration: "8 hr 19 min", imageURL: "https://resizing.flixster.com/xyR4st6BC93nnWjN5fsfnLm_ncM=/fit-in/352x330/v2/https://resizing.flixster.com/-XZAfHZM39UwaGJIFWKAE8fS0ak=/v3/t/assets/p21200256_i_v13_aa.jpg"))) {
                        SeasonRow(season: Season(seasonName: "Seasons 2", episodeCount: 10, duration: "8 hr 19 min", imageURL: "https://resizing.flixster.com/xyR4st6BC93nnWjN5fsfnLm_ncM=/fit-in/352x330/v2/https://resizing.flixster.com/-XZAfHZM39UwaGJIFWKAE8fS0ak=/v3/t/assets/p21200256_i_v13_aa.jpg"))
                    }

                    NavigationLink(destination: SeasonDetailView(season: Season(seasonName: "Seasons 3", episodeCount: 10, duration: "3 hr 26 min", imageURL: "https://resizing.flixster.com/xyR4st6BC93nnWjN5fsfnLm_ncM=/fit-in/352x330/v2/https://resizing.flixster.com/-XZAfHZM39UwaGJIFWKAE8fS0ak=/v3/t/assets/p21200256_i_v13_aa.jpg"))) {
                        SeasonRow(season: Season(seasonName: "Seasons 3", episodeCount: 10, duration: "3 hr 26 min", imageURL: "https://resizing.flixster.com/xyR4st6BC93nnWjN5fsfnLm_ncM=/fit-in/352x330/v2/https://resizing.flixster.com/-XZAfHZM39UwaGJIFWKAE8fS0ak=/v3/t/assets/p21200256_i_v13_aa.jpg"))
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct SeasonRow: View {
    let season: Season

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: season.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 150)
                    .cornerRadius(10)
                    .clipped()
            } placeholder: {
                Color.gray
                    .frame(width: 100, height: 150)
                    .cornerRadius(10)
            }

            VStack(alignment: .leading) {
                Text(season.seasonName)
                    .font(.headline)

                Text("\(season.episodeCount) Episodes, \(season.duration)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 5)
    }
}

struct Episode: Identifiable {
    let id = UUID()
    let episodeNumber: Int
    let title: String
    let airDate: String
    let duration: String
    let description: String
    let thumbnailURL: String
}

struct EpisodeRow: View {
    let episode: Episode

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: episode.thumbnailURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 80)
                    .cornerRadius(10)
                    .clipped()
            } placeholder: {
                Color.gray
                    .frame(width: 100, height: 80)
                    .cornerRadius(10)
            }

            VStack(alignment: .leading) {
                Text("S01 : E\(episode.episodeNumber)")
                    .font(.headline)
                    .foregroundColor(.white)

                Text(episode.title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 5)
        .padding(.horizontal)
    }
}

struct SeasonDetailView: View {
    let season: Season
    let episodes: [Episode] = [
        Episode(episodeNumber: 1, title: "Long Day's Journey Into Night", airDate: "April 1, 2023", duration: "1 hr", description: "A thrilling start to the season with unexpected twists and turns.", thumbnailURL: "https://resizing.flixster.com/xyR4st6BC93nnWjN5fsfnLm_ncM=/fit-in/352x330/v2/https://resizing.flixster.com/-XZAfHZM39UwaGJIFWKAE8fS0ak=/v3/t/assets/p21200256_i_v13_aa.jpg"),
        Episode(episodeNumber: 2, title: "The Way Things Are Now", airDate: "April 8, 2023", duration: "1 hr", description: "Tensions rise as unexpected events unfold.", thumbnailURL: "https://resizing.flixster.com/xyR4st6BC93nnWjN5fsfnLm_ncM=/fit-in/352x330/v2/https://resizing.flixster.com/-XZAfHZM39UwaGJIFWKAE8fS0ak=/v3/t/assets/p21200256_i_v13_aa.jpg"),
        Episode(episodeNumber: 3, title: "Choosing Day", airDate: "April 15, 2023", duration: "1 hr", description: "Critical decisions change the course of events.", thumbnailURL: "https://resizing.flixster.com/xyR4st6BC93nnWjN5fsfnLm_ncM=/fit-in/352x330/v2/https://resizing.flixster.com/-XZAfHZM39UwaGJIFWKAE8fS0ak=/v3/t/assets/p21200256_i_v13_aa.jpg"),
        Episode(episodeNumber: 4, title: "A Rock and a Farway", airDate: "April 22, 2023", duration: "1 hr", description: "Survival becomes harder as resources dwindle.", thumbnailURL: "https://resizing.flixster.com/xyR4st6BC93nnWjN5fsfnLm_ncM=/fit-in/352x330/v2/https://resizing.flixster.com/-XZAfHZM39UwaGJIFWKAE8fS0ak=/v3/t/assets/p21200256_i_v13_aa.jpg"),
        Episode(episodeNumber: 5, title: "Silhouettes", airDate: "April 29, 2023", duration: "1 hr", description: "The enemy gets closer, and alliances are tested.", thumbnailURL: "https://resizing.flixster.com/xyR4st6BC93nnWjN5fsfnLm_ncM=/fit-in/352x330/v2/https://resizing.flixster.com/-XZAfHZM39UwaGJIFWKAE8fS0ak=/v3/t/assets/p21200256_i_v13_aa.jpg"),
        Episode(episodeNumber: 6, title: "Book 74", airDate: "May 6, 2023", duration: "1 hr", description: "The group's secrets are finally revealed.", thumbnailURL: "https://resizing.flixster.com/xyR4st6BC93nnWjN5fsfnLm_ncM=/fit-in/352x330/v2/https://resizing.flixster.com/-XZAfHZM39UwaGJIFWKAE8fS0ak=/v3/t/assets/p21200256_i_v13_aa.jpg"),
        Episode(episodeNumber: 7, title: "All Good Things", airDate: "May 13, 2023", duration: "1 hr", description: "The season ends with shocking revelations.", thumbnailURL: "https://resizing.flixster.com/xyR4st6BC93nnWjN5fsfnLm_ncM=/fit-in/352x330/v2/https://resizing.flixster.com/-XZAfHZM39UwaGJIFWKAE8fS0ak=/v3/t/assets/p21200256_i_v13_aa.jpg")
    ]
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView {
            ForEach(episodes) { episode in
                NavigationLink(destination: EpisodeDetailView(
                    episodeTitle: episode.title,
                    seasonNumber: 1,
                    episodeNumber: episode.episodeNumber,
                    episodeAirDate: episode.airDate,
                    episodeDuration: episode.duration,
                    episodeDescription: episode.description,
                    episodeThumbnailURL: episode.thumbnailURL)) {
                    EpisodeRow(episode: episode)
                }
            }
        }
        .navigationTitle(season.seasonName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .background(Color.black.ignoresSafeArea())
    }
    
    
    var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "arrow.backward.circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
        }
    }
}






struct Season: Identifiable {
    let id = UUID()
    let seasonName: String
    let episodeCount: Int
    let duration: String
    let imageURL: String
}




#Preview {
    ShowDetail()
}
