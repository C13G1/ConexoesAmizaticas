//
//  FriendAvatar.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 27/05/26.
//

import SwiftUI

/// A circular avatar that renders raw image data and falls back to the `defaultPicture` asset.
///
/// `FriendAvatar` centralizes the avatar rendering pattern used across the app: it decodes the raw `Data`,
/// scales to fill, clips to a circle and optionally adds a white stroke for screens with darker backgrounds.
struct FriendAvatar: View {
    let imageData: Data?
    let diameter: CGFloat
    var fallbackAssetName: String? = "defaultPicture"
    var strokeColor: Color? = nil
    var strokeWidth: CGFloat = 4

    var body: some View {
        Group {
            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else if let name = fallbackAssetName, let fallback = UIImage(named: name) {
                Image(uiImage: fallback)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.gray
            }
        }
        .frame(width: diameter, height: diameter)
        .clipShape(Circle())
        .overlay {
            if let strokeColor = strokeColor {
                Circle().stroke(strokeColor, lineWidth: strokeWidth)
            }
        }
    }
}
