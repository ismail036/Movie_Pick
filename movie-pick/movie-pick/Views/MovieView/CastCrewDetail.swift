//
//  CastCrewDetail.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct CastCrewDetail: View {
    @Environment(\.presentationMode) var presentationMode
    
    let movieId: Int
    
    @State private var selectedTab = 0
    @State private var castMembers: [MovieCastMember] = []
    @State private var crewMembers: [MovieCrewMember] = []

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                TabButton(title: "Cast", isSelected: selectedTab == 0, fontSize: 20)
                    .onTapGesture {
                        selectedTab = 0
                    }
                    .padding(.horizontal, 16)
                
                TabButton(title: "Crew", isSelected: selectedTab == 1, fontSize: 20)
                    .onTapGesture {
                        selectedTab = 1
                    }
                    .padding(.horizontal, 16)
            }
            .padding(.top)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    if selectedTab == 0 {
                        ForEach(castMembers) { member in
                            PopularPeopleCard(
                                imageUrl: member.profileURL,
                                name: member.name,
                                desc: member.character ?? "Unknown Role"
                            )
                        }
                    } else if selectedTab == 1 {
                        // Crew List
                        ForEach(crewMembers) { member in
                            PopularPeopleCard(
                                imageUrl: member.profileURL, 
                                name: member.name,
                                desc: member.job ?? "Unknown Job"
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 10)
            .background(Color.mainColor1)
            .onAppear(perform: fetchMovieCredits)

            Spacer()
        }
        .background(Color.mainColor1.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Cast and Crew")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
    }
    
    private func fetchMovieCredits() {
        TMDBService().fetchMovieDetails(movieId: movieId) { result in
            switch result {
            case .success(let movieDetail):
                DispatchQueue.main.async {
                    self.castMembers = movieDetail.credits?.cast ?? []
                    self.crewMembers = movieDetail.credits?.crew ?? []
                }
            case .failure(let error):
                print("Failed to fetch movie credits: \(error.localizedDescription)")
            }
        }
    }
}



#Preview {
    CastCrewDetail(movieId: 1184918)
}
