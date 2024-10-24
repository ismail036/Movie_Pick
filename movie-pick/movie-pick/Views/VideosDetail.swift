//
//  VideosDetail.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct VideoItem: Identifiable {
    let id = UUID()
    let thumbnailURL: URL // Resim URL'si
    let title: String // Video başlığı
    let duration: String // Video süresi
    let date: String // Yayınlanma tarihi
}

struct VideosDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let videos = [
        VideoItem(thumbnailURL: URL(string: "https://s3-alpha-sig.figma.com/img/aaca/9f41/cdbee82672a5ba174f4a04611269a0b6?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Sx858Y3vD8pTitRbB3jxhCJ7nPyHmlRtjRkYXUXjt2nX0hTBQrQc0sqWYNPCS5PZMvM~fu1gy~oHkzdMYquHZwgwTfz9IcuVQgOF3Vi9u-Wl7iXUrgsX2lkJP6GaOZH1bdLRoDiml1LbMfVWDUCDgnnF8v-CvNT4Z58jlsGp~WNd~xDWL7PhHv209YdgYQHo8pJQT5sm1tGe0khz5mJoCEW1Y7keTan0xzYfc~3BB0mz91qQqhXFGf11ol8TsIUT82Z5HGDbC7eGsVmLTM75Ucksy8781b7SkQuuhUjt6W1gHissoov1nJc4g-jDTzAgty9NIIktiqfr1UI5egSn0Q__")!,
                  title: "Deadpool & Wolverine | Official Trailer",
                  duration: "2:24", date: "August 23, 2020"),
        VideoItem(thumbnailURL: URL(string: "https://s3-alpha-sig.figma.com/img/3d6f/a0cf/bf75e59a9bde51b6ae0adec9e04c34c0?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=fihUR0a3BzJGjKL6h695AYNEa1uC06ggPZh1pAyJKZ2TYZPObd7MFvBjnBL6yvqyBv6Q~IYEvUwJH0c6FnzZzZ8qwzqu~tSFY2FMA~1qeyaiZx~JXlQC8nf76GIVY4zvNC4UgH2ahFNyt1eIhkmtF3UUbdIupLzfEkcSqvHgUrL2IEKVoCT79WPf8KjC8RoJeUn9GSke8WFVYkB9V0niEMVypKsKKFAIFih7OoeRGAEbc9sCyg3pwKXWcKmGRxg2BP8sbclsKcpmwg022HnZ8aL1f6erVG9Q1nkCwNbb46LjFfaEVBK8qSMFzOVDpyGSknRcvZvbjyCLvBH5O1A8dw__")!,
                  title: "Deadpool & Wolverine | Final Trailer",
                  duration: "2:24", date: "August 23, 2020"),
        VideoItem(thumbnailURL: URL(string: "https://s3-alpha-sig.figma.com/img/aaca/9f41/cdbee82672a5ba174f4a04611269a0b6?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Sx858Y3vD8pTitRbB3jxhCJ7nPyHmlRtjRkYXUXjt2nX0hTBQrQc0sqWYNPCS5PZMvM~fu1gy~oHkzdMYquHZwgwTfz9IcuVQgOF3Vi9u-Wl7iXUrgsX2lkJP6GaOZH1bdLRoDiml1LbMfVWDUCDgnnF8v-CvNT4Z58jlsGp~WNd~xDWL7PhHv209YdgYQHo8pJQT5sm1tGe0khz5mJoCEW1Y7keTan0xzYfc~3BB0mz91qQqhXFGf11ol8TsIUT82Z5HGDbC7eGsVmLTM75Ucksy8781b7SkQuuhUjt6W1gHissoov1nJc4g-jDTzAgty9NIIktiqfr1UI5egSn0Q__")!,
                  title: "Deadpool & Wolverine | Official Trailer",
                  duration: "2:24", date: "August 23, 2020"),
        VideoItem(thumbnailURL: URL(string: "https://s3-alpha-sig.figma.com/img/3d6f/a0cf/bf75e59a9bde51b6ae0adec9e04c34c0?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=fihUR0a3BzJGjKL6h695AYNEa1uC06ggPZh1pAyJKZ2TYZPObd7MFvBjnBL6yvqyBv6Q~IYEvUwJH0c6FnzZzZ8qwzqu~tSFY2FMA~1qeyaiZx~JXlQC8nf76GIVY4zvNC4UgH2ahFNyt1eIhkmtF3UUbdIupLzfEkcSqvHgUrL2IEKVoCT79WPf8KjC8RoJeUn9GSke8WFVYkB9V0niEMVypKsKKFAIFih7OoeRGAEbc9sCyg3pwKXWcKmGRxg2BP8sbclsKcpmwg022HnZ8aL1f6erVG9Q1nkCwNbb46LjFfaEVBK8qSMFzOVDpyGSknRcvZvbjyCLvBH5O1A8dw__")!,
                  title: "Deadpool & Wolverine | Final Trailer",
                  duration: "2:24", date: "August 23, 2020"),
        VideoItem(thumbnailURL: URL(string: "https://s3-alpha-sig.figma.com/img/aaca/9f41/cdbee82672a5ba174f4a04611269a0b6?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Sx858Y3vD8pTitRbB3jxhCJ7nPyHmlRtjRkYXUXjt2nX0hTBQrQc0sqWYNPCS5PZMvM~fu1gy~oHkzdMYquHZwgwTfz9IcuVQgOF3Vi9u-Wl7iXUrgsX2lkJP6GaOZH1bdLRoDiml1LbMfVWDUCDgnnF8v-CvNT4Z58jlsGp~WNd~xDWL7PhHv209YdgYQHo8pJQT5sm1tGe0khz5mJoCEW1Y7keTan0xzYfc~3BB0mz91qQqhXFGf11ol8TsIUT82Z5HGDbC7eGsVmLTM75Ucksy8781b7SkQuuhUjt6W1gHissoov1nJc4g-jDTzAgty9NIIktiqfr1UI5egSn0Q__")!,
                  title: "Deadpool & Wolverine | Official Trailer",
                  duration: "2:24", date: "August 23, 2020"),
        VideoItem(thumbnailURL: URL(string: "https://s3-alpha-sig.figma.com/img/3d6f/a0cf/bf75e59a9bde51b6ae0adec9e04c34c0?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=fihUR0a3BzJGjKL6h695AYNEa1uC06ggPZh1pAyJKZ2TYZPObd7MFvBjnBL6yvqyBv6Q~IYEvUwJH0c6FnzZzZ8qwzqu~tSFY2FMA~1qeyaiZx~JXlQC8nf76GIVY4zvNC4UgH2ahFNyt1eIhkmtF3UUbdIupLzfEkcSqvHgUrL2IEKVoCT79WPf8KjC8RoJeUn9GSke8WFVYkB9V0niEMVypKsKKFAIFih7OoeRGAEbc9sCyg3pwKXWcKmGRxg2BP8sbclsKcpmwg022HnZ8aL1f6erVG9Q1nkCwNbb46LjFfaEVBK8qSMFzOVDpyGSknRcvZvbjyCLvBH5O1A8dw__")!,
                  title: "Deadpool & Wolverine | Final Trailer",
                  duration: "2:24", date: "August 23, 2020")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {

            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(videos) { video in
                        HStack(alignment: .center, spacing: 10) {
                            WebImage(url: video.thumbnailURL)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 180, height: 170)
                                .clipped()
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(video.title)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text("Trailer · \(video.duration) · \(video.date)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Button(action: {
                                }) {
                                    Text("Play Now")
                                        .font(.subheadline)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 16)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                            .padding(10)
                            
                            Spacer()
                        }
                        .frame(height: 160)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.2)]),
                                           startPoint: .top, endPoint: .bottom)
                        )
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
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
                Text("Videos")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }

    }
}

#Preview {
    VideosDetail()
}
