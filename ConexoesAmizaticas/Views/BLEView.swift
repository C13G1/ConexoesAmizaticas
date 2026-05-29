//
//  BLEView.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 15/05/26.
//

import SwiftUI
import CoreBluetooth
import SwiftData
import Aptabase

extension Notification.Name {
    static let meetingConfirmed = Notification.Name("meetingConfirmed")
    static let friendProfileUpdated = Notification.Name("friendProfileUpdated")
}

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

    @State private var phase: Phase = .searching
    @State private var showSearchAgainButton: Bool = false
    @State private var holdProgress: CGFloat = 0
    @State private var isHolding: Bool = false
    @State private var canConfirm: Bool = false
    @State private var holdTimer: Timer?
    @State private var confirmedReveal: CGFloat = 0
    @State private var showConfirmationBackground: Bool = false

    /// The profile of the device owner, broadcasted to nearby peers.
    let profile: User

    private let avatarDiameter: CGFloat = 132
    private let holdDuration: Double = 1.0

    private enum Phase {
        case searching
        case matched
        case holding
        case confirmed
    }

    /// Evaluates if the discovered peer is already a saved connection to determine the subsequent action (create vs. update).
    private var existingConnection: Connection? {
        guard let friend = friend else { return nil }
        return existingConnections.first { $0.friend.id == friend.id }
    }
    private var isExistingFriend: Bool { existingConnection != nil }

    private var shouldShowLens: Bool {
        holdProgress > 0.001 || phase == .holding || phase == .confirmed
    }

    private var isWhiteMode: Bool {
        phase == .confirmed || showConfirmationBackground
    }

    private var backgroundColor: Color {
        if isWhiteMode {
            return Color.white
        }
        return Color.bleBackground
    }

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            if isWhiteMode {
                Color.white.ignoresSafeArea()
            }

            GeometryReader { geo in
                ZStack {
                    if phase == .holding {
                        Color.clear.ignoresSafeArea()
                    }

                    if shouldShowLens {
                        lensLayer(in: geo.size)
                            .allowsHitTesting(false)
                            .zIndex(0)
                            .drawingGroup()
                    }

                    avatarsLayer(in: geo.size)
                        .opacity(avatarsOpacity)
                        .zIndex(1)
                        .compositingGroup()

                    textLayer(in: geo.size)
                        .allowsHitTesting(phase != .holding)

                    if phase == .confirmed {
                        confirmedOverlay
                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                            .allowsHitTesting(false)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .contentShape(Rectangle())
                .gesture(holdGesture)
            }
        }
        .onAppear {
            Aptabase.shared.trackEvent("screen_view", with: ["name": "ble_search"])
            let manager = BLEManager(profile: profile)
            manager.onConnectionOpened = { self.foundFriend = true }
            manager.onFriendFound = { self.friend = $0 }
            self.bleManager = manager
            manager.startBLE()
        }
        .onDisappear {
            bleManager?.stopBLE()
            holdTimer?.invalidate()
        }
        .onChange(of: foundFriend) { _, _ in tryTransitionToMatched() }
        .onChange(of: friend?.id) { _, _ in tryTransitionToMatched() }
        .navigationTitle("Adicionar amigo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(isWhiteMode ? Color.white : Color.bleBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(isWhiteMode ? .light : .dark, for: .navigationBar)
    }

    // MARK: - Layout helpers

    private func topAvatarCenterY(in size: CGSize) -> CGFloat {
        max(140, size.height * 0.18)
    }

    private func bottomAvatarCenterY(in size: CGSize) -> CGFloat {
        min(size.height - 140, size.height * 0.82)
    }

    private var avatarsOpacity: Double {
        return 1.0
    }

    // MARK: - Avatars layer

    @ViewBuilder
    private func avatarsLayer(in size: CGSize) -> some View {
        let centerX = size.width / 2
        let topY = topAvatarCenterY(in: size)
        let bottomY = bottomAvatarCenterY(in: size)

        // Friend (top) — slides in from above when match is detected
        if let friend = friend {
            avatarView(image: friend.profilePicture)
                .scaleEffect(phase == .searching ? 0.8 : 1.0)
                .position(
                    x: centerX,
                    y: phase == .searching ? -avatarDiameter : topY
                )
        }

        // Own avatar (bottom) — always present, gently pulsing while searching
        avatarView(image: profile.profilePicture)
            .position(x: centerX, y: bottomY)
    }

    private func avatarView(image data: Data) -> some View {
        ZStack {
            Group {
                if let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else if let fallback = UIImage(named: "defaultPicture") {
                    Image(uiImage: fallback)
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(width: avatarDiameter, height: avatarDiameter)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 4)
            )
        }
    }

    // MARK: - Lens (press & hold) layer

    /// Two growing white circles, joined by an even-odd fill that punches the intersection
    /// out to reveal the dark background, forming a horizontal "vesica/lens" between them.
    private func lensLayer(in size: CGSize) -> some View {
        let centerX = size.width / 2
        let topY = topAvatarCenterY(in: size)
        let bottomY = bottomAvatarCenterY(in: size)
        let halfDistance = (bottomY - topY) / 2
        let startRadius: CGFloat = (avatarDiameter + 14) / 2
        let endRadius: CGFloat = halfDistance + 80
        let radius = startRadius + (endRadius - startRadius) * holdProgress

        let topRect = CGRect(
            x: centerX - radius, y: topY - radius,
            width: radius * 2, height: radius * 2
        )
        let bottomRect = CGRect(
            x: centerX - radius, y: bottomY - radius,
            width: radius * 2, height: radius * 2
        )

        return VesicaShape(topRect: topRect, bottomRect: bottomRect)
            .fill(Color.white, style: FillStyle(eoFill: true))
            .opacity(phase == .confirmed ? 0 : 1)
    }

    // MARK: - Text / UI layer

    @ViewBuilder
    private func textLayer(in size: CGSize) -> some View {
        VStack(spacing: 0) {
            Spacer(minLength: topAvatarCenterY(in: size) + avatarDiameter / 2 + 24)

            Group {
                switch phase {
                case .searching:
                    searchingText
                case .matched:
                    matchedText
                case .holding, .confirmed:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 32)

            Spacer(minLength: 24)

            if phase == .matched, showSearchAgainButton {
                Button {
                    searchAgain()
                } label: {
                    HStack(alignment: .center, spacing: 10) {
                        Text("procurar por outra pessoa")
                            .font(
                                Font.custom("Sora", size: 14)
                                    .weight(.bold)
                            )
                            .kerning(0.38)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.bleBackground)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 0)
                    .frame(minHeight: 34)
                    .background(Color.white)
                    .cornerRadius(30)
                }
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
                .padding(.bottom, size.height - bottomAvatarCenterY(in: size) + avatarDiameter / 2 + 28)
            } else {
                Spacer(minLength: size.height - bottomAvatarCenterY(in: size) + avatarDiameter / 2 + 28)
            }
        }
        .frame(width: size.width, height: size.height)
        .animation(.easeInOut(duration: 0.35), value: phase)
        .animation(.easeInOut(duration: 0.35), value: showSearchAgainButton)
    }

    @ViewBuilder
    private var searchingText: some View {
        VStack(spacing: 14) {
            Text("Buscando contatos por perto...")
                .font(.custom("Sora-ExtraBold", size: 26))
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 280)

            #if DEBUG
            debugButtons
            #endif
        }
        .transition(.opacity)
    }

    @ViewBuilder
    private var matchedText: some View {
        if let friend = friend {
            VStack(spacing: 14) {
                Text(isExistingFriend
                     ? "Você e \(friend.name) se encontraram!"
                     : "Parece que você e \(friend.name) se encontraram!")
                    .font(.custom("Sora-ExtraBold", size: 26))
                    .foregroundStyle(Color.white)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 300)

                Text("pressione e segure para confirmar o momento.")
                    .font(.custom("Sora-Regular", size: 15))
                    .foregroundStyle(Color.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 280)
            }
            .transition(.opacity)
        }
    }

    #if DEBUG
    @ViewBuilder
    private var debugButtons: some View {
        VStack(spacing: 6) {
            Button("Simular novo amigo (teste)") {
                self.friend = User(
                    name: "Amigo Novo",
                    profilePicture: UIImage(named: "defaultPicture")?.jpegData(compressionQuality: 0.8) ?? Data()
                )
                self.foundFriend = true
            }
            .font(.custom("Sora-Regular", size: 13))
            .foregroundStyle(Color.white.opacity(0.55))

            if let first = existingConnections.first {
                Button("Simular encontro com \(first.friend.name) (teste)") {
                    self.friend = first.friend
                    self.foundFriend = true
                }
                .font(.custom("Sora-Regular", size: 13))
                .foregroundStyle(Color.white.opacity(0.55))
            }
        }
        .padding(.top, 16)
    }
    #endif

    // MARK: - Confirmed overlay

    private var confirmedOverlay: some View {
        ZStack {
            Circle()
                .fill(Color.bleBackground)
                .frame(width: 233, height: 233)
                .scaleEffect(0.92 + 0.08 * confirmedReveal)

            VStack(spacing: 2) {
                Text("Encontro registrado!")
            }
            .font(
                Font.custom("Bolota", size: 32)
                    .weight(.bold)
            )
            .kerning(0.38)
            .foregroundColor(Color.white)
            .multilineTextAlignment(.center)
            .frame(width: 263, alignment: .top)
        }
        .opacity(Double(confirmedReveal))
    }

    // MARK: - Gestures & phase transitions

    private var holdGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                guard phase == .matched else { return }
                if !isHolding {
                    isHolding = true
                    startHold()
                }
            }
            .onEnded { _ in
                guard isHolding else { return }
                isHolding = false
                endHold()
            }
    }

    private func tryTransitionToMatched() {
        guard foundFriend, friend != nil, phase == .searching else { return }
        showSearchAgainButton = false
        withAnimation(.spring(response: 0.55, dampingFraction: 0.75)) {
            phase = .matched
        }
        let targetFriendID = friend?.id
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(3))
            guard phase == .matched, friend?.id == targetFriendID else { return }
            withAnimation(.easeOut(duration: 0.4)) {
                showSearchAgainButton = true
            }
        }
    }

    private func searchAgain() {
        foundFriend = false
        friend = nil
        showSearchAgainButton = false
        canConfirm = false
        showConfirmationBackground = false
        withAnimation(.easeInOut(duration: 0.35)) {
            phase = .searching
            holdProgress = 0
        }
        bleManager?.startBLE()
    }

    // MARK: - Hold timer (progress + haptics)

    private func startHold() {
        holdTimer?.invalidate()
        canConfirm = false
        showConfirmationBackground = false
        withAnimation(.easeInOut(duration: 0.18)) {
            phase = .holding
        }

        let steps = 60
        let stepInterval = holdDuration / Double(steps)
        var current = 0

        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.prepare()

        holdTimer = Timer.scheduledTimer(withTimeInterval: stepInterval, repeats: true) { timer in
            guard isHolding else {
                timer.invalidate()
                return
            }
            current += 1
            let progress = min(1.0, CGFloat(current) / CGFloat(steps))
            DispatchQueue.main.async {
                holdProgress = progress
            }

            if current >= steps {
                timer.invalidate()
                canConfirm = true
                // Haptic pro usuário soltar
            } else {
                let intensity = 0.2 + 0.8 * progress
                impact.impactOccurred(intensity: intensity)
            }
        }
    }

    private func endHold() {
        holdTimer?.invalidate()
        holdTimer = nil

        if canConfirm, let friend = friend {
            let success = UINotificationFeedbackGenerator()
            success.notificationOccurred(.success)

            showConfirmationBackground = true
            withAnimation(.easeOut(duration: 0.45)) {
                phase = .confirmed
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.78).delay(0.05)) {
                confirmedReveal = 1
            }

            Task { @MainActor in
                try? await Task.sleep(for: .milliseconds(1900))
                confirmFriend(friend)
            }
        } else {
            let light = UIImpactFeedbackGenerator(style: .light)
            light.impactOccurred()

            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                phase = .matched
                holdProgress = 0
            }
        }
        canConfirm = false
    }

    // MARK: - Persistence

    /// Resolves the pairing process by updating the persistent store.
    ///
    /// If the connection already exists, it updates the `lastMet` timestamp and boosts the relationship score.
    /// If it is a new contact, it bootstraps the `User` and `Connection` models into SwiftData.
    private func confirmFriend(_ friend: User) {
        guard friend.id != profile.id else { dismiss(); return }
        let connection: Connection
        if let existing = existingConnections.first(where: { $0.friend.id == friend.id }) {
            existing.lastMet = Date.now
            existing.metaManager.addOrSubtractScore(10)
            connection = existing
            Aptabase.shared.trackEvent("meeting_registered", with: [
                "relationship_state": existing.metaManager.currentRelationshipState.rawValue,
                "score": existing.metaManager.score
            ])
        } else {
            modelContext.insert(friend)
            let newConnection = Connection(friend: friend)
            modelContext.insert(newConnection)
            connection = newConnection
            Aptabase.shared.trackEvent("friend_added")
        }
        try? modelContext.save()
        NotificationManager.scheduleMetaReminder(for: connection)
        NotificationCenter.default.post(name: .meetingConfirmed, object: nil)
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(400))
            dismiss()
        }
    }
}

/// Two overlapping circles drawn into one Path. Filled with `eoFill`,
/// the intersection of the circles is excluded — producing the horizontal
/// "olho/vesica" lens that reveals the dark background through the middle.
private struct VesicaShape: Shape {
    let topRect: CGRect
    let bottomRect: CGRect

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: topRect)
        path.addEllipse(in: bottomRect)
        return path
    }
}

#Preview {
    NavigationStack {
        BLEView(profile: User())
    }
    .modelContainer(for: [User.self, Connection.self], inMemory: true)
}
