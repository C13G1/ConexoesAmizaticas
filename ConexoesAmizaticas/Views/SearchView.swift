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
    @FocusState private var isFocused: Bool
    @State var navPath: NavigationPath = NavigationPath()
    @State var reloadScreen: Bool = false
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
        NavigationStack {
            ZStack {
                SpriteView(scene: scene, debugOptions: [.showsPhysics, .showsNodeCount, .showsDrawCount])
                    .ignoresSafeArea()
                    .tag("searchView")
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .onChange(of: searchText, {
                let updatedFriends: Set<Connection> = Set(searchResults)
                print("passing friends to func:\n\(updatedFriends)")
                self.scene.updateConnections(receivedConnections: updatedFriends)
            })
            .navigationDestination(for: Connection.self) { value in
                FriendsProfileView(connection: value)
            }
        }
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
