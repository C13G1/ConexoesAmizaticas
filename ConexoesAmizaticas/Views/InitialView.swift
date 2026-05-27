//
//  InitialView.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 25/05/26.
//

import SwiftUI
import UIKit
import _SpriteKit_SwiftUI

struct InitialView: View {
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
        Connection(friend: User(profilePicture: UIImage(named: "BrotherdoDesertoAcho")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
    ]
    
    var scene: FriendsScene {
        let scene = FriendsScene(size: UIScreen.main.bounds.size, connections: friends)
//        scene.scaleMode = .aspectFill
        return scene
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                SpriteView(scene: scene, debugOptions: [])
                    .frame(height: UIScreen.main.bounds.height)
                
                ZStack {
                    ToolBar()
                        .padding(.bottom, UIScreen.main.bounds.width * 2.28)
                    
                    TabBar()
                        .padding(.top, UIScreen.main.bounds.width * 2.15)
                }
                
                if let _ = vm {
                    if vm.connectionsWithFriends.count == 0 {
                        ZStack {
                            VStack (spacing: 20){
                                Text("Bem Vindo Ao Zelu")
                                    .font(.custom("Bolota", size: 32))
                                
                                Text("adicione seus amigos para iniciar")
                                    .font(.custom("Sora-Regular", size: 20))
                                    .multilineTextAlignment(.center)
                                    .frame(width: UIScreen.main.bounds.width * 0.6)
                                
                            }
                            .foregroundStyle(.addFriendsText)
                            
                            Image("roundArrowAddFriends")
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width * 0.22, height: UIScreen.main.bounds.height * 0.1)
                                .padding(.leading, UIScreen.main.bounds.width * 0.6)
                                .padding(.top, UIScreen.main.bounds.height * 0.2)
                        }
                        .padding(.top, UIScreen.main.bounds.height * 0.3)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(.lightBackground)
        .onAppear() {
            self.vm = InicialViewModel(modelContext: self.modelContext)
            self.friends = vm.connectionsWithFriends
        }
    }
}

#Preview {
    InitialView()
}
