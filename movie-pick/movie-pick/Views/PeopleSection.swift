//
//  PeopleSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct PeopleSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("Popular People")
                    .font(.title) // Reduced font size
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                }) {
                    Text("View More")
                        .foregroundColor(.blue)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    VerticalPeopleCardView(
                        name: "Tom Holland",
                        peopleCard: "tom_holand"
                    )
                    
                    VerticalPeopleCardView(
                        name: "Jason Statham",
                        peopleCard: "jason"
                    )
                    
                    VerticalPeopleCardView(
                        name: "Margot Robbie",
                        peopleCard: "margot"
                    )

                }
                .padding(.horizontal, 0)
                .padding(.vertical, 0)
            }
            .padding(.leading, 0)

            

            
                    }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    PeopleSection()
}
