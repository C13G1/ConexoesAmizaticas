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
        let scene = FriendsScene(size: UIScreen.main.bounds.size, orbit: true)
        scene.scaleMode = .resizeFill
        return scene
    }
    var body: some View {
        VStack(alignment: .center) {
            SpriteView(scene: scene, debugOptions: [])
                .ignoresSafeArea()
        }
        .clipShape(Circle())
        .frame(width: 1000, height: 1000)
            
    }
}

#Preview {
    FriendTestView()
}
