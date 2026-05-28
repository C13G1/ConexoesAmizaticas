//
//  InitialView.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 25/05/26.
//

import SwiftUI
import UIKit
import _SpriteKit_SwiftUI
import _SwiftData_SwiftUI

struct InitialView: View {
    @Environment(\.modelContext) private var modelContext
    @State var vm: InicialViewModel = InicialViewModel()
    @State private var selectedConnection: Connection?
    @State private var showVacuoView: Bool = false
    
    @Query private var connections: [Connection]
    @Query private var users: [User]
    
    var currentUser: User { users.first ?? User() }
    @State var navigation: NavigationPath = NavigationPath()
    
    @State private var scene: FriendsScene = {
        let s = FriendsScene(size: UIScreen.main.bounds.size, connections: Set(), sceneType: .initial)
        s.scaleMode = .aspectFill
        return s
    }()
    
    var body: some View {
        NavigationStack(path: $navigation) {
            ZStack {
                SpriteView(scene: scene, debugOptions: [])
                    .frame(height: UIScreen.main.bounds.height)
                
                ZStack {
                    ToolBar(vm: $vm)
                        .padding(.bottom, UIScreen.main.bounds.width * 2.28)
                    
                    TabBar(viewModel: $vm, user: currentUser)
                        .padding(.top, UIScreen.main.bounds.width * 2.15)
                }
                
                if connections.isEmpty {
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
            .navigationDestination(for: Connection.self) { value in
                FriendsProfileView(connection: value)
            }
            .navigationDestination(isPresented: $showVacuoView) {
                VacuoView()
            }
        }
        .onAppear {
            vm.setModelContext(modelContext: modelContext)
            vm.fetchData()
            NotificationManager.rescheduleAll(connections: connections)
            scene.onFriendTapped = { connection in
                selectedConnection = connection
                navigation.append(connection)
            }
            scene.onSpiralTapped = {
                showVacuoView = true
            }
        }
        .onChange(of: connections, initial: true) { _, newConnections in
            scene.updateConnections(receivedConnections: Set(newConnections.filter { !$0.inVacuo }))
            scene.updateNodeVisuals()
        }
        .onReceive(NotificationCenter.default.publisher(for: .meetingConfirmed)) { _ in
            scene.updateNodeVisuals()
        }
        .onReceive(NotificationCenter.default.publisher(for: .friendProfileUpdated)) { _ in
            scene.updateNodeVisuals()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(.lightBackground)
    }
}

#Preview {
    InitialView()
}
