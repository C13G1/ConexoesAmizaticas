//
//  UserProfileView.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 26/05/26.
//

import SwiftUI
import Charts
import SwiftData

/// A macroscopic overview of the user's entire social network.
///
/// `UserProfileView` aggregates data from all active connections to render an analytical breakdown using
/// SwiftUI Charts. It categorizes friendships based on their `RelationshipState` (e.g., "Próximos", "Afastados"),
/// offering a high-level perspective of social health.
struct UserProfileView: View {
    @Binding var vm: InicialViewModel
    @Query private var connections: [Connection]

    @State private var selectedAngle: Double?

    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height

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

    private var categoryRanges: [(state: RelationshipState, range: Range<Double>)] {
        var total = 0.0
        return friendsByState.map { item in
            let newTotal = total + Double(item.count)
            let result = (state: item.state, range: total ..< newTotal)
            total = newTotal
            return result
        }
    }

    private var selectedItem: (state: RelationshipState, count: Int)? {
        guard let selectedAngle else { return nil }
        guard let index = categoryRanges.firstIndex(where: { $0.range.contains(selectedAngle) }) else { return nil }
        return friendsByState[index]
    }

    private var lastMeetingText: String {
        let mostRecent = connections.compactMap { $0.lastMet }.max()
        guard let mostRecent else { return "NUNCA" }
        let days = Calendar.current.dateComponents([.day], from: mostRecent, to: .now).day ?? 0
        if days == 0 { return "HOJE" }
        if days == 1 { return "HÁ 1 DIA" }
        return "HÁ \(days) DIAS"
    }

    private var chartCenterLabel: some View {
        VStack(spacing: 2) {
            if let selected = selectedItem {
                Text(selected.state.displayName.uppercased())
                    .font(.custom("Sora-SemiBold", size: 12))
                Text("\(selected.count) \(selected.count == 1 ? "amigo" : "amigos")")
                    .font(.custom("Bolota", size: 20))
            } else {
                Text("RODA DA")
                    .font(.custom("Bolota", size: 18))
                Text("AMIZADE")
                    .font(.custom("Bolota", size: 18))
            }
        }
        .foregroundStyle(.lightBackground)
        .multilineTextAlignment(.center)
    }

    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(.themeBackground)
                .frame(width: width * 2.17)
                .padding(.bottom, height * -0.18)

            VStack(spacing: 60) {
                VStack(spacing: 20) {
                    ProfileHeader(vm: $vm)

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
                        .frame(height: height * 0.35)
                } else {
                    Chart {
                        ForEach(friendsByState, id: \.state) { item in
                            SectorMark(
                                angle: .value("Quantidade", item.count),
                                innerRadius: .ratio(0.62),
                                angularInset: 2
                            )
                            .cornerRadius(4)
                            .opacity(selectedItem == nil ? 1 : (selectedItem?.state == item.state ? 1 : 0.4))
                            .foregroundStyle(Color(item.state.color))
                        }
                    }
                    .chartAngleSelection(value: $selectedAngle)
                    .chartBackground { chartProxy in
                        GeometryReader { geometry in
                            if let anchor = chartProxy.plotFrame {
                                let frame = geometry[anchor]
                                chartCenterLabel
                                    .position(x: frame.midX, y: frame.midY)
                            }
                        }
                    }
                    .chartLegend(.hidden)
                    .frame(width: width * 0.8, height: height * 0.35)
                }
            }
            .padding(.top, height * 0.05)
        }
        .background(.lightBackground)
        .toolbar {
            ToolbarItem {
                NavigationLink {
                    EditProfileView(vm: $vm)
                } label: {
                    Image(systemName: "gear")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                }
            }
            .sharedBackgroundVisibility(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview {
    @Previewable @State var viewModel = InicialViewModel()
    UserProfileView(vm: $viewModel)
        .modelContainer(for: [
            Connection.self,
            User.self,
            MetaManager.self,
            FeedManager.self
        ])
}
