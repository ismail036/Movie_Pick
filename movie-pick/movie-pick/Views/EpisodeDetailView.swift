//
//  EpisodeDetailView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 24.10.2024.
//

import SwiftUI

struct EpisodeDetailView: View {
    
    @State private var showFullText = false
    
    let episodeTitle: String
    let seasonNumber: Int
    let episodeNumber: Int
    let episodeAirDate: String
    let episodeDuration: String
    let episodeDescription: String
    let episodeThumbnailURL: String
    
    let description = """
    After a mysterious leader imposes his law in a brutal system of vertical cells, a new arrival battles against a dubious food distribution method. The system is designed in such a way that the top floors receive an abundance of food, while the lower floors struggle with starvation, causing people to fight for survival. The newcomer seeks a way to disrupt this dystopian order, while grappling with his own morality and the challenges of the brutal environment.
    """
    
    
    let castMembers = [
        CastMember(imageName: "tom_holand", actorName: "Tom Holland", characterName: "Dr. Ilene Andre..."),
        CastMember(imageName: "anne_hathaway", actorName: "Anne Hathaway", characterName: "Bernie Hayes..."),
        CastMember(imageName: "jesse", actorName: "Jesse Eisenberg", characterName: "Trapper"),
        CastMember(imageName: "tom_holand", actorName: "Tom Holland", characterName: "Dr. Ilene Andre...")
    ]
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        
        return GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    ZStack(alignment: .leading) {
                        Image(episodeThumbnailURL)
                        
                        
                        VStack(alignment: .center) {
                            Text("FROM")
                                .font(.system(size: 24))
                                .bold()
                                .foregroundColor(.white)
                                .padding([.top], 16)
                            Spacer()
                        }
                        .frame(width: geometry.size.width)
                        

                        
                        VStack(alignment: .leading) {
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("S\(seasonNumber) : E\(episodeNumber)")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .padding(.bottom,8)
                                
                                Text(episodeTitle)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.cyanBlue)
                            }
                            .padding(.bottom, 8)
                            .padding(.horizontal, 14)
                        }
                    }
                    .frame(width: geometry.size.width)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack() {
                            Text(episodeAirDate)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            HStack {
                                Image(systemName: "clock")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.gray)
                                Text(episodeDuration)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }.padding(.top,8)
                        
                        VStack(alignment: .leading) {
                            Text("Storyline")
                                .foregroundColor(Color.white)
                                .font(.headline)
                            
                            Text(showFullText ? description : truncatedDescription() + "... ")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 14))
                            
                            Button(action: {
                                showFullText.toggle()
                            }) {
                                Text(showFullText ? "read less" : "Read More")
                                    .foregroundColor(Color.blue)
                                    .font(.system(size: 14))
                            }
                        }
                        
                        HStack{
                            Text("Guest Stars")
                                .font(.title) // Reduced font size
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            NavigationLink(destination: PopularPeopleDetail()) {
                                    Text("View More")
                                        .foregroundColor(.blue)
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                print("NavigationLink to DiscoverDetail was tapped")
                            })

                        }
                        
                        
                        
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
                        

                        }
                        .padding(.leading, 0)

                    }
                    .padding(.horizontal, 16)
                }
            }
            .frame(width: geometry.size.width) // Ekran genişliğini ScrollView'a uyguluyoruz
            .background(Color.black.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
        }
        
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
    
    func truncatedDescription() -> String {
        let limit = 150
        if description.count > limit {
            let endIndex = description.index(description.startIndex, offsetBy: limit)
            return String(description[..<endIndex])
        }
        return description
    }
}


#Preview {
    EpisodeDetailView(
        episodeTitle: "Long Day's Journey Into Night",
        seasonNumber: 1,
        episodeNumber: 1,
        episodeAirDate: "September 27, 2024",
        episodeDuration: "22 Min",
        episodeDescription: "Unravel the mystery of a nightmarish town in middle America that traps all those who enter.",
        episodeThumbnailURL: "img1"
    )
}
