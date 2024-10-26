//
//  PeopleSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct PeopleSection: View {
    var text: String
    @State private var people: [PersonModel] = []
    private let tmdbService = TMDBService()

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(text)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                NavigationLink(destination: PopularPeopleDetail()) {
                    Text("View More")
                        .foregroundColor(.blue)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    print("NavigationLink to PopularPeopleDetail was tapped")
                })
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(people) { person in
                        VerticalPeopleCardView(
                            name: person.name,
                            peopleCard: person.profileURL?.absoluteString ?? "",
                            scale: 0.7
                        )
                    }
                }
                .padding(.horizontal, 0)
                .padding(.vertical, 0)
            }
            .padding(.leading, 0)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            tmdbService.fetchPopularPeople { result in
                switch result {
                case .success(let people):
                    self.people = people
                case .failure(let error):
                    print("Error fetching popular people: \(error)")
                }
            }
        }
    }
}

#Preview {
    PeopleSection(text: "Popular People")
}
