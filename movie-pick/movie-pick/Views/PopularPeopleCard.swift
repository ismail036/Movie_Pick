//
//  PopularPeopleCard.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct PopularPeopleCard: View {
    let imageUrl: URL?
    let name: String
    let desc: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 90)
                    .cornerRadius(8)
            } placeholder: {
                Color.gray
                    .frame(width: 70, height: 90)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(desc)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding(10)
        .background(Color.mainColor1)
        .cornerRadius(10)
    }
}


