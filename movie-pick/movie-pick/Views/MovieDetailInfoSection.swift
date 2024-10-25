//
//  MovieDetailInfoSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI

struct MovieDetailInfoSection: View {
    var body: some View {
        VStack{
            HStack{
                Spacer()
                HStack(spacing: -20) {
                    Image("netflix_icon")
                        .resizable()
                        .frame(width: 35, height:35)
                        .clipShape(Circle())

                    Image("hulu_icon")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())

                    Image("hbo_icon")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                    
                    Rectangle()
                        .frame(width: 50 , height: 0)


                    Button(action: {
                    }) {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 10)
                            .foregroundColor(.gray)
                    }
                }
                .padding(10)
                .background(Color.mainColor3)
                .cornerRadius(40)
                .padding(.horizontal)
            }
            
            Rectangle()
                .frame(width: 0 , height: 10)
            
            HStack{
                VStack(alignment: .leading){
                    Text("The Platform 2")
                        .foregroundStyle(Color.white)
                        .font(.title)
                        .bold()
                        .padding(.bottom, 2)
                    
                    HStack{
                        Text("Action")
                            .foregroundStyle(Color.cyanBlue)
                            .font(.caption)
                            .bold()
                        Text("•")
                            .foregroundStyle(Color.cyanBlue)
                            .font(.caption)
                            .bold()
                        Text("Adventure")
                            .foregroundStyle(Color.cyanBlue)
                            .font(.caption)
                            .bold()
                        Text("•")
                            .foregroundStyle(Color.cyanBlue)
                            .font(.caption)
                            .bold()
                        Text("Survival")
                            .foregroundStyle(Color.cyanBlue)
                            .font(.caption)
                            .bold()
                    }
                }
                
                Spacer()
                
                HStack{
                    Button(action: {
                    }) {
                        VStack {
                            Image(systemName: "bell")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)
                                .foregroundColor(Color.white)
                                .padding(.bottom,4)
                            
                            Text("Reminder")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .bold()
                        }
                    }
                    .padding(.horizontal,5)
                    
                    
                    Button(action: {
                    }) {
                        VStack {
                            Image(systemName: "bookmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)
                                .foregroundColor(Color.white)
                                .padding(.bottom,4)
                            
                            Text("Reminder")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .bold()
                        }
                    }
                    .padding(.horizontal,5)
                    
                }
            }
            .padding(.horizontal,16)
            
            
            
            
            HStack {
                HStack() {

                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                            .padding(.vertical,6)
                        Text("8.5")
                            .foregroundColor(.white)
                            .font(.system(size: 10))
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 1, height: 18)
                        .padding(0)
                    

                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 14, height: 14)
                            .foregroundColor(.white)
                        
                        Text("456")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .frame(minWidth: 0, maxWidth: 45, alignment: .leading)
                }
                .background(Color.green)
                .cornerRadius(16)
                
                Spacer()
                
                            
                HStack {
                     Image(systemName: "timer")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                        .foregroundColor(.white)
                        .padding(.leading, 12)
                        .padding(.vertical,7.5)
                    
                    Text("1 hr 40 Min")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .padding(.trailing, 14)
                }
                .background(Color.blue)
                .cornerRadius(16)
                .padding(.vertical, 8)
                

                Spacer()
                
                VStack(alignment: .trailing) {
                       Text("Release Date")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                        .bold()
                        
                        Text("September 27, 2024")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .bold()
                }
                
                
            }
            .padding(.vertical , 14)
            .padding(.horizontal , 14)

        
            
            
            
        }
        .background(Color.mainColor1)
    }
}

#Preview {
    MovieDetailInfoSection()
}
