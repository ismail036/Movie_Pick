//
//  PhotosAndVideosTab.swift
//  movie-pick
//
//  Created by İsmail Parlak on 23.10.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct PhotosAndVideosTab: View {
    
    let posters = [
        "https://s3-alpha-sig.figma.com/img/b776/5b2e/85fbd14b31633996cc58e32b6e8780ce?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=GuOOBaOgGgOluL~pyqD8WeX9uoVWQi8dcCpOFzvptEnZmxd~Iu1bmE1DHmnEeVsgt5pPY54EGdAldrJeuCXLP3-9oxoxVYu2EdpOkLEGyco8XhURNcP9meTHsK6wP9HG7aTwF3rb~o6YJmOPH-rREWP73fx26CHWUcCbOdOh3tuIL1OT-c4EReJ~SlZ~7Zea4m0PBviIkh67WLaXZzmwR3AJXqU3zpsA0x4-38FFloiBmnjGEqmRDQnlQWjtpJlSyNEbHVVJAs0vD9tWZRKgDDjBqrarcQxJsG-KuWwPt8Ep7jpeng7LkjU~CCaUc95nYBQl02VrGQ7FMWwuB7YKYw__",
        "https://s3-alpha-sig.figma.com/img/9984/95ac/eced51a352d5ad8b295f6c4005093f64?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=EKikUJdNujSCaDNloAQnLQRETqn~Mu9n-Emv~Z2Pov8sB2SSSmAo723v2vREyBS~QqzbQTIY11lCy~vPWj3-gFI5ME3i~6Rxfi~rkKyBN0H3a2vLzcfFoV~z9C0geSyqtqAmxjYkUSTm6oHO1LjFHemxbA6gf5nuj-nzvvfBSXqT~O1OcXP9f-AhwaiU4Ip9nkfgD690Dn9OV43jIkyGN0FBE2Yw1rRH7vjOKNSpXXUYUDTmBtzDuEOs9kqKJYGcB1ZXit6SCBPhobI5w-X~HRisF~YVCHTyka4TgvAtrDSNnXH3DEm5xE5l7abYhRyazeZFNMuGI0bZAjZ0wPXkoQ__",
        "https://s3-alpha-sig.figma.com/img/2bc1/9419/b605fc29ec18f712544fce9e95fc77ae?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=iBsefADr7gNEruy5SI93Khh4v5N7J-07A1dBLlpiBaL7MgVxAFdSe2DyUFJtLewL7MJmFVs7p8oM87DJENHaMw6Ve3ckzd0TWeoyxsNzFoCvSupajXpg7-MF-9QI867wKtR2~onqjoZPSJ08COk3KbQ0eUkGVwPMoUZYiMJIIO0IUbAuJp5IhsbdqAQCiN5KJzco03pVYUeQetmn0cIOshdBwVXbzf~b6GeO~Q8488Q-l8IRo2m5q5dU0OMhVvV4RgY2qPq4kxrJmm1n7Khh5yhqIxirrtRqytu~73T7kHZIV-HqUEJQKoQi9SWpuDDNZZ0G507ayF-gR5811Hd~WQ__"
    ]
    
    let backdrops = [
        "https://s3-alpha-sig.figma.com/img/c4e9/fd67/55e084f23b1d4f1e48065b21e8f44f5a?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=iIq~MLuhgk1vaTJ7Gp3Kj8c1kIaduU37rmUHPJETGiUIz65wLyHdtHWeu3I7te2DQUl8HDVL2ft7eeVkZhi5LJPlxCPFf0O0s4V-KecIgEmee~Ov1h4nalMK4fXzjqYVMpWpV6pKxIbgGlbUlAfuOEj5npy7Xrfj5gj22p9K-hROeSgLAGKLUODLIACPHz4W6fWxHnAlvOegizCBbi6w3JIKvagID8Uvyi0BzojlegJ1eF~i365IpiUfmPSrvddVZtEC-XsA0lqyhUbf5QoyuSUk9BhV1IdSLANxCCr8ri3jzn3HhP7k1sofHgtzxtaKaO31O95meiTNvQP~VJ~MaQ__",
        "https://s3-alpha-sig.figma.com/img/c0f0/1c9f/a8baf9711af79cd56e437618cd00212b?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=TsjwJfk89-bPUh1Oi8Hqg3LnQV0~JxasOXdC66WXYbM4gkwT7kevUkKEGWiRLSA8Yuvpno70lEO0VPLvYegi57OU5vesb1vymQe4ahXChfxSezHt9PjT4J-~coo~x4z9YQC7E9TTrpsYWxAZ~o3rUoj0wMs~ZQwB0CxUrId8efpzhKbFj82f4V7Kiw9egRlo6wBQ00Ka-w8~uEEqYnZubCK0eEe0cvOFzAx95ohOoG5o74ZsWONMb3MuIQIiK3nQEa1FUp3h12I8CY0GCb0rlNV8Qu-KPDpffOC-waDp-NRbcIMl-jqC-BwFVQPTXMOcehDwlAWTEhXli~c50lHrHQ__"
    ]
    
    let videos = [
        VideoItem(thumbnailURL: URL(string: "https://www.yourimageurl.com/video1.jpg")!,
                  title: "Official Trailer (Subtitled)", duration: "2:24", date: "23 days ago"),
        VideoItem(thumbnailURL: URL(string: "https://www.yourimageurl.com/video2.jpg")!,
                  title: "Exclusive Clip (Subtitled)", duration: "2:24", date: "27 days ago")
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Posters Section
                SectionHeaderView(title: "Posters")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(posters, id: \.self) { poster in
                            WebImage(url: URL(string: poster))
                                .resizable()
                                .frame(width: 120, height: 180)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Backdrops Section
                SectionHeaderView(title: "Backdrops")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(backdrops, id: \.self) { backdrop in
                            WebImage(url: URL(string: backdrop))
                                .resizable()
                                .frame(width: 250, height: 140)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
                
                VideosSection()
                
     
            }
            .padding(.top, 16)
        }
        .background(Color.black.ignoresSafeArea())
    }
}

struct SectionHeaderView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            NavigationLink(destination: PosterAndBackdropView()){
                HStack {
                    Text("View More")
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(.blue)
            }
            
           
        }
        .padding(.horizontal)
    }
}



#Preview {
    PhotosAndVideosTab()
}
