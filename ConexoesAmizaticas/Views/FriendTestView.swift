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
        let scene = FriendsScene(size: UIScreen.main.bounds.size, orbit: false)
        scene.scaleMode = .aspectFill
        return scene
    }
    var body: some View {
        VStack {
            ZStack {
                SpriteView(scene: scene, debugOptions: [.showsPhysics])
                    .ignoresSafeArea()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.themeBackground)
    }
}

#Preview {
    FriendTestView()
}
