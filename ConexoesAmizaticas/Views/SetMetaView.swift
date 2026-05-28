//
//  SetMetaView.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 27/05/26.
//

import SwiftUI
import SwiftData

/// The configuration interface for an individual friendship.
///
/// `SetMetaView` provides the controls to calibrate the interaction expectations (`Meta`) for a given connection,
/// which ultimately drives the decay rate of the relationship score. It also houses the critical, destructive
/// operation of permanently deleting the relationship.
struct SetMetaView: View {
    @AppStorage("SetMetaOnboarding") var SetMetaOnboarding: Bool = true
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State var meta: Meta
    @State private var showDeleteConfirmation: Bool = false

    var viewModel: FriendProfileViewModel
    let possibleMetas: [Meta] = [.nenhuma, .semanal, .quinzenal, .mensal, .bimestral, .semestral, .anual]

    init(viewModel: FriendProfileViewModel) {
        self.viewModel = viewModel
        self.meta = viewModel.getMeta()
    }

    var body: some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(.friendProfileBackGround)
                .ignoresSafeArea()

            VStack(alignment: .center) {
                Image(uiImage: viewModel.getFriendImage() ?? UIImage(named: "defaultPicture") ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.274,
                           height: UIScreen.main.bounds.width * 0.274)
                    .clipShape(Circle())
                    .padding(.top, 40)

                Text(viewModel.getFriendName().uppercased())
                    .font(.custom("Bolota", size: 48))
                    .padding()
                    .multilineTextAlignment(.center)
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
                .padding(.horizontal, 30)

                Spacer()

                Button(action: {
                    withAnimation {
                        showDeleteConfirmation = true
                    }
                }) {
                    Text("apagar contato")
                        .font(.custom("Sora-Light", size: 15))
                        .foregroundStyle(.red)
                }
                .padding(.bottom, 30)
            }
            .blur(radius: showDeleteConfirmation ? 10 : 0)

            if showDeleteConfirmation {
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundColor(.black.opacity(0.6))
                    .onTapGesture {
                        withAnimation {
                            showDeleteConfirmation = false
                        }
                    }

                VStack {
                    ZStack {
                        Circle()
                            .foregroundStyle(.red)
                            .frame(width: 140, height: 140)
                        if let uiImage = viewModel.getFriendImage() {
                            Image(uiImage: uiImage)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 132, height: 132)
                        }
                    }

                    Text("Você está prestes a excluir \(viewModel.getFriendName())")
                        .padding(.top, 16)
                        .font(.custom("Sora-Bold", size: 16))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text("QUER MESMO DELETAR ESTE CONTATO?")
                        .foregroundStyle(.white)
                        .font(.custom("Bolota", size: 24))
                        .fontWeight(.bold)
                        .frame(width: 280)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)

                    Text("Esta ação é permanente e todo o histórico será perdido.")
                        .font(.custom("Sora-Light", size: 12))
                        .foregroundStyle(.white)
                        .frame(width: 206)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)

                    HStack(spacing: 50) {
                        Button {
                            withAnimation {
                                showDeleteConfirmation = false
                            }
                        } label: {
                            ZStack {
                                Circle().foregroundStyle(Color(red: 0.2, green: 0.2, blue: 0.2))
                                Image(systemName: "xmark")
                                    .resizable().frame(width: 32, height: 32)
                                    .foregroundStyle(.white).bold()
                            }
                        }
                        .frame(width: 72, height: 72)

                        Button {
                            deletarContato()
                        } label: {
                            ZStack {
                                Circle().foregroundStyle(.white)
                                Image(systemName: "checkmark")
                                    .resizable().frame(width: 32, height: 32)
                                    .foregroundStyle(.red).bold()
                            }
                        }
                        .frame(width: 72, height: 72)
                    }
                    .padding(.top, 40)
                }
            }
        }
        .environment(\.colorScheme, .light)
        .onChange(of: meta) {
            do {
                viewModel.defineMeta(meta: meta)
                try modelContext.save()
                NotificationManager.scheduleMetaReminder(for: viewModel.connection)
            } catch {
                print("Erro ao salvar meta: \(error)")
            }
        }
        .onAppear {
            SetMetaOnboarding = false
        }
    }

    private func deletarContato() {
        NotificationManager.cancelMetaReminder(for: viewModel.connection)
        modelContext.delete(viewModel.connection.metaManager)
        modelContext.delete(viewModel.connection.feedManager)
        modelContext.delete(viewModel.connection.friend)
        modelContext.delete(viewModel.connection)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    let vm = FriendProfileViewModel(connection: Connection(friend: User(name: "Julia")))
    SetMetaView(viewModel: vm)
}
