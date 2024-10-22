//
//  PopularPeopleCard.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct PopularPeopleCard: View {
    var posterImage: String
    var name: String
    var desc: String


    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            
            Image(posterImage)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 180)
                .cornerRadius(12)
            
            VStack(alignment: .leading) {
                
                Text(name)
                    .foregroundColor(.white)
                    .padding(.vertical,2)
                    
                Text(desc)
                    .foregroundColor(.white)
                    .padding(.vertical,2)

                
            }
            .padding()
            .frame(maxWidth: .infinity,maxHeight: 180)
            .background(Color.mainColor1)
            .cornerRadius(20)
        }
        .frame(maxWidth: .infinity)
        .background(Color.mainColor1)
        .cornerRadius(20)
        .padding(.leading, 0)
        .padding(.trailing, 0)

    }
}

#Preview {
    PopularPeopleCard(
        posterImage: "tom_holand",
        name: "Tom Holland",
        desc: "The Dark Knight : Le Chevalier noir, The Dark Knight Rises, and Dracula"
    )
}

