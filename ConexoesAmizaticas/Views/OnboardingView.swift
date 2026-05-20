//
//  OnboardingView.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 20/05/26.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 64)
                .frame(width: 361, height: 493)
                .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 64))
            VStack {
                Text("Seja bem vindo!")
                    .font(.system(size: 36, weight: .bold))
                    .padding(.top, 42)
                Text("O Zelu é um aplicativo que vai revolucionar sua forma de cultivar seus relacionamentos.")
                    .font(.system(size: 15))
                
                
            }
                
        }
    }
}

#Preview {
    OnboardingView()
}
