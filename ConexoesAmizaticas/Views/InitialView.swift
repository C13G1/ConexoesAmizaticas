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
    @State var vm: InicialViewModel = InicialViewModel()
    
    var scene: FriendsScene = {
        let scene = FriendsScene(size: UIScreen.main.bounds.size, connections: Set(), sceneType: .initial)
        scene.scaleMode = .aspectFill
        return scene
    }()
    
    var body: some View {
        NavigationStack {
            ZStack {
                SpriteView(scene: scene, debugOptions: [])
                    .frame(height: UIScreen.main.bounds.height)
                
                ZStack {
                    ToolBar()
                        .padding(.bottom, UIScreen.main.bounds.width * 2.28)
                    
                    TabBar(viewModel: $vm)
                        .padding(.top, UIScreen.main.bounds.width * 2.15)
                }
                
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
        .onAppear {
            scene.updateConnections(receivedConnections: Set(vm.connectionsWithFriends))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(.lightBackground)
    }
}

#Preview {
    InitialView()
}
