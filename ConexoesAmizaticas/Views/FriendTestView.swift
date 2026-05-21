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
        let scene = FriendsScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        return scene
    }
    var body: some View {
        SpriteView(scene: scene, debugOptions: [.showsFPS])
            .ignoresSafeArea()
    }
}

#Preview {
    FriendTestView()
}
