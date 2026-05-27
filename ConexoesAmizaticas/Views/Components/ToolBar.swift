//
//  ToolBar.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 26/05/26.
//

import SwiftUI

struct ToolBar: View {
    @Binding var vm: InicialViewModel
    
    var body: some View {
        ZStack {
            SemiCircle()
                .fill(Color.black)
                .frame(width: UIScreen.main.bounds.width, height: 100)
                .rotationEffect(.degrees(180))
            
            ProfileCircleAndName(vm: $vm, circleWidthMultiplier: 0.29, imageMultiplier: 0.25, fontSize: 20, isInitialView: true)
                .padding(.top, UIScreen.main.bounds.height * 0.32)
        }
    }
}

#Preview {
    @Previewable @State var viewModel = InicialViewModel()
    ToolBar(vm: $viewModel)
}
