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

    @State private var searchText: String = ""
    @State private var showSearchBar: Bool = false
    @FocusState private var searchFocused: Bool

    @State private var scene: FriendsScene = FriendsScene(
        size: UIScreen.main.bounds.size,
        connections: Set(),
        sceneType: .initial
    )

    @State private var selectedConnection: Connection?
    @State private var showFriendActions: Bool = false
    @State private var showEditAlert: Bool = false
    @State private var editingName: String = ""

    @State private var showVacuoView: Bool = false

    #if DEBUG
    @State private var showDebugSheet = false
    #endif

    var currentUser: User { users.first ?? User() }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                SpriteView(scene: scene, debugOptions: [])
                    .ignoresSafeArea()

                if showSearchBar {
                    VStack {
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                            TextField("Procurar amigo", text: $searchText)
                                .focused($searchFocused)
                                .submitLabel(.search)
                            Button("Cancelar") {
                                showSearchBar = false
                                searchText = ""
                                scene.filterByName("")
                            }
                            .font(.custom("Sora-Regular", size: 14))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal, 16)
                        .padding(.top, 56)
                        Spacer()
                    }
                    .ignoresSafeArea(edges: .top)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                HStack(alignment: .bottom) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) { showSearchBar = true }
                        searchFocused = true
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 60, height: 60)
                                .foregroundStyle(.white.opacity(0.9))
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(.black)
                        }
                    }
                    .padding(.leading, 24)
                    .padding(.bottom, 40)

                    Spacer()

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
            .onChange(of: connections) { _, newConnections in
                scene.updateConnections(receivedConnections: Set(newConnections.filter { !$0.inVacuo }))
                scene.updateNodeVisuals()
                scene.filterByName(searchText)
            }
            .onChange(of: searchText) { _, newText in
                scene.filterByName(newText)
            }
            .onChange(of: searchFocused) { _, focused in
                if !focused {
                    withAnimation(.easeInOut(duration: 0.2)) { showSearchBar = false }
                }
            }
            .onAppear {
                scene.updateConnections(receivedConnections: Set(connections.filter { !$0.inVacuo }))
                scene.updateNodeVisuals()
                scene.onFriendTapped = { connection in
                    selectedConnection = connection
                    editingName = connection.friend.name
                    showFriendActions = true
                }
                scene.onSpiralTapped = {
                    showVacuoView = true
                }
            }
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
                            Text("Score: \(Int(connection.metaManager.score)) — \(connection.metaManager.currentRelationshipState.rawValue)")
                                .font(.custom("Sora-Regular", size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet { modelContext.delete(connections[index]) }
                }
                if connections.isEmpty {
                    Text("Nenhum amigo ainda").foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Amigos (debug)")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Fechar") { showDebugSheet = false } }
                ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
            }
        }
    }
    #endif
}

#Preview {
    FriendsView()
        .modelContainer(for: [User.self, Connection.self], inMemory: true)
}
