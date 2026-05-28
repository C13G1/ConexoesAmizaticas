//
//  SemiCircle.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 26/05/26.
//

import SwiftUI

/// A primitive geometric shape representing the top or bottom half of a circle.
///
/// This shape traces an arc from 180 degrees to 0 degrees. It is structurally necessary to build the
/// custom `TabBar` and `ToolBar` components that frame the top and bottom edges of the main application screens.
struct SemiCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.maxY)
        let radius = rect.width / 2
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addArc(center: center,
                    radius: radius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(0),
                    clockwise: false)
        
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    SemiCircle()
}
