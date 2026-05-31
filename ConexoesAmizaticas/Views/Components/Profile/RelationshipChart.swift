//
//  RelationshipChart.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 26/05/26.
//

import SwiftUI
import Charts

/// The donut-style pie chart that breaks the user's connections down by `RelationshipState`.
///
/// `RelationshipChart` is the visual layer driven by `UserProfileViewModel`. It renders one sector per bucket,
/// highlights the slice currently hovered via `selectedAngle`, and overlays a central label that summarizes
/// either the selected slice or the chart title.
struct RelationshipChart: View {
    @Bindable var viewModel: UserProfileViewModel
    let size: CGSize

    var body: some View {
        Chart {
            ForEach(viewModel.friendsByState, id: \.state) { item in
                SectorMark(
                    angle: .value("Quantidade", item.count),
                    innerRadius: .inset(24),
                    angularInset: 2
                )
                .cornerRadius(4)
                .opacity(viewModel.sliceOpacity(for: item.state))
                .foregroundStyle(Color(item.state.color))
            }
        }
        .chartAngleSelection(value: $viewModel.selectedAngle)
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                if let anchor = chartProxy.plotFrame {
                    let frame = geometry[anchor]
                    centerLabel
                        .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .chartLegend(.hidden)
        .frame(width: size.width, height: size.height)
    }

    private var centerLabel: some View {
        VStack(spacing: 4) {
            if let selected = viewModel.selectedItem, let percentage = viewModel.selectedPercentage {
                Text("\(percentage)%")
                    .font(.custom("Bolota", size: 36))
                    .foregroundStyle(Color(uiColor: selected.state.color))
                Text(selected.state.displayName.uppercased())
                    .font(.custom("Sora-SemiBold", size: 13))
                    .foregroundStyle(Color(uiColor: selected.state.color))
            } else {
                Text("RODA DA")
                    .font(.custom("Bolota", size: 16))
                    .foregroundStyle(.lightBackground)
                Text("AMIZADE")
                    .font(.custom("Bolota", size: 16))
                    .foregroundStyle(.lightBackground)
            }
        }
        .multilineTextAlignment(.center)
    }
}
