//
//  VesicaShape.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 27/05/26.
//

import SwiftUI

/// A `Shape` formed by two overlapping circles that, when filled with `eoFill`,
/// punches the intersection out to reveal whatever sits below it.
///
/// This forms the horizontal "vesica/lens" silhouette joining the user's avatar and the friend's avatar
/// during the press-and-hold confirmation in `BLEView`.
struct VesicaShape: Shape {
    let topRect: CGRect
    let bottomRect: CGRect

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: topRect)
        path.addEllipse(in: bottomRect)
        return path
    }
}
