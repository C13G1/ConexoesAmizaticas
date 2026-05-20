//
//  FriendTestView.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 20/05/26.
//

import SwiftUI
import SpriteKit

struct FriendTestView: View {
    var scene: FriendsScene {
        let scene = FriendsScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    var body: some View {
        SpriteView(scene: scene, debugOptions: [.showsPhysics])
    }
}

#Preview {
    FriendTestView()
}
