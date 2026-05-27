//
//  ContentView.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 14/05/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // Verifica se o perfil do usuário já foi criado
    @Query private var users: [User]

    var body: some View {
        if users.isEmpty {
            OnboardingView()
        } else {
            FriendsView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [User.self, Connection.self], inMemory: true)
}
