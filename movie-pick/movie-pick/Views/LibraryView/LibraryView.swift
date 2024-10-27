//
//  LibraryView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 26.10.2024.
//

import SwiftUI

struct LibraryView: View {
    @State private var selectedTab = 0
    @State private var isSticky = false
    var body: some View {
        
        VStack{
            if !isSticky {
                LibraryTabButtonsView(selectedTab: $selectedTab)
                    .frame(maxWidth: .infinity)
                    .background(Color.mainColor1)
            }
            
            VStack(){
                if selectedTab == 0 {
                    WatchlistTab()
                } else if selectedTab == 1 {
                    RemindersTab()
                }
                Spacer()
            }
            .background(Color.mainColor1)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.mainColor1)
    }
}



struct LibraryTabButtonsView: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack(spacing: 0) {
            TabButton(title: "Watchlist", isSelected: selectedTab == 0, fontSize: 16)
                .onTapGesture {
                    selectedTab = 0
                }
                .frame(maxWidth: .infinity)
            TabButton(title: "Reminders", isSelected: selectedTab == 1, fontSize: 16)
                .onTapGesture {
                    selectedTab = 1
                }
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 10)
        .background(Color.mainColor1)
    }
}

struct WatchlistTab:View {
    var body: some View {
        VStack {
            
            Spacer()
            
            Image(systemName: "bookmark.fill")
                .font(.system(size: 120))
                .background(Color.cyanBlue)
                .cornerRadius(20)
                .padding(.bottom,10)
            
            Text("No Movies or Shows Tracked Yet")
                .foregroundColor(.white)
                .font(.title)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom,5)
            
            Text("Begin Tracking  your Favorite Movies or TV Shows.")
                .foregroundColor(.white)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom,5)
            
            NavigationLink(destination: EmptyView()) {
                Text("Add")
                .foregroundStyle(Color.white)
                .font(.system(size: 20))
                .padding(.all, 10)
            }
            .background(Color.gray)
            .cornerRadius(20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 50)
    }

}

struct RemindersTab:View {
    var body: some View {
        VStack {
            
            Spacer()
            
            Image(systemName: "bell.fill")
                .font(.system(size: 120))
                .background(Color.cyanBlue)
                .cornerRadius(20)
                .padding(.bottom,10)
            
            Text("No Reminders set")
                .foregroundColor(.white)
                .font(.title)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom,5)
            
            Text("Plan your watching schedule by adding movies or tv shows here.")
                .foregroundColor(.white)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom,5)
            
            NavigationLink(destination: EmptyView()) {
                Text("Add")
                .foregroundStyle(Color.white)
                .font(.system(size: 20))
                .padding(.all, 10)
            }
            .background(Color.gray)
            .cornerRadius(20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 50)
    }

}

#Preview {
    LibraryView()
}
