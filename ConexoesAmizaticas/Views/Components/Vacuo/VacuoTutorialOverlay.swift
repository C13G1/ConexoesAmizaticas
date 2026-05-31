//
//  VacuoTutorialOverlay.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 31/05/26.
//

import SwiftUI

/// The four-step swipeable tutorial that explains the vacuum mechanic.
///
/// `VacuoTutorialOverlay` blocks all interaction while shown, paginates through four explanatory
/// pages and exposes a closing handler triggered by the OK button on the last page. The platform
/// page indicator is hidden in favor of `VacuoTutorialPageIndicator`, anchored at the offsets the
/// design calls for.
struct VacuoTutorialOverlay: View {
    @Binding var step: Int
    let sampleImage: UIImage
    let onDismiss: () -> Void

    private let totalSteps = 4

    var body: some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()

            TabView(selection: $step) {
                VStack(spacing: 60) {
                    pageText("Amigos que ficarem\nmuito distantes vão\naparecer aqui")
                    sampleAvatar
                }
                .tag(0)

                VStack(spacing: 60) {
                    pageText("Mas se você deixá-los\naqui por muito tempo\neles desaparecem")
                    dissolvingSampleAvatar
                }
                .tag(1)

                VStack(spacing: 60) {
                    pageText("Vocês podem se\nconectar novamente,\nmas tudo vai ser\nrecomeçado")
                }
                .tag(2)

                VStack(spacing: 60) {
                    pageText("Não deixe seus amigos\nno vácuo!")
                    okButton
                }
                .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            VStack {
                Spacer()
                VacuoTutorialPageIndicator(currentStep: step, totalSteps: totalSteps)
                    .padding(.horizontal, 156)
                    .padding(.bottom, 83)
            }
        }
    }

    private func pageText(_ string: String) -> some View {
        Text(string)
            .font(.system(size: 24, weight: .light))
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .frame(maxWidth: 280)
    }

    private var sampleAvatar: some View {
        Image(uiImage: sampleImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 92, height: 92)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .strokeBorder(Color(uiColor: RelationshipState.afastados.color), lineWidth: 4)
            )
    }

    private var dissolvingSampleAvatar: some View {
        TimelineView(.animation) { context in
            let t = context.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 3.0) / 3.0
            let progress = CGFloat(1 - t)
            sampleAvatar
                .opacity(0.15 + 0.85 * progress)
                .scaleEffect(0.5 + 0.5 * progress)
                .blur(radius: (1 - progress) * 20)
        }
        .frame(width: 92, height: 92)
    }

    private var okButton: some View {
        Button(action: onDismiss) {
            ZStack {
                Circle()
                    .fill(Color.white)
                Text("OK")
                    .font(.custom("Bolota", size: 36))
                    .foregroundStyle(.black)
            }
            .frame(width: 88, height: 88)
        }
    }
}

#Preview {
    @Previewable @State var step = 0
    return VacuoTutorialOverlay(
        step: $step,
        sampleImage: UIImage(named: "DefaultPicture") ?? UIImage(),
        onDismiss: {}
    )
}
