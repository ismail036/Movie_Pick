//
//  MainMovieCardView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct MainMovieCardView: View {
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Beetlejuice Beetlejuice Beetlejuice")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("After a family tragedy, three generations...")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                HStack {
                    Text("Action")
                    Text("•")
                    Text("Adventure")
                    Text("•")
                    Text("Survival")
                }
                .font(.footnote)
                .foregroundColor(.gray)
                
                HStack {
                    Text("2023 Jul, 21")
                        .font(.footnote)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        ForEach(0..<5) { star in
                            Image(systemName: star < 4 ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.caption)
                                .imageScale(.medium) 
                        }
                    }
                }
                
                
                
                Button(action: {
                }) {
                    Text("Details")
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            Spacer()
            
            Image("beetlejuice")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 180)
                .cornerRadius(10)
                .padding(.trailing)
        }
        .background(.mainColor1)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

#Preview {
    MainMovieCardView()
}
