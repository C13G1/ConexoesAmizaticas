//
//  ConfirmationOverlay.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 27/05/26.
//

import SwiftUI

/// A reusable destructive-confirmation overlay used to gate dangerous user actions.
///
/// `ConfirmationOverlay` reproduces the visual language shared by the delete-post, delete-contact and
/// rescue-from-vacuum prompts: a dim backdrop, a red circle with the relevant avatar, a title with optional
/// preface, a long description and two circular buttons. Callers supply the copy, the icons and the closures
/// to react to cancellation and confirmation.
struct ConfirmationOverlay: View {
    let imageData: Data?
    var preTitle: String? = nil
    let title: String
    let description: String
    var cancelIcon: String = "xmark"
    var confirmIcon: String = "checkmark"
    var confirmButtonColor: Color = .white
    var confirmIconColor: Color = .red
    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture(perform: onCancel)

            VStack {
                ZStack {
                    Circle()
                        .foregroundStyle(.red)
                        .frame(width: 140, height: 140)
                    if let data = imageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 132, height: 132)
                    }
                }

                if let preTitle = preTitle {
                    Text(preTitle)
                        .padding(.top, 16)
                        .font(.custom("Sora-Bold", size: 16))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                }

                Text(title)
                    .foregroundStyle(.white)
                    .font(.custom("Bolota", size: 24))
                    .fontWeight(.bold)
                    .frame(width: 280)
                    .multilineTextAlignment(.center)
                    .padding(.top, preTitle == nil ? 16 : 8)

                Text(description)
                    .font(.custom("Sora-Regular", size: 12))
                    .foregroundStyle(.white)
                    .frame(width: 206)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)

                HStack(spacing: 50) {
                    Button(action: onCancel) {
                        ZStack {
                            Circle().foregroundStyle(Color(red: 0.2, green: 0.2, blue: 0.2))
                            Image(systemName: cancelIcon)
                                .resizable().frame(width: 32, height: 32)
                                .foregroundStyle(.white).bold()
                        }
                    }
                    .frame(width: 72, height: 72)

                    Button(action: onConfirm) {
                        ZStack {
                            Circle().foregroundStyle(confirmButtonColor)
                            Image(systemName: confirmIcon)
                                .resizable().frame(width: 32, height: 32)
                                .foregroundStyle(confirmIconColor).bold()
                        }
                    }
                    .frame(width: 72, height: 72)
                }
                .padding(.top, 40)
            }
        }
    }
}
