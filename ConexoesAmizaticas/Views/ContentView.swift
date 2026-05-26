//
//  ContentView.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 14/05/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        InitialView()
    }
}

#Preview {
    ContentView()
}
