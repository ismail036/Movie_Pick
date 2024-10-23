//
//  ReviewsTab.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct Review: Identifiable {
    let id = UUID()
    let username: String
    let profileImageURL: URL // Resim URL'si
    let date: String
    let rating: Int
    let reviewText: String
}

struct ReviewsTab: View {
    @State private var expandedReviewId: UUID? = nil // Genişletilmiş inceleme ID'sini takip eder
    
    let reviews = [
        Review(username: "r96sk",
               profileImageURL: URL(string: "https://s3-alpha-sig.figma.com/img/036b/330e/a1670db6cfc19644bbc1f977f16b6125?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=o8BCsOwVn8I32Ew7YYNi2ASm8MZoxU4nMbEtWhEMlYXul8bsWi7yyUch6~X-pHkT3CmZ4BcsgkGeK~BG33Ju3Wou6yoS4nNK33s5Q2KSyzqsDAV8oVDCE~3q4BDklhDhPBmn3zxpSzK0lg~pBn6WGkznMs~WGD~jGVkhxRxSQCxeqeOIQoO8eOB0Bn8-OkR5csq-mPE-UcLSzMO7q0JSMtLUiLc1IJEduRHnmmWHBASJT3mLEIW8ErUJUKOg~X3vosqp0tOsiD7cVPrbcecHrq3IvYelcT2oj-Md36xxV7l2bmNGp3ag2H6eahQKj~wijoZ-ktESjWJla4FM8CNvug__")!,
               date: "July 25, 2024",
               rating: 5,
               reviewText: """
               Its story may not be the strongest, but the comedy makes 'Deadpool & Wolverine' an excellent watch!
               There are some top notch gags in there, particularly to do with the recent offscreen changes for Wade Wilson's alter ego...
               """),
        Review(username: "Chris Sawin",
               profileImageURL: URL(string: "https://s3-alpha-sig.figma.com/img/c998/bf12/063981c72e3795e734c28e0af3e21c02?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=a4j~HWKVLq8J4DZsrcsTRtmeCoWNJsd7fHW2l3zNfIVfClCqiRuc7yLLxBI9Ih6l5TwWhktETtECmSxZBwWeiQalWzcwe8O3BW0NbayTtVe75fKnlB5vqSWIdtXW0n465rkfZi6z5Gz4hw30Isfqg2mrNxh6oWB6-oL6QDOyJ2GIYA5f1AyFYzP-76HFL2kNOI65Sgg4HGWegHV9seAQ9dA9fVERVCfZLPNj2BfhkfOvB622pNXs~899zyqzg4Q89WOU84C973yfqGM5-gp9jBhl~S8iERS0tTHIrClMlEi37~3KRdrBCNUq1Pn-2ZvKXdtAdvZJay8oDjZ8Kp1qtg__")!,
               date: "July 26, 2024",
               rating: 4,
               reviewText: """
               Deadpool & Wolverine is the best the MCU has been since Guardians of the Galaxy Vol. 3. It’s two hours of comic book-driven fan service...
               """),
        Review(username: "r96sk",
               profileImageURL: URL(string: "https://s3-alpha-sig.figma.com/img/036b/330e/a1670db6cfc19644bbc1f977f16b6125?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=o8BCsOwVn8I32Ew7YYNi2ASm8MZoxU4nMbEtWhEMlYXul8bsWi7yyUch6~X-pHkT3CmZ4BcsgkGeK~BG33Ju3Wou6yoS4nNK33s5Q2KSyzqsDAV8oVDCE~3q4BDklhDhPBmn3zxpSzK0lg~pBn6WGkznMs~WGD~jGVkhxRxSQCxeqeOIQoO8eOB0Bn8-OkR5csq-mPE-UcLSzMO7q0JSMtLUiLc1IJEduRHnmmWHBASJT3mLEIW8ErUJUKOg~X3vosqp0tOsiD7cVPrbcecHrq3IvYelcT2oj-Md36xxV7l2bmNGp3ag2H6eahQKj~wijoZ-ktESjWJla4FM8CNvug__")!,
               date: "July 25, 2024",
               rating: 5,
               reviewText: """
               Its story may not be the strongest, but the comedy makes 'Deadpool & Wolverine' an excellent watch!
               There are some top notch gags in there, particularly to do with the recent offscreen changes for Wade Wilson's alter ego...
               """),
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(reviews) { review in
                    ReviewCard(review: review, expandedReviewId: $expandedReviewId)
                        .padding(.horizontal)
                }
            }
            .padding(0)
        }
        .background(Color.mainColor1.ignoresSafeArea())
    }
}

struct ReviewCard: View {
    let review: Review
    @Binding var expandedReviewId: UUID?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Kullanıcı Bilgileri ve Derecelendirme
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

                // Yıldız Derecelendirmesi
                HStack(spacing: 2) {
                    ForEach(0..<review.rating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
            }

            // İnceleme Metni
            Text(expandedReviewId == review.id ? review.reviewText : truncatedText(review.reviewText))
                .foregroundColor(.white)
                .font(.body)
                .lineLimit(expandedReviewId == review.id ? nil : 3)
            
            // More/Less Butonu
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
        .navigationBarBackButtonHidden(true)
    }

    // İnceleme metninin kısaltılmış versiyonu
    func truncatedText(_ text: String) -> String {
        let limit = 100 // Yaklaşık karakter sınırı
        if text.count > limit {
            let endIndex = text.index(text.startIndex, offsetBy: limit)
            return String(text[..<endIndex]) + "..."
        }
        return text
    }
}

#Preview {
    ReviewsTab()
}
