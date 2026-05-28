//
//  Font.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 27/05/26.
//

import SwiftUI

extension Font {
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
