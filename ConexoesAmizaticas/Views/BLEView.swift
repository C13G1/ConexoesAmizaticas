//
//  BLEView.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 15/05/26.
//

import SwiftUI
import CoreBluetooth
import SwiftData

/// The proximity-based discovery and pairing screen.
///
/// `BLEView` serves as the UI layer for the `BLEManager`. It handles the transition between the "searching" state
/// and the "found" state when another user is nearby. It is responsible for resolving the interaction by either
/// creating a brand new `Connection` in the database or registering a new meeting for an existing friendship.
struct BLEView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var existingConnections: [Connection]

    @State private var bleManager: BLEManager?
    @State private var friend: User?
    @State private var foundFriend: Bool = false

    /// The profile of the device owner, broadcasted to nearby peers.
    let profile: User

    /// Evaluates if the discovered peer is already a saved connection to determine the subsequent action (create vs. update).
    private var existingConnection: Connection? {
        guard let friend = friend else { return nil }
        return existingConnections.first { $0.friend.id == friend.id }
    }
    private var isExistingFriend: Bool { existingConnection != nil }

    var body: some View {
        VStack(spacing: 0) {
            if foundFriend, let friend = friend {
                foundFriendView(friend: friend)
            } else {
                searchingView
            }

            if foundFriend, let friend = friend {
                confirmButton(friend: friend)
                    .padding(.top, 40)
                    .padding(.bottom, 60)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            let manager = BLEManager(profile: profile)
            manager.onConnectionOpened = { self.foundFriend = true }
            manager.onFriendFound = { self.friend = $0 }
            self.bleManager = manager
            manager.startBLE()
        }
        .onDisappear {
            bleManager?.stopBLE()
        }
        .navigationTitle("Adicionar amigo")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var searchingView: some View {
        VStack(spacing: 32) {
            Spacer()
            ProgressView().scaleEffect(1.5)
            Text("Buscando contatos por perto...")
                .font(.custom("Sora-ExtraBold", size: 28))
                .multilineTextAlignment(.center)
                .frame(width: 270)
            Spacer()

            #if DEBUG
            Button("Simular novo amigo (teste)") {
                self.friend = User(
                    name: "Amigo Novo",
                    profilePicture: UIImage(named: "defaultPicture")?.jpegData(compressionQuality: 0.8) ?? Data()
                )
                self.foundFriend = true
            }
            .font(.custom("Sora-Regular", size: 14))
            .foregroundStyle(.secondary)

            // simula encontrar um amigo
            if let first = existingConnections.first {
                Button("Simular encontro com \(first.friend.name) (teste)") {
                    self.friend = first.friend
                    self.foundFriend = true
                }
                .font(.custom("Sora-Regular", size: 14))
                .foregroundStyle(.secondary)
            }
            Spacer().frame(height: 40)
            #endif
        }
    }

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

            if isExistingFriend {
                Text("Você e \(friend.name) se encontraram!")
                    .font(.custom("Sora-ExtraBold", size: 28))
                    .frame(width: 280)
                    .multilineTextAlignment(.center)
                Text("Pressione e segure sua foto para registrar o encontro.")
                    .font(.custom("Sora-Regular", size: 16))
                    .multilineTextAlignment(.center)
                    .frame(width: 280)
                    .foregroundStyle(.secondary)
            } else {
                Text("Parece que você e \(friend.name) se encontraram!")
                    .font(.custom("Sora-ExtraBold", size: 28))
                    .frame(width: 280)
                    .multilineTextAlignment(.center)
                Text("Pressione e segure sua foto para adicionar como amigo.")
                    .font(.custom("Sora-Regular", size: 16))
                    .multilineTextAlignment(.center)
                    .frame(width: 280)
                    .foregroundStyle(.secondary)
            }

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

    @State private var isHolding = false
    @State private var holdProgress: CGFloat = 0

    /// A long-press confirmation button designed to prevent accidental pairings.
    /// It requires the user to hold the button until the circular progress bar completes.
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
            guard isHolding else { timer.invalidate(); holdProgress = 0; return }
            current += 1
            holdProgress = CGFloat(current) / CGFloat(steps)
            if current >= steps {
                timer.invalidate()
                confirmFriend(friend)
            }
        }
    }

    /// Resolves the pairing process by updating the persistent store.
    ///
    /// If the connection already exists, it updates the `lastMet` timestamp and boosts the relationship score.
    /// If it is a new contact, it bootstraps the `User` and `Connection` models into SwiftData.
    private func confirmFriend(_ friend: User) {
        if let existing = existingConnections.first(where: { $0.friend.id == friend.id }) {
            // registra encontro e aumenta 10 pontos de proximidade
            existing.lastMet = Date.now
            existing.metaManager.addOrSubtractScore(10)
        } else {
            // cria User e Connection no SwiftData
            modelContext.insert(friend)
            let connection = Connection(friend: friend)
            modelContext.insert(connection)
        }
        dismiss()
    }
}

#Preview {
    NavigationStack {
        BLEView(profile: User())
    }
    .modelContainer(for: [User.self, Connection.self], inMemory: true)
}
