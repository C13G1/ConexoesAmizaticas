//
//  FriendsView.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 20/05/26.
//

import SwiftUI
import SpriteKit
import SwiftData

struct FriendsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var connections: [Connection]
    @Query private var users: [User]

    #if DEBUG
    @State private var showDebugSheet = false
    #endif

    var scene: FriendsScene {
        let scene = FriendsScene(
            size: UIScreen.main.bounds.size,
            connections: Set(connections),
            sceneType: .initial
        )
        scene.scaleMode = .aspectFill
        return scene
    }

    var currentUser: User {
        users.first ?? User()
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // .id(connections.count) força o SpriteView a destruir e recriar
                // a cena toda vez que o número de amigos muda
                SpriteView(scene: scene, debugOptions: [])
                    .id(connections.count)
                    .ignoresSafeArea()

                HStack(alignment: .bottom) {
                    #if DEBUG
                    // Botão de deletar amigos — só aparece em builds de desenvolvimento
                    Button {
                        showDebugSheet = true
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 52, height: 52)
                                .foregroundStyle(Color.red.opacity(0.85))
                            Image(systemName: "trash")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.leading, 24)
                    .padding(.bottom, 40)
                    #endif

                    Spacer()

                    // Botão flutuante para adicionar amigo via BLE
                    NavigationLink(destination: BLEView(profile: currentUser)) {
                        ZStack {
                            Circle()
                                .frame(width: 60, height: 60)
                                .foregroundStyle(.themeYellow)
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(.black)
                        }
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 40)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.themeBackground)
            #if DEBUG
            .sheet(isPresented: $showDebugSheet) {
                debugSheet
            }
            #endif
        }
    }

    #if DEBUG
    private var debugSheet: some View {
        NavigationStack {
            List {
                ForEach(connections) { connection in
                    HStack(spacing: 12) {
                        if let uiImage = UIImage(data: connection.friend.profilePicture) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 40, height: 40)
                        } else {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.gray.opacity(0.3))
                        }
                        VStack(alignment: .leading) {
                            Text(connection.friend.name)
                                .font(.custom("Sora-SemiBold", size: 15))
                            Text("Score: \(Int(connection.metaManager.score))")
                                .font(.custom("Sora-Regular", size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(connections[index])
                    }
                }

                if connections.isEmpty {
                    Text("Nenhum amigo ainda")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Amigos (debug)")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Fechar") { showDebugSheet = false }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
    #endif
}

#Preview {
    FriendsView()
        .modelContainer(for: [User.self, Connection.self], inMemory: true)
}
