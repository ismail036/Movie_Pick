//
//  CastCrewDetail.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct CastCrewDetail: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedTab = 0
    
    var body: some View {
       VStack{
           VStack {
               HStack(spacing: 0) {
                   TabButton(title: "Cast", isSelected: selectedTab == 0, fontSize: 20)
                               .onTapGesture {
                                   selectedTab = 0
                               }
                               .padding(.horizontal,16)
                               .padding(.vertical,0)
                   
                           
                   
                           TabButton(title: "Crew", isSelected: selectedTab == 1,fontSize: 20)
                               .onTapGesture {
                                   selectedTab = 1
                               }
                               .padding(.horizontal,16)
                               .padding(.vertical,0)
               }
                       .padding(0)

                       Spacer()

                       if selectedTab == 0 {
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
                       } else if selectedTab == 1 {
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
                       Spacer()
                   }
           
        }
        .padding(0)
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
                Text("Cast and Crew")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
    }

}

#Preview {
    CastCrewDetail()
}
