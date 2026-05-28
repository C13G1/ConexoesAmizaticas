//
//  SetMetaView.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 27/05/26.
//

import SwiftUI
import SwiftData

struct SetMetaView: View {
    @AppStorage("SetMetaOnboarding") var SetMetaOnboarding: Bool = true
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State var meta: Meta
    @State private var showDeleteAlert = false
    var viewModel: FriendProfileViewModel
    let possibleMetas: [Meta] = [.nenhuma, .semanal, .quinzenal, .mensal, .bimestral, .semestral, .anual]

    init(viewModel: FriendProfileViewModel) {
        self.viewModel = viewModel
        self.meta = viewModel.getMeta()
    }

    var body: some View {
        ZStack {
            Color(.friendProfileBackGround)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                if let uiImage = viewModel.getFriendImage() {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.274,
                               height: UIScreen.main.bounds.width * 0.274)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .frame(width: UIScreen.main.bounds.width * 0.274,
                               height: UIScreen.main.bounds.width * 0.274)
                        .foregroundStyle(.gray.opacity(0.3))
                }

                Text(viewModel.getFriendName().uppercased())
                    .font(.custom("Bolota", size: 48))
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                    .padding(.bottom, 60)

                HStack {
                    Text("PROMESSA")
                        .font(.custom("Bolota", size: 24))
                    Spacer()
                    Picker("Meta", selection: $meta) {
                        ForEach(possibleMetas, id: \.self) { m in
                            Text(m.displayText).tag(m)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(.gray)
                }
                .padding(.horizontal)

                Spacer()

                Button("apagar contato") {
                    showDeleteAlert = true
                }
                .font(.custom("Sora-light", size: 15))
                .foregroundStyle(.red)
                .padding(.bottom, 40)
            }
            .padding(.top, 60)
        }
        .environment(\.colorScheme, .light)
        .onChange(of: meta) {
            do {
                viewModel.defineMeta(meta: meta)
                try modelContext.save()
            } catch {
                print("Erro ao salvar meta")
            }
        }
        .onAppear {
            SetMetaOnboarding = false
        }
        .alert("Apagar contato", isPresented: $showDeleteAlert) {
            Button("Apagar", role: .destructive) {
                deleteConnection()
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Tem certeza que deseja apagar \(viewModel.getFriendName()) dos seus contatos? Essa ação não pode ser desfeita.")
        }
    }

    private func deleteConnection() {
        modelContext.delete(viewModel.connection.metaManager)
        modelContext.delete(viewModel.connection.feedManager)
        modelContext.delete(viewModel.connection.friend)
        modelContext.delete(viewModel.connection)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    let vm = FriendProfileViewModel(connection: Connection(friend: User()))
    SetMetaView(viewModel: vm)
}
