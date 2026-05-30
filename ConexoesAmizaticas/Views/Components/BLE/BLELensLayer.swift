//
//  BLELensLayer.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 27/05/26.
//

import SwiftUI

/// Draws two growing white circles joined by an even-odd `VesicaShape` fill that reveals the dark background
/// through the intersection, producing the horizontal "vesica/lens" silhouette of the confirmation gesture.
struct BLELensLayer: View {
    let size: CGSize
    let phase: BLEViewModel.Phase
    let holdProgress: CGFloat
    let avatarDiameter: CGFloat
    let topY: CGFloat
    let bottomY: CGFloat

    var body: some View {
        let centerX = size.width / 2
        let halfDistance = (bottomY - topY) / 2
        let startRadius: CGFloat = (avatarDiameter + 14) / 2
        let endRadius: CGFloat = halfDistance + 80
        let radius = startRadius + (endRadius - startRadius) * holdProgress

        let topRect = CGRect(
            x: centerX - radius, y: topY - radius,
            width: radius * 2, height: radius * 2
        )
        let bottomRect = CGRect(
            x: centerX - radius, y: bottomY - radius,
            width: radius * 2, height: radius * 2
        )

        VesicaShape(topRect: topRect, bottomRect: bottomRect)
            .fill(Color.white, style: FillStyle(eoFill: true))
            .opacity(phase == .confirmed ? 0 : 1)
    }
}
