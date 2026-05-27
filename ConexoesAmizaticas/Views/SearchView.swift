//
//  SearchView.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 25/05/26.
//

import SwiftData
import SwiftUI
import SpriteKit

struct SearchView: View {
    @Binding var viewModel: InicialViewModel
    @State private var searchText: String = ""
    @State var navPath: NavigationPath = NavigationPath()
    @State var reloadScreen: Bool = false
    @State private var selectedConnection: Connection?
    
    @Query private var connections: [Connection]
    @Query private var users: [User]
    
    @FocusState private var isFocused: Bool
    
    var scene: FriendsScene = {
        let scene = FriendsScene(size: UIScreen.main.bounds.size, connections: Set(), sceneType: .search)
        scene.scaleMode = .aspectFill
        return scene
    }()
    
    var searchResults: [Connection] {
        print("returning results")
        if searchText.isEmpty {
            return []
        } else {
            let results = viewModel.connectionsWithFriends.filter { c in
                c.friend.name.localizedStandardContains(searchText)
            }
            return results
        }
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
            ZStack {
                SpriteView(scene: scene, debugOptions: [])
                    .ignoresSafeArea()
                    .tag("searchView")
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .navigationDestination(for: Connection.self) { value in
                FriendsProfileView(connection: value, inicialViewModel: viewModel)
            }
        }
        .onAppear {
            scene.updateConnections(receivedConnections: Set(viewModel.connectionsWithFriends))
            scene.onFriendTapped = { connection in
                selectedConnection = connection
                navPath.append(connection)
            }
        }
        .onChange(of: connections) { _, newConnections in
            scene.updateConnections(receivedConnections: Set(newConnections.filter { !$0.inVacuo }))
            scene.updateNodeVisuals()
        }
        .onChange(of: searchText, {
            let updatedFriends: Set<Connection> = Set(searchResults)
            print("passing friends to func:\n\(updatedFriends)")
            self.scene.updateConnections(receivedConnections: updatedFriends)
        })
    }
}


#Preview {
    @Previewable @State var viewModel = InicialViewModel()
    SearchView(viewModel: $viewModel)
        .modelContainer(for: [
            User.self,
            Post.self,
            FeedManager.self,
            Connection.self,
            MetaManager.self,
        ])
}
