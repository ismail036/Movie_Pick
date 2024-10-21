//
//  VerticalPeopleCardView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct VerticalPeopleCardView: View {
    var name: String
    var peopleCard: String

    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .center) {
                Spacer()
                
                HStack {
                    Spacer()
                    Text(name)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 29)
                    Spacer()
                }
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 0)
            }
            .frame(width: 165, height: 160)
            .background(Color.mainColor3)
            .cornerRadius(12)
            .offset(y: 45)

            
            Image(peopleCard)
                .resizable()
                .scaledToFill()
                .frame(width: 150,height:200, alignment: .top)
                .cornerRadius(12)
                .clipped()
                .offset(y:-25)
            
        }
        .frame(width: 170, height: 280)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

#Preview {
    VerticalPeopleCardView(
        name: "Tom Holland",
        peopleCard: "tom_holand"
    )
}
