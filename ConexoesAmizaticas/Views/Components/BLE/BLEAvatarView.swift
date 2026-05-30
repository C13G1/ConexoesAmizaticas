//
//  BLEAvatarView.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 15/05/26.
//

import SwiftUI

/// A circular avatar rendered from raw image data with a white stroke.
///
/// Falls back to the `defaultPicture` asset when the provided data cannot be decoded as a `UIImage`.
struct BLEAvatarView: View {
    let imageData: Data
    let diameter: CGFloat

    var body: some View {
        ZStack {
            Group {
                if let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else if let fallback = UIImage(named: "defaultPicture") {
                    Image(uiImage: fallback)
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(width: diameter, height: diameter)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 4)
            )
        }
    }
}
