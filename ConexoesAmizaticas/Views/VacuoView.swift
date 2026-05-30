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
/// alongside an info modal and a rescue confirmation overlay, mirroring SwiftData query results into the
/// view model on every change.
struct VacuoView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var allConnections: [Connection]

    @State private var viewModel = VacuoViewModel()

    @State private var voidScene: FriendsScene = {
        let s = FriendsScene(size: UIScreen.main.bounds.size, connections: Set(), sceneType: .search)
        s.backgroundColor = .clear
        return s
    }()

    var body: some View {
        ZStack {
            backgroundLayer
                .blur(radius: viewModel.focusedConnection != nil ? 10 : 0)

            if viewModel.showInfo {
                infoModal
            }

            if let connection = viewModel.focusedConnection {
                rescueOverlay(for: connection)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            Aptabase.shared.trackEvent("screen_view", with: ["name": "vacuo"])
            voidScene.updateConnections(receivedConnections: Set(viewModel.vacuumConnections))
            voidScene.onFriendTapped = { connection in
                viewModel.focusedConnection = connection
            }
        }
        .onChange(of: allConnections, initial: true) { _, newValue in
            viewModel.allConnections = newValue
            voidScene.updateConnections(receivedConnections: Set(viewModel.vacuumConnections))
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

            VStack(spacing: 0) {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .regular))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button { viewModel.showInfo = true } label: {
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
                    .frame(
                        width: UIScreen.main.bounds.width * 0.3,
                        height: UIScreen.main.bounds.height * 0.04
                    )
                    .padding(.bottom)

                Spacer()

                if viewModel.vacuumConnections.isEmpty {
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

    private var infoModal: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture { viewModel.showInfo = false }

            VStack(alignment: .leading) {
                HStack {
                    Text("Informações")
                        .font(.custom("Sora-SemiBold", size: 18))
                        .foregroundColor(.white)
                    Spacer()
                    Button { viewModel.showInfo = false } label: {
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
