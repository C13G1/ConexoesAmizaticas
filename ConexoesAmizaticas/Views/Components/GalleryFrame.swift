//
//  GalleryFrame.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 22/05/26.
//

import SwiftUI

struct GalleryFrame: View {
    @Binding var user: User
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.white, lineWidth: 4)
                .frame(width: UIScreen.main.bounds.width * 0.47, height: UIScreen.main.bounds.height * 0.258)
                .overlay(
                    Image(uiImage: UIImage(data: user.profilePicture)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.25)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                )
        }
    }
}

#Preview {
    let mockImage = UIImage(named: "gallery")!
    let mockImageData = mockImage.jpegData(compressionQuality: 1)!
    
    let mockUser = User(profilePicture: mockImageData)
    GalleryFrame(user: .constant(mockUser))
}
