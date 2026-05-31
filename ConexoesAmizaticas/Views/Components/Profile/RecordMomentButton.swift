//
//  RecordMomentButton.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 20/05/26.
//

import SwiftUI

/// The decorative call-to-action that takes the user from a friend profile straight into the BLE pairing flow.
///
/// `RecordMomentButton` reproduces the curved badge silhouette used on the friend profile screen:
/// two `CurvedRectangle` brackets framing a tinted `Ellipse` with the "registrar um momento" label.
struct RecordMomentButton<Destination: View>: View {
    let color: Color
    @ViewBuilder let destination: () -> Destination

    var body: some View {
        NavigationLink(destination: destination()) {
            ZStack {
                HStack(spacing: -40) {
                    CurvedRectangle(depth: 2)
                        .stroke(color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .frame(
                            width: UIScreen.main.bounds.height * 0.0957,
                            height: UIScreen.main.bounds.width * 0.0741
                        )
                        .rotationEffect(.degrees(90))

                    Ellipse()
                        .frame(
                            width: UIScreen.main.bounds.width * 0.623,
                            height: UIScreen.main.bounds.height * 0.123
                        )
                        .foregroundStyle(color)

                    CurvedRectangle(depth: 2)
                        .stroke(color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .frame(
                            width: UIScreen.main.bounds.height * 0.0957,
                            height: UIScreen.main.bounds.width * 0.0741
                        )
                        .rotationEffect(.degrees(-90))
                }
                Text("registrar\num momento")
                    .font(.custom("Bolota", size: 24))
                    .foregroundStyle(.white)
            }
        }
    }
}
