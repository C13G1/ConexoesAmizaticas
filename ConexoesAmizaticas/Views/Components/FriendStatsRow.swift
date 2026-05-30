//
//  FriendStatsRow.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 20/05/26.
//

import SwiftUI

/// The friendship stats block displayed below the friend's name on the profile screen.
///
/// `FriendStatsRow` aggregates the three quick metrics (days connected, last meeting, meeting goal)
/// and the larger countdown card that shows whether the user is on track or overdue to honor the goal.
struct FriendStatsRow: View {
    let viewModel: FriendProfileViewModel
    let lastMeetText: String

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20.5) {
                TextedRoundedRectangle(
                    text: "conectados há",
                    subText: "\(viewModel.getConnectionTime()) Dias",
                    subTextColor: viewModel.getProfileColor(),
                    isTwelve: false
                )
                TextedRoundedRectangle(
                    text: "último encontro",
                    subText: lastMeetText,
                    subTextColor: viewModel.getProfileColor(),
                    isTwelve: false
                )
                TextedRoundedRectangle(
                    text: "promessa",
                    subText: viewModel.getMeta().rawValue,
                    subTextColor: viewModel.getProfileColor(),
                    isTwelve: false
                )
            }

            countdownCard
        }
    }

    @ViewBuilder
    private var countdownCard: some View {
        let days = viewModel.getTimeUntilMeet()
        let isOverdue = days < 0
        let displayText = isOverdue ? "\(-days) dias atrasados" : "\(days) dias"

        TextedRoundedRectangle(
            width: 351,
            height: 77,
            text: "vocês prometeram se encontrar dentro de",
            textSize: 15,
            subText: displayText,
            subTextSize: 36,
            subTextColor: viewModel.getProfileColor(),
            isTwelve: false
        )
    }
}
