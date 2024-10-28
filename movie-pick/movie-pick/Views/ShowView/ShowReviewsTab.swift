//
//  ShowReviewsTab.swift
//  movie-pick
//
//  Created by İsmail Parlak on 28.10.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ShowReview: Identifiable {
    let id = UUID()
    let username: String
    let profileImageURL: URL?
    let date: String
    let rating: Int
    let reviewText: String
}

struct ShowReviewsTab: View {
    var showId: Int
    @State private var expandedReviewId: UUID? = nil
    @State private var reviews: [ShowReview] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(reviews) { review in
                    ShowReviewCard(review: review, expandedReviewId: $expandedReviewId)
                        .padding(.horizontal)
                }
            }
            .padding(0)
        }
        .background(Color.mainColor1.ignoresSafeArea())
        .onAppear {
            fetchShowReviews()
        }
    }

    private func fetchShowReviews() {
        TMDBService().fetchAllShowReviews(showId: showId) { result in
            switch result {
            case .success(let fetchedReviews):
                DispatchQueue.main.async {
                    self.reviews = fetchedReviews.map { fetchedReview in
                        ShowReview(
                            username: fetchedReview.author,
                            profileImageURL: fetchedReview.profileImageURL,
                            date: fetchedReview.formattedDate,
                            rating: fetchedReview.rating,
                            reviewText: fetchedReview.content
                        )
                    }
                }
            case .failure(let error):
                print("Failed to fetch show reviews: \(error.localizedDescription)")
            }
        }
    }
}

struct ShowReviewCard: View {
    let review: ShowReview
    @Binding var expandedReviewId: UUID?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                WebImage(url: review.profileImageURL)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))

                VStack(alignment: .leading, spacing: 2) {
                    Text(review.username)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(review.date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }

            Text(expandedReviewId == review.id ? review.reviewText : truncatedText(review.reviewText))
                .foregroundColor(.white)
                .font(.body)
                .lineLimit(expandedReviewId == review.id ? nil : 3)

            Button(action: {
                if expandedReviewId == review.id {
                    expandedReviewId = nil
                } else {
                    expandedReviewId = review.id
                }
            }) {
                Text(expandedReviewId == review.id ? "Less" : "More")
                    .foregroundColor(.blue)
                    .font(.body)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }

    func truncatedText(_ text: String) -> String {
        let limit = 100
        if text.count > limit {
            let endIndex = text.index(text.startIndex, offsetBy: limit)
            return String(text[..<endIndex]) + "..."
        }
        return text
    }
}

#Preview {
    ShowReviewsTab(showId: 1396)
}
