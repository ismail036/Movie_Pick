//
//  BoxOfficeSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct BoxOfficeView: View {
    let movies = [
        ("Joker: Folie à Deux", "$40M"),
        ("The Wild Robot", "$64M"),
        ("Beetlejuice Beetlejuice", "$265M"),
        ("Transformers One", "$47M"),
        ("Speak No Evil", "$33M")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("World Box Office")
                    .font(.title2) // Reduced font size
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                }) {
                    Text("View More")
                        .foregroundColor(.blue)
                }
            }
            
            Text("Weekend of Oct 4 - 6, 2024")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            
            ForEach(0..<movies.count, id: \.self) { index in
                HStack {
                    Text("\(index + 1)")
                        .font(.system(size: 28))
                        .fontWeight(.bold)
                        .foregroundColor(Color.cyanBlue)
                    
                    Rectangle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color("MainColor2Primary"), Color("MainColor2Secondary")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .frame(width: 2, height: 16)
                                    
                    VStack(alignment: .leading) {
                        Text(movies[index].0)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("Total Gross: \(movies[index].1)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }

            }
                    }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    BoxOfficeView()
}
