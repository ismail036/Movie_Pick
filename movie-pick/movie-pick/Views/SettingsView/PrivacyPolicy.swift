//
//  PrivacyPolicy.swift
//  movie-pick
//
//  Created by İsmail Parlak on 26.10.2024.
//

import SwiftUI

struct PrivacyPolicy: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack{
            Text("""
            Privacy Policy
            
            We built the “App Name” app as a Free app. This SERVICE is provided by the developers of “App Name” (“we”), (“us”) at no cost and is intended for use as is.
            
            This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.
            
            If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.
            
            The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at MovieMen unless otherwise defined in this Privacy Policy.
            
            Information Collection and Use
            
            For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information.
            """)
            .foregroundColor(.white)
            .padding()
            .multilineTextAlignment(.leading)
            
            
            Spacer()
        }
        .background(Color.mainColor1)
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .leading)
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
                Text("Privacy Policy")
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
    PrivacyPolicy()
}
