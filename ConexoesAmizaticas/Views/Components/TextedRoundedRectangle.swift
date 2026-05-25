//
//  TextedRoundedRectangle.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 22/05/26.
//

import SwiftUI

struct TextedRoundedRectangle: View {
    let width          : CGFloat
    let height         : CGFloat
    let cornerRadius   : CGFloat
    let backGoundColor : Color

    let text           : String
    let textSize       : Font
    let textWeight     : Font.Weight
    
    let subText        : String?
    let subTextSize    : Font?
    let subTextWeight  : Font.Weight?

    init(width: CGFloat = 165, height: CGFloat = 66,
         cornerRadius: CGFloat = 13, text: String,
         textSize: Font = Font.system(size: 15),textWeight: Font.Weight = Font.Weight.light,
         subText: String? = nil, subTextSize: Font? = Font.system(size: 24),
         subTextWeight: Font.Weight? = Font.Weight.black,
         backGoundColor: Color = Color.backgoundGreen) {
        
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
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .frame(width: width, height: height)
                .foregroundStyle(backGoundColor)
            VStack{
                Text(text)
                    .font(textSize)
                    .fontWeight(textWeight)
                    .foregroundStyle(.black)
                if subText != nil {
                    Text(subText!)
                        .font(subTextSize)
                        .fontWeight(subTextWeight)
                        .foregroundStyle(.black)
                }
            }
            
        }
    }
}

#Preview {
    TextedRoundedRectangle(text: "Text", subText: "Text")
}
