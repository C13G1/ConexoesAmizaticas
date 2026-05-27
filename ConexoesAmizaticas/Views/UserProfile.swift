//
//  UserProfile.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 26/05/26.
//

import SwiftUI
import Charts
import SwiftData

struct UserProfile: View {
    @Binding var vm: InicialViewModel
    
    private var friendsByState: [(state: RelationshipState, count: Int)] {
        let orderedStates: [RelationshipState] = [
            .afastados, .proximos, .distantes, .estaveis, .inseparaveis
        ]
        
        let grouped = Dictionary(grouping: vm.connectionsWithFriends) {
            $0.metaManager.currentRelationshipState
        }
        
        return orderedStates.compactMap { state in
            let count = grouped[state]?.count ?? 0
            guard count > 0 else { return nil }
            return (state: state, count: count)
        }
    }
    
    private func label(for state: RelationshipState) -> String {
        switch state {
        case .afastados: return "Afastados"
        case .distantes: return "Distantes"
        case .estaveis: return "Estáveis"
        case .proximos: return "Próximos"
        case .inseparaveis: return "Inseparáveis"
        }
    }
    
    private var lastMeetingText: String {
        let mostRecent = vm.connectionsWithFriends.compactMap { $0.lastMet }.max()
        guard let mostRecent else { return "NUNCA" }
        
        let days = Calendar.current.dateComponents([.day], from: mostRecent, to: .now).day ?? 0
        if days == 0 { return "HOJE" }
        if days == 1 { return "HÁ 1 DIA" }
        return "HÁ \(days) DIAS"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Circle()
                    .foregroundStyle(.themeBackground)
                    .frame(width: UIScreen.main.bounds.width * 2.17)
                    .padding(.bottom, UIScreen.main.bounds.height * -0.18)
                
                NavigationLink {
                    
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: UIScreen.main.bounds.width * 0.15)
                            .foregroundStyle(.lightBackground)
                        Image(systemName: "pencil")
                            .foregroundStyle(.black)
                            .font(.largeTitle)
                            .bold()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.19, height: UIScreen.main.bounds.width * 0.19)
                    .background(.black)
                    .cornerRadius(100)
                }
                .padding(.bottom, UIScreen.main.bounds.height * 0.78)
                .padding(.leading, UIScreen.main.bounds.width * 0.75)
                
                VStack (spacing: 60){
                    VStack (spacing: 20){
                        ProfileCircleAndName(
                            vm: $vm,
                            circleWidthMultiplier: 0.52,
                            imageMultiplier: 0.48,
                            fontSize: 45,
                            isInitialView: false
                        )
                        
                        HStack(spacing: 70) {
                            VStack(alignment: .center) {
                                Text("VOCÊ TEM")
                                    .font(.custom("Sora-Regular", size: 12))
                                
                                Text("\(vm.connectionsWithFriends.count) \(vm.connectionsWithFriends.count == 1 ? "amigo" : "amigos")")
                                    .font(.custom("Bolota", size: 24))
                            }
                            
                            VStack(alignment: .center) {
                                Text("ÚLTIMO ENCONTRO")
                                    .font(.custom("Sora-Regular", size: 12))
                                
                                Text(lastMeetingText)
                                    .font(.custom("Bolota", size: 24))
                            }
                        }
                        .foregroundStyle(.lightBackground)
                    }
                    
                    if friendsByState.isEmpty {
                        Text("Sem amigos ainda")
                            .font(.custom("Bolota", size: 32))
                            .foregroundStyle(.lightBackground)
                            .frame(height: UIScreen.main.bounds.height * 0.35)
                    } else {
                        Chart {
                            ForEach(friendsByState, id: \.state) { item in
                                SectorMark(
                                    angle: .value("Quantidade", item.count),
                                    innerRadius: .ratio(0.8),
                                    angularInset: 0
                                )
                                .foregroundStyle(Color(item.state.color))
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.35)
                    }
                }
                .padding(.top, UIScreen.main.bounds.height * 0.05)
                
                Text("RODA DA AMIZADE")
                    .font(.custom("Bolota", size: 36))
                    .foregroundStyle(.lightBackground)
                    .frame(width: UIScreen.main.bounds.width * 0.5)
                    .padding(.top, UIScreen.main.bounds.height * 0.52)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(.lightBackground)
    }
}



#Preview {
    @Previewable @State var viewModel = InicialViewModel()
    UserProfile(vm: $viewModel)
        .modelContainer(for: [
            Connection.self,
            User.self,
            MetaManager.self,
            FeedManager.self
        ])
}
