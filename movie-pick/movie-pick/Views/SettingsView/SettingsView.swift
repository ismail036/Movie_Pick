//
//  SettingsView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 26.10.2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            VStack {
                VStack(spacing: 10) {
                    Image("popcornIcon")
                        .resizable()
                        .frame(width: 120, height: 120)
                    
                    
                    Text("Movie Pick")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.cyanBlue)
                    
                    Text("Version: 1.0.0")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Your go-to app for movies and cinema. Let’s continue our entertainment journey together.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 40)
                    
                    
                    
                }
            }
            .padding(.top, 70)
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .leading) {
                Text("General")
                    .font(.title3)
                    .foregroundColor(.gray)
                
                
                HStack {
                    
                    NavigationLink(destination: PrivacyPolicy()){
                        Image(systemName: "doc.text.fill") // Privacy Policy Icon
                            .foregroundColor(.gray)
                        Text("Privacy Policy")
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                        }
                        .padding(.vertical,10)
                    }
                                
                            
                            HStack {
                                Image(systemName: "star.fill") // Write a Review Icon
                                    .foregroundColor(.gray)
                                Text("Write a Review")
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical,10)
                            
                            HStack {
                                Image(systemName: "arrowshape.turn.up.forward.fill") // Share with a Friend Icon
                                    .foregroundColor(.gray)
                                Text("Share with a Friend")
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical,10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal,10)
            
            Spacer()
            
        }
        .background(Color.mainColor1)
        .frame(maxWidth: .infinity)
        .frame(height: .infinity)
        .padding(0)
        .toolbarBackground(Color.mainColor1, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .leading)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Settings")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }

    }
}


#Preview {
    SettingsView()
}
