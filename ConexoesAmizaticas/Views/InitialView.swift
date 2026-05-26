//
//  InitialView.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 25/05/26.
//

import SwiftUI

struct InitialView: View {
    @Environment(\.modelContext) private var modelContext
    @State var viewModel = InicialViewModel()
    
    init() {
        self.viewModel.setModelContext(modelContext: self.modelContext)
        self.viewModel.fetchData()
    }
    
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
