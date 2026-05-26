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
    @State var friends: [Connection] = [
        Connection(friend: User(profilePicture: UIImage(named: "BrotherdoDesertoAcho")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "DarthVader")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "YodaFantasma")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "C3PO")!.jpegData(compressionQuality: 1)!), score:
            Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "CaraAzul")!.jpegData(compressionQuality: 1)!), score:
            Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "Slavei")!.jpegData(compressionQuality: 1)!), score:
            Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "Careca")!.jpegData(compressionQuality: 1)!), score:
            Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "JarJarBinks")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "BrotherdoDesertoAcho")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),]
    var scene: FriendsScene {
        let scene = FriendsScene(size: UIScreen.main.bounds.size, connections: friends)
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
            self.vm = InicialViewModel(modelContext: self.modelContext)
            self.friends = vm.connectionsWithFriends
        }
    }
}

#Preview {
    FriendsView()
}
