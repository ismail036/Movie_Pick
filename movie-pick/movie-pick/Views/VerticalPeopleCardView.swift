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
    var scale: Double

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .center) {
                Spacer()
                
                HStack {
                    Spacer()
                    Text(name)
                        .font(.system(size: 20 * scale))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 29 * scale)
                    Spacer()
                }
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 0)
            }
            .frame(width: 165 * scale, height: 160 * scale)
            .background(Color.mainColor3)
            .cornerRadius(12 * scale)
            .offset(y: 45 * scale)

            if let url = URL(string: peopleCard) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray // Yüklenirken gösterilecek yer tutucu
                }
                .scaledToFill()
                .frame(width: 150 * scale, height: 200 * scale, alignment: .top)
                .cornerRadius(12 * scale)
                .clipped()
                .offset(y: -25 * scale)
            } else {
                Color.gray
                    .frame(width: 150 * scale, height: 200 * scale)
                    .cornerRadius(12 * scale)
                    .offset(y: -25 * scale)
            }
        }
        .frame(width: 170 * scale, height: 280 * scale)
        .cornerRadius(12 * scale)
        .shadow(radius: 5 * scale)
    }
}

#Preview {
    VerticalPeopleCardView(
        name: "Tom Holland",
        peopleCard: "https://image.tmdb.org/t/p/w200/tom_holand.jpg",
        scale: 0.8
    )
}
