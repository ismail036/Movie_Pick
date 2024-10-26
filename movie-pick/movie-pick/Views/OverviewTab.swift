//
//  OverviewTab.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct OverviewTab: View {
    
    @State private var showFullText = false
    var movieID : Int
    
    let description = """
    After a mysterious leader imposes his law in a brutal system of vertical cells, a new arrival battles against a dubious food distribution method. The system is designed in such a way that the top floors receive an abundance of food, while the lower floors struggle with starvation, causing people to fight for survival. The newcomer seeks a way to disrupt this dystopian order, while grappling with his own morality and the challenges of the brutal environment.
    """
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Storyline")
                    .foregroundColor(Color.white)
                    .font(.headline)
                
                Text(showFullText ? description : truncatedDescription() + "... ")
                    .foregroundColor(Color.gray)
                    .font(.body)
                
                Button(action: {
                    showFullText.toggle()
                }) {
                    Text(showFullText ? "read less" : "read more")
                        .foregroundColor(Color.blue)
                        .font(.body)
                }
            }
            .padding()
            
            
            CastCrewSection()
            
            VideosSection()
            
            MoreLikeThisSection()
            
            MovieDetailInfoCard()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.mainColor1)
    }
    
    func truncatedDescription() -> String {
        let limit = 150 // Approximate character count to fit 3 lines
        if description.count > limit {
            let endIndex = description.index(description.startIndex, offsetBy: limit)
            return String(description[..<endIndex])
        }
        return description
    }
}

#Preview {
    OverviewTab(movieID: 1184918)
}
