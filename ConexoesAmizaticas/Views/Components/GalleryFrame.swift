//
//  GalleryFrame.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 22/05/26.
//

import SwiftUI

struct GalleryFrame: View {
    let imageData: Data
    
    var body: some View {
        if let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.45,
                       height: UIScreen.main.bounds.height * 0.25)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.white, lineWidth: 4)
                )
        } else {
            RoundedRectangle(cornerRadius: 16)
                .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.25)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    let mockImage = UIImage(named: "gallery")!
    let mockData = mockImage.pngData() ?? Data()
    return GalleryFrame(imageData: mockData)
        .preferredColorScheme(.dark)
}
