//
//  VacuoView.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 24/05/26.
//

import SwiftUI
import SwiftData
import SpriteKit
import Aptabase

/// A dedicated recovery environment for deeply decayed friendships.
///
/// `VacuoView` is the presentational shell over `VacuoViewModel`. It surfaces the SpriteKit "void" scene
/// alongside a four-step tutorial overlay and a rescue confirmation overlay, mirroring SwiftData query
/// results into the view model on every change.
struct VacuoView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allConnections: [Connection]

    @State private var viewModel = VacuoViewModel()

    @State private var voidScene: FriendsScene = {
        let s = FriendsScene(size: UIScreen.main.bounds.size, connections: Set(), sceneType: .search)
        s.backgroundColor = .clear
        return s
    }()

    var body: some View {
        @Bindable var bindable = viewModel

        ZStack {
            backgroundLayer
                .blur(radius: viewModel.focusedConnection != nil ? 10 : 0)

            if let connection = viewModel.focusedConnection {
                rescueOverlay(for: connection)
            }

            if viewModel.showTutorial {
                tutorialOverlay(bindable: $bindable.tutorialStep)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
        .toolbar(viewModel.showTutorial ? .hidden : .visible, for: .navigationBar)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("void")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 28)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        viewModel.tutorialStep = 0
                        viewModel.showTutorial = true
                    }
                } label: {
                    Image(systemName: "info.circle")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            Aptabase.shared.trackEvent("screen_view", with: ["name": "vacuo"])
            viewModel.allConnections = allConnections
            voidScene.onFriendTapped = { connection in
                viewModel.focusedConnection = connection
            }
            voidScene.updateConnections(receivedConnections: Set(viewModel.vacuumConnections))
            voidScene.updateNodeVisuals()
        }
        .onChange(of: allConnections) { _, newValue in
            viewModel.allConnections = newValue
            voidScene.updateConnections(receivedConnections: Set(viewModel.vacuumConnections))
            voidScene.updateNodeVisuals()
        }
    }

    private var backgroundLayer: some View {
        ZStack {
            Color.vacuoBackground.ignoresSafeArea()

            Image("vacuo")
                .frame(width: 280, height: 280)
                .padding(.trailing, 80)
                .padding(.bottom, 40)

            SpriteView(scene: voidScene, options: [.allowsTransparency])
                .ignoresSafeArea()

            if viewModel.vacuumConnections.isEmpty {
                VStack {
                    Spacer()
                    Text("Você não tem nenhum\namigo no vácuo")
                        .font(.system(size: 24, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(maxWidth: 300)
                        .padding(.bottom, 20)
                }
            }
        }
    }

    private func tutorialOverlay(bindable step: Binding<Int>) -> some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()

            TabView(selection: step) {
                tutorialStep1.tag(0)
                tutorialStep2.tag(1)
                tutorialStep3.tag(2)
                tutorialStep4.tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }

    private var tutorialSampleAvatar: some View {
        let data = viewModel.vacuumConnections.first?.friend.profilePicture
            ?? allConnections.first?.friend.profilePicture
        let image = (data.flatMap(UIImage.init(data:))) ?? UIImage(named: "DefaultPicture") ?? UIImage()

        return Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 68, height: 68)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .strokeBorder(Color(uiColor: RelationshipState.afastados.color), lineWidth: 4)
            )
            .shadow(color: .black.opacity(0.8), radius: 10)
    }

    private var tutorialStep1: some View {
        VStack(spacing: 60) {
            tutorialText("amigos que ficarem muito distantes\nvão aparecer aqui")
            tutorialSampleAvatar
        }
    }

    private var tutorialStep2: some View {
        VStack(spacing: 60) {
            tutorialText("mas se você deixá-los aqui por muito tempo\neles desaparecem")
            TimelineView(.animation) { context in
                let t = context.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 3.0) / 3.0
                let progress = CGFloat(1 - t)
                tutorialSampleAvatar
                    .opacity(0.15 + 0.85 * progress)
                    .scaleEffect(0.5 + 0.5 * progress)
                    .blur(radius: (1 - progress) * 20)
            }
            .frame(width: 68, height: 68)
        }
    }

    private var tutorialStep3: some View {
        VStack(spacing: 60) {
            tutorialText("vocês podem se conectar novamente,\nmas tudo vai ser recomeçado")
            tutorialSampleAvatar
                .opacity(0.4)
        }
    }

    private var tutorialStep4: some View {
        VStack(spacing: 60) {
            tutorialText("não deixe seus amigos no vácuo!")

            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    viewModel.showTutorial = false
                    viewModel.tutorialStep = 0
                }
            } label: {
                Circle()
                    .fill(Color(white: 0.85))
                    .frame(width: 88, height: 88)
                    .overlay {
                        Text("OK")
                            .font(.custom("Bolota", size: 36))
                            .foregroundStyle(.black)
                    }
            }
        }
    }

    private func tutorialText(_ string: String) -> some View {
        Text(string)
            .font(.system(size: 24, weight: .light))
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .frame(maxWidth: 280)
    }

    private func rescueOverlay(for connection: Connection) -> some View {
        ConfirmationOverlay(
            imageData: connection.friend.profilePicture,
            preTitle: "Você deixou \(connection.friend.name) no vácuo",
            title: "QUER RESGATAR ESSE CONTATO?",
            description: "Contatos ficam no vácuo por até 30 dias. Depois disso, a conexão é perdida e será preciso recomeçar do zero.",
            confirmIcon: "checkmark",
            confirmButtonColor: .white,
            confirmIconColor: .black,
            onCancel: { viewModel.focusedConnection = nil },
            onConfirm: {
                viewModel.rescueFocusedConnection(modelContext: modelContext)
                voidScene.updateConnections(receivedConnections: Set(viewModel.vacuumConnections))
            }
        )
    }
}

#Preview {
    VacuoView()
        .modelContainer(for: AppSchema.models, inMemory: true)
}
