//
//  WatchlistSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct WatchlistSection: View {
    var body: some View {
        VStack() {
            HStack {
                Text("Watchlist")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                
                
                Spacer()
                
                Button(action: {
                    // Action for 'View More'
                }) {
                    Text("View More")
                        .foregroundColor(.blue)
                }
            }
            
            HStack {
                Text("Movies and TV Shows from your watchlist")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 50)
                
                
                Spacer()
                
            }
            
            
            VStack {
                Image(systemName: "bookmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                
                Text("Watchlist")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                Text("Add what you are planning to watch next to this list")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
            }
                                
            Button(action: {
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(Color.blue))
            }
        }
        .padding(.leading, 0)
        .background(Color.mainColor1)
    }
}

#Preview {
    WatchlistSection()
}
