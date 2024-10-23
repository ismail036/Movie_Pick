//
//  CastCrewSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct CastMember: Identifiable {
    let id = UUID()
    let imageName: String
    let actorName: String
    let characterName: String
}

struct CastCrewSection: View {
    @State private var selectedTab: String = "Cast"
    
    let castMembers = [
        CastMember(imageName: "tom_holand", actorName: "Tom Holland", characterName: "Dr. Ilene Andre..."),
        CastMember(imageName: "anne_hathaway", actorName: "Anne Hathaway", characterName: "Bernie Hayes..."),
        CastMember(imageName: "jesse", actorName: "Jesse Eisenberg", characterName: "Trapper"),
        CastMember(imageName: "tom_holand", actorName: "Tom Holland", characterName: "Dr. Ilene Andre...")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    selectedTab = "Cast"
                }) {
                    Text("Cast")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(selectedTab == "Cast" ? .white : .gray) // Seçiliyse beyaz, değilse gri
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
                        .foregroundColor(selectedTab == "Crew" ? .white : .gray) // Seçiliyse beyaz, değilse gri
                }
                
                Spacer()
                
                NavigationLink(destination: CastCrewDetail()){
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
                    ForEach(castMembers) { member in
                        VStack(alignment: .center) {
                            ZStack(alignment: .bottom) {
                                Image(member.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 150)
                                    .cornerRadius(8)
                                    .clipped()
                                
                                
                                VStack(alignment: .center) {
                                    Text(member.actorName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 15)
                                        .multilineTextAlignment(.center) // Metni ortalayan ayar
                                        .cornerRadius(4)
                                        .padding(.bottom, 5)
                                }

                                
                            }
                            
                            Text(member.characterName)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 120)
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.mainColor1)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CastCrewSection()
}
