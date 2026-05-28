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
    @State private var showDeleteConfirmation: Bool = false
    
    var viewModel: FriendProfileViewModel
    let possibleMetas: [Meta] = [.semanal, .quinzenal, .mensal, .bimestral, .semestral, .anual]
    
    init(viewModel: FriendProfileViewModel){
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
                Image(uiImage: viewModel.getFriendImage() ?? UIImage(named: "C3PO")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.274,
                           height: UIScreen.main.bounds.width * 0.274)
                    .clipShape(Circle())
                    .padding(.top, 40) 
                
                Text(viewModel.getFriendName())
                    .font(.custom("Bolota", size: 48))
                    .textFieldStyle(.plain)
                    .padding()
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 80)
                
                HStack {
                    Text("Promessa")
                        .font(.custom("Bolota", size: 24))
                    Spacer()
                    Picker("Meta", selection: $meta) {
                        ForEach(possibleMetas, id: \.self) { meta in
                            Text(meta.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .padding(.horizontal, 30)
                .tint(.gray)
                
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
        .onChange(of: meta) {
            do {
                viewModel.defineMeta(meta: meta)
                try modelContext.save()
            } catch {
                print("Erro ao salvar meta: \(error)")
            }
        }
        .onAppear {
            SetMetaOnboarding = false
        }
    }
    
    private func deletarContato() {
        modelContext.delete(viewModel.connection)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Erro ao deletar contato: \(error)")
        }
    }
}

#Preview {
    let vm = FriendProfileViewModel(connection: Connection(friend: User(name: "Julia")))
    SetMetaView(viewModel: vm)
}
