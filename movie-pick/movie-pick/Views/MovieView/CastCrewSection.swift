//
//  CastCrewSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct CastCrewSection: View {
    @State private var selectedTab: String = "Cast"
    @State private var credits: Credits?
    @State private var castMembers: [MovieCastMember] = []
    @State private var crewMembers: [MovieCrewMember] = []
    
    let movieId: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    selectedTab = "Cast"
                }) {
                    Text("Cast")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(selectedTab == "Cast" ? .white : .gray)
                }
                
                Text("|")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 4)
                    .foregroundColor(.white)
                
                Button(action: {
                    selectedTab = "Crew"
                }) {
                    Text("Crew")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(selectedTab == "Crew" ? .white : .gray)
                }
                
                Spacer()
                
                NavigationLink(destination: CastCrewDetail(movieId: movieId)) {
                    HStack {
                        Text("View More")
                        Image(systemName: "chevron.right")
                    }
                }
                .foregroundColor(.blue)
                .navigationBarBackButtonHidden(true)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    if selectedTab == "Cast" {
                        ForEach(castMembers) { member in
                            VStack(alignment: .center) {
                                ZStack(alignment: .bottom) {
                                    if let profileURL = member.profileURL {
                                        AsyncImage(url: profileURL) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 120, height: 150)
                                                .cornerRadius(8)
                                        } placeholder: {
                                            Color.gray
                                                .frame(width: 120, height: 150)
                                                .cornerRadius(8)
                                        }
                                    } else {
                                        Color.gray
                                            .frame(width: 120, height: 150)
                                            .cornerRadius(8)
                                    }
                                    
                                    VStack(alignment: .center) {
                                        Text(member.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 15)
                                            .multilineTextAlignment(.center)
                                            .cornerRadius(4)
                                            .padding(.bottom, 5)
                                    }
                                }
                                
                                Text(member.character ?? "Unknown")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 120)
                        }
                    } else {
                        ForEach(crewMembers) { member in
                            VStack(alignment: .center) {
                                ZStack(alignment: .bottom) {
                                    if let profileURL = member.profileURL {
                                        AsyncImage(url: profileURL) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 120, height: 150)
                                                .cornerRadius(8)
                                        } placeholder: {
                                            Color.gray
                                                .frame(width: 120, height: 150)
                                                .cornerRadius(8)
                                        }
                                    } else {
                                        Color.gray
                                            .frame(width: 120, height: 150)
                                            .cornerRadius(8)
                                    }
                                    
                                    VStack(alignment: .center) {
                                        Text(member.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 15)
                                            .multilineTextAlignment(.center)
                                            .cornerRadius(4)
                                            .padding(.bottom, 5)
                                    }
                                }
                                
                                Text(member.job ?? "Unknown")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 120)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.mainColor1)
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: fetchMovieDetails)
    }
    
    private func fetchMovieDetails() {
        TMDBService().fetchMovieDetails(movieId: movieId) { result in
            switch result {
            case .success(let movieDetail):
                DispatchQueue.main.async {
                    self.credits = movieDetail.credits
                    self.castMembers = self.credits?.cast ?? []
                    self.crewMembers = self.credits?.crew ?? []
                }
            case .failure(let error):
                print("Failed to fetch movie details: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    CastCrewSection(movieId: 1184918)
}
