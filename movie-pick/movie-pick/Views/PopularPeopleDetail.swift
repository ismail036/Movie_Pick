//
//  PopularPeopleDetail.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct PopularPeopleDetail: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
       VStack{
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(0..<3) {i in
                        PopularPeopleCard(
                            posterImage: "tom_holand",
                            name: "Tom Holland",
                            desc: "The Dark Knight : Le Chevalier noir, The Dark Knight Rises, and Dracula"
                        )
                        PopularPeopleCard(
                            posterImage: "margot",
                            name: "Margot Robbie",
                            desc: "The Dark Knight : Le Chevalier noir, The Dark Knight Rises, and Dracula"
                        )
                        PopularPeopleCard(
                            posterImage: "jason",
                            name: "Jason Statham",
                            desc: "The Dark Knight : Le Chevalier noir, The Dark Knight Rises, and Dracula"
                        )
                    }
                }
            }
        }
        .background(Color.mainColor1)
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
                Text("Popular People")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(Color.mainColor1, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}


#Preview {
    PopularPeopleDetail()
}
