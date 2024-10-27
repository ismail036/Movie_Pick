//
//  SearchView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 26.10.2024.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""

    var body: some View {
            VStack(alignment: .leading) {
                Text("Search")
                    .foregroundStyle(Color.white)
                    .font(.title)
                    .padding(.horizontal,10)
                
                Text("Find Movies, TV Shows, and Celebrities ")
                    .foregroundStyle(Color.white)
                    .font(.subheadline)
                    .padding(.horizontal,10)
                
                
                HStack {
                    TextField("Search", text: $searchText)
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color.mainColor3)
                        .foregroundStyle(Color.cyanBlue)
                        .cornerRadius(8)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 8)
                                
                                if !searchText.isEmpty {
                                    Button(action: {
                                        self.searchText = ""
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 8)
                                    }
                                }
                            }
                        )
                        .padding(.horizontal, 10)
                }
                .padding(0)
                
                if searchText.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("Trending Content")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.top, 10)
                                .foregroundColor(.white)
                            
                            ScrollView(.horizontal) {
                                HStack {
                                    VerticalMovieCard(
                                        selectedDestination: .movieDetail,
                                        movieId: 1232454
                                    )
                                    
                                    VerticalMovieCard(
                                        selectedDestination: .movieDetail,
                                        movieId: 1232454
                                    )
                                    
                                    VerticalMovieCard(
                                        selectedDestination: .movieDetail,
                                        movieId: 1232454
                                    )
                                    VerticalMovieCard(
                                        selectedDestination: .movieDetail,
                                        movieId: 1232454
                                    )
                                }
                            }
                            
                            Text("Trending People")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.top, 10)
                                .foregroundColor(.white)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    VerticalPeopleCardView(
                                        name: "Tom Holland",
                                        peopleCard: "tom_holand",
                                        scale: 1
                                    )
                                    
                                    VerticalPeopleCardView(
                                        name: "Jason Statham",
                                        peopleCard: "jason",
                                        scale: 1
                                    )
                                    
                                    VerticalPeopleCardView(
                                        name: "Margot Robbie",
                                        peopleCard: "margot",
                                        scale: 1
                                    )
                                }
                                .padding(.horizontal, 10)
                            }
                            
                            Spacer()
                        }
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("Search Results for '\(searchText)'")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.top, 10)
                                .foregroundColor(.white)
                            
                            ForEach(seacrhResults.filter { $0.title.contains(searchText) }, id: \.id) { movie in
                                MovieResultCard(movie: movie)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                }
            }
            .background(Color.mainColor1)
            .frame(maxWidth: .infinity)
            .frame(height: .infinity)
            .padding(0)
            .toolbarBackground(Color.mainColor1, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .leading)
            .navigationBarBackButtonHidden(true)


        }
}

struct MovieResultCard: View {
    var movie: Movie

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: movie.imageLink)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 120)
                    .cornerRadius(8)
            } placeholder: {
                ProgressView()
                    .frame(width: 80, height: 120)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(movie.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(movie.year)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.mainColor1)
        .cornerRadius(8)
    }
}

// Sample Data for Movies and People
struct Movie {
    let id = UUID()
    let title: String
    let subtitle: String
    let year: String
    let imageLink: String
}

struct Person {
    let id = UUID()
    let name: String
    let imageName: String
}

let seacrhResults = [
    Movie(title: "The Wild Robot", subtitle: "Animation / Action & adventure", year: "September 12, 2024", imageLink: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKBpWaSodHdVc9lTwZmkh4KLbknQcx4G--GQ&s"),
    Movie(title: "The Substance", subtitle: "Horror / Drama / Science Fiction", year: "September 7, 2024", imageLink: "https://upload.wikimedia.org/wikipedia/tr/thumb/f/f5/The_Substance_afişi.jpg/220px-The_Substance_afişi.jpg"),
    Movie(title: "Top of the Pops", subtitle: "Reality", year: "January 1, 1964", imageLink: "https://s3-alpha-sig.figma.com/img/deb0/2cdf/d830a35e822c5be59b86d88c297dbef7?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=HX~xAajyl5o698n8yIvnH6OQOUxZ~iLxALo9Q17vuWrIHi9ykbhvaz~hmA0a0JFO2k7Tw8M5ZqxiezGaaBo2BocG8-bg6mihVuD9cwrHQCpJ6TNe-OFtTPBAT9774mTlngViBy9CMui1t4UiJaiaxT9c21eLzbccWoQLw0efrZJCX6ylm7GTgMhlr9N6nSIsmcITFwvfLxYGaiDOFyy7XnkcremCsipFJnu0Pg1oZQIxnlQudr7t11tnk9~CouIBZiqNz9~dqo1-Z8I91yNHeKFcw9bLsAu6LMsWT7ZqyzzhALCiIIFgupEPOcpj-4k7PremssTUSKN7Tn2ZfGXBig__")
]

#Preview {
    SearchView()
}
