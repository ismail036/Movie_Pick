//
//  BoxOfficeDetail.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct BoxOfficeDetail: View {
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        VStack{
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(0..<10) {i in
                        BoxOfficeMovieCard(
                            posterImage: "beetlejuice",
                            movieTitle: "Beetlejuice Beetlejuice Beetlejuice",
                            totalGross: "$40M",
                            weekendGross: "$40$",
                            week: 1
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
                Text("World Box Office")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(Color.mainColor1, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
}

#Preview {
    NavigationView {
        BoxOfficeDetail()
    }
}
