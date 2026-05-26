//
//  AddImagesComponent.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 22/05/26.
//

import SwiftUI

struct AddImagesComponent: View {
    
    var body: some View {
        VStack{
            Button {
                print("Oi")
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 13)
                        .frame(width: 20, height: 20)
                    Text("adicionar mídia")
                        
                    
                }
                
            }

        }
    }
}

#Preview {
    AddImagesComponent()
}
