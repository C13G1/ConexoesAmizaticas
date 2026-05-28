//
//  VacuoView.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 24/05/26.
//

import SwiftUI
import SwiftData
import SpriteKit
import UserNotifications


/// A dedicated recovery environment for deeply decayed friendships.
///
/// `VacuoView` isolates connections that have surpassed the critical inactivity threshold (the "vacuum").
/// It utilizes a distinct SpriteKit scene (`VoidScene`) to emphasize distance and provides an explicit interface
/// for the user to either rescue the connection by registering a new meeting or let the connection expire.
struct VacuoView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var allConnections: [Connection]

    @State private var showInfo = false
    @State private var focusedConnection: Connection?

    @State private var voidScene: FriendsScene = {
        let s = FriendsScene(size: UIScreen.main.bounds.size, connections: Set(), sceneType: .search)
        s.backgroundColor = .clear
        return s
    }()

    /// Filters the database to exclusively show connections exceeding the vacuum threshold limit.
    private var vacuumConnections: [Connection] {
        allConnections.filter { $0.inVacuo }
    }

    var body: some View {
        ZStack {
            ZStack {
                Color.vacuoBackground.ignoresSafeArea()

                Image("vacuo")
                    .frame(width: 280, height: 280)
                    .padding(.trailing, 80)
                    .padding(.bottom, 40)

                SpriteView(scene: voidScene, options: [.allowsTransparency])
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24, weight: .regular))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        Button(action: { showInfo = true }) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)

                    Spacer().frame(height: 10)

                    Image("void")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.04)
                        .padding(.bottom)

                    Spacer()

                    if vacuumConnections.isEmpty {
                        Text("Você não tem nenhum\namigo no vácuo")
                            .font(.system(size: 24, weight: .medium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(maxWidth: 300)
                            .padding(.bottom, 20)
                    }

//                    #if DEBUG
//                    Button("Simular amigo no vácuo (teste)") {
//                        let mockUser = User(
//                            name: "Amigo Vácuo",
//                            profilePicture: UIImage(named: "defaultPicture")?.jpegData(compressionQuality: 0.8) ?? Data()
//                        )
//                        let connection = Connection(friend: mockUser, score: 0)
//                        modelContext.insert(mockUser)
//                        modelContext.insert(connection)
//                    }
//                    .font(.custom("Sora-Regular", size: 13))
//                    .foregroundStyle(.white.opacity(0.6))
//
//                    Button("Testar notificação de meta (5s)") {
//                        let content = UNMutableNotificationContent()
//                        content.title = "Tá na hora de marcar um rolê!"
//                        content.body = "Você prometeu se encontrar com Amigo Teste mensalmente. O prazo está chegando!"
//                        content.sound = .default
//                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//                        let request = UNNotificationRequest(identifier: "debug_meta_test", content: content, trigger: trigger)
//                        UNUserNotificationCenter.current().add(request)
//                    }
//                    .font(.custom("Sora-Regular", size: 13))
//                    .foregroundStyle(.white.opacity(0.6))
//
//                    Button("Testar notificação de proximidade (5s)") {
//                        let content = UNMutableNotificationContent()
//                        content.title = "Alguém com Zelu está por perto!"
//                        content.body = "Abra o app para registrar um encontro com seu amigo."
//                        content.sound = .default
//                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//                        let request = UNNotificationRequest(identifier: "debug_proximity_test", content: content, trigger: trigger)
//                        UNUserNotificationCenter.current().add(request)
//                    }
//                    .font(.custom("Sora-Regular", size: 13))
//                    .foregroundStyle(.white.opacity(0.6))
//                    .padding(.bottom, 20)
//                    #endif
                }
            }
            .blur(radius: focusedConnection != nil ? 10 : 0)

            if showInfo {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture { showInfo = false }
                VStack(alignment: .leading) {
                    HStack {
                        Text("Informações")
                            .font(.custom("Sora-SemiBold", size: 18))
                            .foregroundColor(.white)
                        Spacer()
                        Button { showInfo = false } label: {
                            Image(systemName: "xmark").foregroundColor(.white)
                        }
                    }
                    .padding(20)
                    Text("Amigos entram no vácuo quando você fica mais de 30 dias sem se encontrar com eles. Após mais 30 dias no vácuo, a conexão é perdida e será preciso recomeçar do zero.")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
            }

            //overlay
            if let connection = focusedConnection {
                Rectangle()
                    .ignoresSafeArea()
                    .opacity(0.6)
                VStack {
                    ZStack {
                        Circle()
                            .foregroundStyle(.red)
                            .frame(width: 140, height: 140)
                        if let uiImage = UIImage(data: connection.friend.profilePicture) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 132, height: 132)
                        }
                    }
                    Text("Você deixou \(connection.friend.name) no vácuo")
                        .padding(.top, 16)
                        .font(.custom("Sora-Bold", size: 16))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    Text("QUER RESGATAR ESSE CONTATO?")
                        .foregroundStyle(.white)
                        .font(.custom("Bolota", size: 24))
                        .fontWeight(.bold)
                        .frame(width: 222)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                    Text("Contatos ficam no vácuo por até 30 dias. Depois disso, a conexão é perdida e será preciso recomeçar do zero.")
                        .font(.custom("Sora-Light", size: 12))
                        .foregroundStyle(.white)
                        .frame(width: 206)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                    HStack {
                        Button {
                            focusedConnection = nil
                        } label: {
                            ZStack {
                                Circle().foregroundStyle(.themeAfastados)
                                Image(systemName: "xmark")
                                    .resizable().frame(width: 32, height: 32)
                                    .foregroundStyle(.white).bold()
                            }
                        }
                        .frame(width: 72, height: 72)

                        Button {
                            resgatarContato(connection)
                        } label: {
                            ZStack {
                                Circle().foregroundStyle(.white)
                                Image(systemName: "checkmark")
                                    .resizable().frame(width: 32, height: 32)
                                    .foregroundStyle(.black).bold()
                            }
                        }
                        .frame(width: 72, height: 72)
                        .padding(.leading, 128)
                    }
                    .padding(.top, 67)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            voidScene.updateConnections(receivedConnections: Set(vacuumConnections))
            voidScene.onFriendTapped = { connection in
                focusedConnection = connection
            }
        }
        .onChange(of: allConnections) { _, _ in
            voidScene.updateConnections(receivedConnections: Set(vacuumConnections))
        }
    }

    /// Restores a connection from the vacuum state back to active status by artificially updating the last met date.
    private func resgatarContato(_ connection: Connection) {
        connection.lastMet = Date.now
        connection.metaManager.addOrSubtractScore(5)
        try? modelContext.save()
        NotificationManager.scheduleMetaReminder(for: connection)
        NotificationCenter.default.post(name: .meetingConfirmed, object: nil)
        focusedConnection = nil
        voidScene.updateConnections(receivedConnections: Set(vacuumConnections))
    }
}

#Preview {
    VacuoView()
        .modelContainer(for: [User.self, Connection.self, MetaManager.self, FeedManager.self], inMemory: true)
}
