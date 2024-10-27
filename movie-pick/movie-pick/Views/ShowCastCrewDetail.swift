//
//  ShowCastCrewDetail.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI

struct ShowCastCrewDetail: View {
    @Environment(\.presentationMode) var presentationMode
    
    let showId: Int
    
    @State private var selectedTab = 0
    @State private var castMembers: [TVCastMember] = []
    @State private var crewMembers: [TVCrewMember] = []

    var body: some View {
        VStack {
            // Tab bar
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
            
            // Content based on selected tab
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    if selectedTab == 0 {
                        // Cast List
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
            .onAppear(perform: fetchShowCredits)

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
    
    private func fetchShowCredits() {
        TMDBService().fetchShowDetails(showId: showId) { result in
            switch result {
            case .success(let showDetail):
                DispatchQueue.main.async {
                    self.castMembers = showDetail.credits?.cast ?? []
                    self.crewMembers = showDetail.credits?.crew ?? []
                }
            case .failure(let error):
                print("Failed to fetch show credits: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ShowCastCrewDetail(showId: 1396) // Breaking Bad ID örneği
}
