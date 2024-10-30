//
//  CategoryButtonView.swift
//  movie-pick
//
//  Created by İsmail Parlak on 21.10.2024.
//

import SwiftUI

struct CategoryButtonView: View {
    var title: String
    var isSelected: Bool
    var onRemove: (() -> Void)? // Seçimi iptal etme eylemi

    var body: some View {
        HStack(spacing: 5) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isSelected ? .white : .blue)
            
            if isSelected {
                Button(action: {
                    onRemove?()
                }) {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                        .foregroundColor(.white)
                        .padding(.leading,5)
                    
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(isSelected ? Color.blue : Color.blue.opacity(0.2))
        .cornerRadius(20)
        .fixedSize()
    }
}


#Preview {
    CategoryButtonView(title:"Action", isSelected: true)
}
