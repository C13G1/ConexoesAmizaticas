//
//  TextedRoundedRectangle.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 22/05/26.
//

import SwiftUI

/// A reusable component that pairs a descriptive label with a prominent data value inside a styled rectangle.
///
/// This component is heavily used in the `FriendsProfileView` to display connection metrics (like "days connected" or "last met")
/// uniformly. It supports dynamic typography adjustments via the `isTwelve` flag to fit tight spaces without breaking the layout.
struct TextedRoundedRectangle: View {
    let width          : CGFloat
    let height         : CGFloat
    let cornerRadius   : CGFloat
    let backGoundColor : Color

    let text           : String
    let textSize       : CGFloat
    let textWeight     : Font.Weight
    let textColor      : Color

    let subText        : String?
    let subTextSize    : CGFloat?
    let subTextWeight  : Font.Weight?
    let subTextColor   : Color
    
    /// A layout flag indicating if the primary text should be forced to 12pt for spacing constraints.
    let isTwelve       : Bool

    init(width: CGFloat = 107, height: CGFloat = 56,
         cornerRadius: CGFloat = 13, text: String,
         textSize: CGFloat = 12, textWeight: Font.Weight = Font.Weight.light, textColor: Color = Color.black,
         subText: String? = nil, subTextSize: CGFloat? = 20,
         subTextWeight: Font.Weight? = Font.Weight.black, subTextColor: Color = Color.black,
         backGoundColor: Color = Color.clear, isTwelve: Bool) {
        
        self.width          = width
        self.height         = height
        self.text           = text
        self.textSize       = textSize
        self.textWeight     = textWeight
        self.subText        = subText
        self.subTextSize    = subTextSize
        self.subTextWeight  = subTextWeight
        self.backGoundColor = backGoundColor
        self.cornerRadius   = cornerRadius
        self.subTextColor   = subTextColor
        self.textColor      = textColor
        self.isTwelve       = isTwelve
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .frame(width: width, height: height)
                .foregroundStyle(backGoundColor)
            VStack{
                Text(text)
                    .font(.customVariable(name: "Bolota", size: isTwelve ? 12 : 15, weight: .thin))
                    .font(.custom("Bolota", size: textSize))
                    .fontWeight(textWeight)
                    .foregroundStyle(textColor)
                
                if subText != nil {
                    Text(subText!)
                        .font(.custom("Bolota", size: subTextSize ?? 20))
                        .fontWeight(subTextWeight)
                        .foregroundStyle(subTextColor)
                }
            }
        }
    }
}

#Preview {
    TextedRoundedRectangle(text: "Text", subText: "Text", isTwelve: false)
}
