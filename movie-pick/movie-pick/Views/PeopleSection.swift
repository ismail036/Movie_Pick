//
//  PeopleSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct PeopleSection: View {
    var text:String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text(text)
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
                .padding(.horizontal, 0)
                .padding(.vertical, 0)
            }
            .padding(.leading, 0)

            

            
                    }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    PeopleSection(text:"Popular People")
}
