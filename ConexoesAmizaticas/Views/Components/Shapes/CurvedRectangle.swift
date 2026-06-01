//
//  CurvedRectangle.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 23/05/26.
//

import SwiftUI

/// A custom geometric shape representing a rectangle with a single curved edge.
///
/// This shape uses a quadratic Bézier curve to create a "smile" or "frown" effect along its bottom edge,
/// dictated by the `depth` parameter. It is primarily used as the structural base for custom buttons and overlays.
struct CurvedRectangle: Shape {
    /// Determines the intensity of the curve. A positive value pulls the curve downward, while a negative value pushes it upward.
    var depth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY),
            control: CGPoint(x: rect.midX, y: rect.maxY * depth)
        )
        
        return path
    }
}
