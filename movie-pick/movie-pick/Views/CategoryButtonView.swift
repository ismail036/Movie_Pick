//
//  CategoryButtonView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct CategoryButtonView: View {
    var title: String
    var isMoreButton: Bool = false
    
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(isMoreButton ? .blue : .blue)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isMoreButton ? Color.clear : Color.blue.opacity(0.2))
            .cornerRadius(20)
            .fixedSize()
    }
}

#Preview {
    CategoryButtonView(title: "Action")
}

