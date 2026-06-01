//
//  VacuoTutorialPageIndicator.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 31/05/26.
//

import SwiftUI

/// A flat page indicator drawn over the tutorial overlay.
///
/// `VacuoTutorialPageIndicator` replaces the platform-provided indicator so the dots can sit
/// at the exact bottom inset required by the design and dropping the gray pill background.
struct VacuoTutorialPageIndicator: View {
    let currentStep: Int
    let totalSteps: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(index == currentStep ? 1.0 : 0.35))
                    .frame(width: 8, height: 8)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
        VacuoTutorialPageIndicator(currentStep: 1, totalSteps: 4)
    }
}
