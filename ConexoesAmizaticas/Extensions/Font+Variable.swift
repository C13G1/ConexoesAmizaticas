//
//  Font+Variable.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 27/05/26.
//

import SwiftUI

extension Font {
    /// Generates a SwiftUI `Font` from a TrueType Variable Font file, targeting a specific weight axis.
    ///
    /// Since iOS SwiftUI does not natively expose variable font axes easily, this extension drops down to `UIFontDescriptor`
    /// to force the CoreText engine to render the specific weight trait before wrapping it back into a SwiftUI `Font`.
    ///
    /// - Parameters:
    ///   - name: The exact registered family name of the variable font (e.g., "Bolota").
    ///   - size: The point size of the font.
    ///   - weight: The specific `UIFont.Weight` to extract from the variable axes.
    /// - Returns: A SwiftUI-compatible font instance.
    static func customVariable(name: String, size: CGFloat, weight: UIFont.Weight) -> Font {
        let descriptor = UIFontDescriptor(name: name, size: size)
            .addingAttributes([
                UIFontDescriptor.AttributeName.traits: [
                    UIFontDescriptor.TraitKey.weight: weight
                ]
            ])
        
        let uiFont = UIFont(descriptor: descriptor, size: size)
        return Font(uiFont)
    }
}
