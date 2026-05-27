//
//  BLEView.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 15/05/26.
//

import SwiftUI
import CoreBluetooth
import SwiftData

struct BLEView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var bleManager: BLEManager?
    @State private var friend: User?
    @State private var foundFriend: Bool = false

    let profile: User

    var body: some View {
        VStack(spacing: 0) {
            if foundFriend, let friend = friend {
                foundFriendView(friend: friend)
            } else {
                searchingView
            }

            // Foto do usuário atual — pressionar e segurar confirma o encontro
            if foundFriend, let friend = friend {
                confirmButton(friend: friend)
                    .padding(.top, 40)
                    .padding(.bottom, 60)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            let manager = BLEManager(profile: profile)
            manager.onConnectionOpened = {
                self.foundFriend = true
            }
            manager.onFriendFound = { receivedFriend in
                self.friend = receivedFriend
            }
            self.bleManager = manager
            manager.startBLE()
        }
        .onDisappear {
            bleManager?.stopBLE()
        }
        .navigationTitle("Adicionar amigo")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: — Tela de busca

    private var searchingView: some View {
        VStack(spacing: 32) {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Text("Buscando contatos por perto...")
                .font(.custom("Sora-ExtraBold", size: 28))
                .multilineTextAlignment(.center)
                .frame(width: 270)
            Spacer()

            #if DEBUG
            Button("Simular encontro (teste)") {
                let mock = User(
                    name: "Amigo Teste",
                    profilePicture: UIImage(named: "defaultPicture")?.jpegData(compressionQuality: 0.8) ?? Data()
                )
                self.friend = mock
                self.foundFriend = true
            }
            .font(.custom("Sora-Regular", size: 14))
            .foregroundStyle(.secondary)
            .padding(.bottom, 40)
            #endif
        }
    }

    // MARK: — Tela de amigo encontrado

    private func foundFriendView(friend: User) -> some View {
        VStack(spacing: 24) {
            Spacer()
            ZStack {
                Circle()
                    .frame(width: 148, height: 148)
                    .foregroundStyle(.themeYellow)
                if let uiImage = UIImage(data: friend.profilePicture) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 132, height: 132)
                }
            }

            Text("Parece que você e \(friend.name) se encontraram!")
                .font(.custom("Sora-ExtraBold", size: 28))
                .frame(width: 280)
                .multilineTextAlignment(.center)

            Text("Pressione e segure sua foto para confirmar o encontro.")
                .font(.custom("Sora-Regular", size: 16))
                .multilineTextAlignment(.center)
                .frame(width: 280)
                .foregroundStyle(.secondary)

            Button("Procurar por outra pessoa") {
                self.foundFriend = false
                self.friend = nil
                bleManager?.startBLE()
            }
            .font(.custom("Sora-Bold", size: 14))
            .foregroundStyle(.themeEstaveis)

            Spacer()
        }
    }

    // MARK: — Botão de confirmação (pressionar e segurar)

    @State private var isHolding = false
    @State private var holdProgress: CGFloat = 0

    private func confirmButton(friend: User) -> some View {
        ZStack {
            Circle()
                .stroke(Color.themeYellow.opacity(0.3), lineWidth: 8)
                .frame(width: 156, height: 156)
            Circle()
                .trim(from: 0, to: holdProgress)
                .stroke(Color.themeYellow, lineWidth: 8)
                .frame(width: 156, height: 156)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.05), value: holdProgress)
            Circle()
                .frame(width: 148, height: 148)
                .foregroundStyle(.themeYellow)
            if let uiImage = UIImage(data: profile.profilePicture) {
                Image(uiImage: uiImage)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 132, height: 132)
            }
        }
        .scaleEffect(isHolding ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isHolding)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isHolding {
                        isHolding = true
                        startHoldTimer(friend: friend)
                    }
                }
                .onEnded { _ in
                    isHolding = false
                    holdProgress = 0
                }
        )
    }

    private func startHoldTimer(friend: User) {
        holdProgress = 0
        let steps = 20
        let stepDuration = 1.5 / Double(steps)
        var current = 0

        Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { timer in
            guard isHolding else {
                timer.invalidate()
                holdProgress = 0
                return
            }
            current += 1
            holdProgress = CGFloat(current) / CGFloat(steps)
            if current >= steps {
                timer.invalidate()
                confirmFriend(friend)
            }
        }
    }

    private func confirmFriend(_ friend: User) {
        modelContext.insert(friend)
        let connection = Connection(friend: friend)
        modelContext.insert(connection)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        BLEView(profile: User())
    }
    .modelContainer(for: [User.self, Connection.self], inMemory: true)
}
