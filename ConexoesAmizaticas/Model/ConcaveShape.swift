//
//  ConcaveShape.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 22/05/26.
//

import Foundation
import SwiftUI

struct ConcaveShape: Shape{
    func path(in rect: CGRect) -> Path {
        var path        = Path()
        var initalPoint = CGPoint(x: rect.minX, y: rect.minY)
        
        path.move(to: initalPoint)
//        path.addArc(
//            center: CGPoint(x: rect.midX, y: rect.maxY),
//            radius: rect.width / 4,
//            startAngle: Angle(degrees: 10),
//            endAngle: Angle(degrees: 10),
//            clockwise: false
//        )
        
//        path.addQuadCurve(to: CGPoint(x: rect.width, y: 0),
//                          control: CGPoint(x: rect.width / 2, y: rect.height * 2))
        
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: initalPoint)
        
        path.closeSubpath()
       
        return path
    }
}

#Preview{
    FriendsProfileView()
}
