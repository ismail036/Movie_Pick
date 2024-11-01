    //
    //  MoreLikeThisSection.swift
    //  movie-pick
    //
    //  Created by İsmail Parlak on 23.10.2024.
    //

    //
    //  MoreLikeThisSection.swift
    //  movie-pick
    //
    //  Created by İsmail Parlak on 23.10.2024.
    //

    import SwiftUI

    struct MoreLikeThisSection: View {
        let movieId: Int
        @State private var similarMovies: [SimilarMovie] = [] // Benzer filmleri saklayacağımız dizi

        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text("More Like This")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Spacer()

                    NavigationLink(destination: MoreLikeThisDetail(movieId: movieId)){
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
                    HStack(spacing: 10) {
                        ForEach(similarMovies) { movie in
                            VerticalMovieCard(
                                selectedDestination: .movieDetail,
                                movieId: movie.id
                            )
                        }
                    }
                    .padding(.horizontal, 0)
                    .padding(.vertical, 0)
                }
            }
            .background(Color.mainColor1)
            .navigationBarBackButtonHidden(true)
            .onAppear(perform: loadSimilarMovies) // Görünüm oluşunca benzer filmleri yükler
        }

        private func loadSimilarMovies() {
            TMDBService().fetchMovieDetails(movieId: movieId) { result in
                switch result {
                case .success(let movieDetail):
                    DispatchQueue.main.async {
                        self.similarMovies = movieDetail.similar?.results ?? []
                        print(self.similarMovies)
                    }
                case .failure(let error):
                    print("Failed to fetch similar movies: \(error.localizedDescription)")
                }
            }
        }
    }

    #Preview {
        MoreLikeThisSection(movieId: 1184918)
    }
