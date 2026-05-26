//
//  InitialView.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 25/05/26.
//

import SwiftUI

struct InitialView: View {
    var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .center){
                Spacer()
                Text("oie")
//                TabBarComponent(geometry: geometry)
            }
        }
    }
}

#Preview {
    InitialView()
}
