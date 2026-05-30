//
//  SearchView.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 25/05/26.
//

import SwiftData
import SwiftUI
import SpriteKit

/// A specialized exploratory view utilizing a text-based filter over the physical simulation.
///
/// `SearchView` repurposes the `FriendsScene` as a dynamic background that reacts in real-time to the
/// SwiftUI `.searchable` modifier. It filters the visible connections in the scene, effectively blending
/// traditional list-searching paradigms with spatial node interaction.
struct SearchView: View {
    @Binding var viewModel: InitialViewModel
    @State private var searchText: String = ""
    @State var navPath: NavigationPath = NavigationPath()
    @State var reloadScreen: Bool = false
    @State private var selectedConnection: Connection?
    
    @Query private var connections: [Connection]
    @Query private var users: [User]

    @FocusState private var isFocused: Bool

    @State private var scene: FriendsScene = {
        let scene = FriendsScene(size: UIScreen.main.bounds.size, connections: Set(), sceneType: .search)
        scene.scaleMode = .aspectFill
        return scene
    }()
    
    /// Computes the subset of connections matching the active search query.
    var searchResults: [Connection] {
        if searchText.isEmpty {
            return []
        } else {
            return connections.filter { c in
                c.friend.name.localizedStandardContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
            ZStack {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
                    .tag("searchView")
                
                if !searchText.isEmpty && searchResults.isEmpty {
                    Text("Você não tem nenhum contato com esse nome")
                        .font(.custom("Sora-Regular", size: 24))
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                        .multilineTextAlignment(.center)
                }
            }
            .background(Color.lightBackground)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .navigationDestination(for: Connection.self) { value in
                FriendsProfileView(connection: value)
            }
        }
        .onAppear {
            scene.updateConnections(receivedConnections: Set(connections.filter { !$0.inVacuo }))
            scene.onFriendTapped = { connection in
                selectedConnection = connection
                navPath.append(connection)
            }
        }
        .onChange(of: connections) { _, newConnections in
            scene.updateConnections(receivedConnections: Set(newConnections.filter { !$0.inVacuo }))
            scene.updateNodeVisuals()
        }
        .onChange(of: searchText) {
            scene.filterByName(searchText)
        }
    }
}


#Preview {
    @Previewable @State var viewModel = InitialViewModel()
    SearchView(viewModel: $viewModel)
        .modelContainer(for: [
            User.self,
            Post.self,
            FeedManager.self,
            Connection.self,
            MetaManager.self,
        ])
}
