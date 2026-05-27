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
    var connections: [Connection]
    
    private var friendsByState: [(state: RelationshipState, count: Int)] {
        let orderedStates: [RelationshipState] = [
            .afastados, .proximos, .distantes, .estaveis, .inseparaveis
        ]
        
        let grouped = Dictionary(grouping: connections) {
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
        let mostRecent = connections.compactMap { $0.lastMet }.max()
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
                .padding(.bottom, UIScreen.main.bounds.height * 0.8)
                .padding(.leading, UIScreen.main.bounds.width * 0.75)
                
                VStack (spacing: 60){
                    VStack (spacing: 20){
                        ProfileCircleAndName(
                            circleWidthMultiplier: 0.52,
                            imageMultiplier: 0.48,
                            fontSize: 45,
                            isInitialView: false
                        )
                        
                        HStack(spacing: 70) {
                            VStack(alignment: .center) {
                                Text("VOCÊ TEM")
                                    .font(.custom("Sora-Regular", size: 12))
                                
                                Text("\(connections.count) \(connections.count == 1 ? "amigo" : "amigos")")
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(.lightBackground)
        }
    }
}


#Preview {
    UserProfile(connections: [
        Connection(friend: User(name: "Ana"), score: 95.0),
        Connection(friend: User(name: "Carlos"), score: 85.0),
        Connection(friend: User(name: "Bia"), score: 100.0),
        
        Connection(friend: User(name: "Daniel"), score: 75.0),
        Connection(friend: User(name: "Eduardo"), score: 65.0),
        Connection(friend: User(name: "Fernanda"), score: 70.0),
        Connection(friend: User(name: "Gabriel"), score: 62.0),
        
        Connection(friend: User(name: "Helena"), score: 55.0),
        Connection(friend: User(name: "Igor"), score: 45.0),
        Connection(friend: User(name: "João"), score: 50.0),
        Connection(friend: User(name: "Karen"), score: 58.0),
        Connection(friend: User(name: "Lucas"), score: 42.0),
        
        Connection(friend: User(name: "Mariana"), score: 35.0),
        Connection(friend: User(name: "Nícolas"), score: 25.0),
        
        Connection(friend: User(name: "Olívia"), score: 10.0)
    ])
    .modelContainer(for: [
        Connection.self,
        User.self,
        MetaManager.self,
        FeedManager.self
    ])
}
