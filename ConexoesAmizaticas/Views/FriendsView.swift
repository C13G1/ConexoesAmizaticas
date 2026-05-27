//
//  FriendTestView.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 20/05/26.
//

import SwiftUI
import SpriteKit

struct FriendsView: View {
    @Environment(\.modelContext) private var modelContext
    @State var vm: InicialViewModel!
    @State var friends: [Connection] = []
    var scene: FriendsScene {
        let scene = FriendsScene(size: UIScreen.main.bounds.size, connections: Set(friends), sceneType: .initial)
        scene.scaleMode = .aspectFill
        return scene
    }
    var body: some View {
        VStack {
            ZStack {
                SpriteView(scene: scene, debugOptions: [])
                    .ignoresSafeArea()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.themeBackground)
        .onAppear() {
            self.friends = vm.connectionsWithFriends
        }
    }
}

#Preview {
    FriendsView()
}
