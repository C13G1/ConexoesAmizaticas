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
    @State var meta: Meta
    var viewModel : FriendProfileViewModel
    let possibleMetas: [Meta] = [.semanal,.quinzenal,.mensal,.bimestral,.semestral,.anual]
    
    init(viewModel: FriendProfileViewModel){
        self.viewModel = viewModel
        self.meta = viewModel.getMeta()
    }
    
    var body: some View {
            ZStack{
                Rectangle()
                    .frame(width: .infinity,height: .infinity)
                    .foregroundStyle(.friendProfileBackGround)
                
                VStack(alignment: .center) {
                    Image(uiImage: viewModel.getFriendImage() ?? UIImage(named: "C3PO")!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.274,
                               height: UIScreen.main.bounds.width * 0.274)
                        .clipShape(Circle())
                    
                    Text(viewModel.getFriendName())
                        .font(.custom("Bolota", size: 48))
                        .textFieldStyle(.plain)
                        .padding()
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 80)
                    
                    
                    HStack{
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
                    .padding()
                    .tint(.gray)
                }
            }
            .ignoresSafeArea()
            .onChange(of: meta) {
                do{
                    viewModel.defineMeta(meta: meta)
                    try modelContext.save()
                }
                catch{
                    print("Erro ao salvar meta")
                }
            }
            .onAppear{
                SetMetaOnboarding = false
            }
        }
}

#Preview {
    let vm = FriendProfileViewModel(connection: Connection(friend: User()))
    SetMetaView(viewModel: vm)
}
