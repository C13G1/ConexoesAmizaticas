//
//  BLEAvatarsLayer.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 27/05/26.
//

import SwiftUI

/// Positions the two circular avatars of the `BLEView`: the friend's avatar slides in from above
/// when a match is detected, while the user's own avatar stays anchored at the bottom.
struct BLEAvatarsLayer: View {
    let size: CGSize
    let profileImageData: Data
    let friendImageData: Data?
    let phase: BLEViewModel.Phase
    let avatarDiameter: CGFloat
    let topY: CGFloat
    let bottomY: CGFloat

    var body: some View {
        let centerX = size.width / 2

        ZStack {
            if let friendImageData = friendImageData {
                FriendAvatar(
                    imageData: friendImageData,
                    diameter: avatarDiameter,
                    strokeColor: .white
                )
                .scaleEffect(phase == .searching ? 0.8 : 1.0)
                .position(
                    x: centerX,
                    y: phase == .searching ? -avatarDiameter : topY
                )
            }

            FriendAvatar(
                imageData: profileImageData,
                diameter: avatarDiameter,
                strokeColor: .white
            )
            .position(x: centerX, y: bottomY)
        }
    }
}
