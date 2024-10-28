//
//  ShowCastCrewSection.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI

struct ShowCastCrewSection: View {
    @State private var selectedTab: String = "Cast"
    @State private var credits: TVCredits?
    @State private var castMembers: [TVCastMember] = []
    @State private var crewMembers: [TVCrewMember] = []
    
    let showId: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    selectedTab = "Cast"
                }) {
                    Text("Cast")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(selectedTab == "Cast" ? .white : .gray)
                }
                
                Text("|")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 4)
                    .foregroundColor(.white)
                
                Button(action: {
                    selectedTab = "Crew"
                }) {
                    Text("Crew")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(selectedTab == "Crew" ? .white : .gray)
                }
                
                Spacer()
                
                NavigationLink(destination: ShowCastCrewDetail(showId: showId)) {
                    HStack {
                        Text("View More")
                        Image(systemName: "chevron.right")
                    }
                }
                .foregroundColor(.blue)
                .navigationBarBackButtonHidden(true)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    if selectedTab == "Cast" {
                        ForEach(castMembers) { member in
                            VStack(alignment: .center) {
                                ZStack(alignment: .bottom) {
                                    if let profileURL = member.profileURL {
                                        AsyncImage(url: profileURL) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 120, height: 150)
                                                .cornerRadius(8)
                                        } placeholder: {
                                            Color.gray
                                                .frame(width: 120, height: 150)
                                                .cornerRadius(8)
                                        }
                                    } else {
                                        Color.gray
                                            .frame(width: 120, height: 150)
                                            .cornerRadius(8)
                                    }
                                    
                                    VStack(alignment: .center) {
                                        Text(member.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 15)
                                            .multilineTextAlignment(.center)
                                            .cornerRadius(4)
                                            .padding(.bottom, 5)
                                    }
                                }
                                
                                Text(member.character ?? "Unknown")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 120)
                        }
                    } else {
                        ForEach(crewMembers) { member in
                            VStack(alignment: .center) {
                                ZStack(alignment: .bottom) {
                                    if let profileURL = member.profileURL {
                                        AsyncImage(url: profileURL) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 120, height: 150)
                                                .cornerRadius(8)
                                        } placeholder: {
                                            Color.gray
                                                .frame(width: 120, height: 150)
                                                .cornerRadius(8)
                                        }
                                    } else {
                                        Color.gray
                                            .frame(width: 120, height: 150)
                                            .cornerRadius(8)
                                    }
                                    
                                    VStack(alignment: .center) {
                                        Text(member.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 15)
                                            .multilineTextAlignment(.center)
                                            .cornerRadius(4)
                                            .padding(.bottom, 5)
                                    }
                                }
                                
                                Text(member.job ?? "Unknown")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 120)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.mainColor1)
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: fetchShowDetails)
    }
    
    private func fetchShowDetails() {
        TMDBService().fetchShowDetails(showId: showId) { result in
            switch result {
            case .success(let showDetail):
                DispatchQueue.main.async {
                    self.credits = showDetail.credits
                    self.castMembers = self.credits?.cast ?? []
                    self.crewMembers = self.credits?.crew ?? []
                }
            case .failure(let error):
                print("Failed to fetch show details: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ShowCastCrewSection(showId: 1396)
}




extension TMDBService {
    func fetchShowDetails(showId: Int, completion: @escaping (Result<TVShowDetailModel, Error>) -> Void) {
        let endpoint = "\(TMDBAPI.baseURL)/tv/\(showId)?append_to_response=credits"
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(TMDBAPI.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching show details: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received for show details")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            // JSON yanıtını ham veri olarak yazdırıyoruz
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON data: \(jsonString)")
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let showDetail = try decoder.decode(TVShowDetailModel.self, from: data)
                completion(.success(showDetail))
            } catch {
                print("Error decoding show details: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

