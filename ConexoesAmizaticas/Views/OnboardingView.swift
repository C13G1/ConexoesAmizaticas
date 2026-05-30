//
//  OnboardingView.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 20/05/26.
//

import SwiftUI
import PhotosUI
import SwiftData

/// The initial setup flow for new users.
///
/// `OnboardingView` is the presentational shell on top of `OnboardingViewModel`. It collects the user's
/// base identity (name and avatar) and delegates form state, validation and persistence to the view model.
struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = OnboardingViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 64)
                .frame(width: 361, height: 580)
                .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 64))

            VStack(spacing: 0) {
                Text("Seja bem vindo!")
                    .font(.system(size: 36, weight: .bold))
                    .padding(.top, 42)

                PhotosPicker(selection: $viewModel.selectedPhoto, matching: .images) {
                    ZStack {
                        Circle()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.themeYellow.opacity(0.4))
                        if let data = viewModel.profileImageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100)
                        } else {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .font(.system(size: 38))
                                .foregroundStyle(.black.opacity(0.6))
                        }
                    }
                }
                .padding(.top, 24)
                .onChange(of: viewModel.selectedPhoto) { _, _ in
                    Task { await viewModel.loadSelectedPhoto() }
                }

                TextField("Seu nome", text: $viewModel.name)
                    .font(.custom("Sora-Regular", size: 16))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.white.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 32)
                    .padding(.top, 20)
                    .onChange(of: viewModel.name) { _, _ in
                        viewModel.enforceCharacterLimit()
                    }

                Text("O Zelu é um aplicativo que vai revolucionar sua forma de cultivar seus relacionamentos.")
                    .font(.system(size: 15))
                    .frame(width: 297)
                    .padding(.top, 20)
                    .multilineTextAlignment(.center)

                Button {
                    viewModel.createProfile(modelContext: modelContext)
                } label: {
                    Image(systemName: "arrow.right")
                        .resizable()
                        .frame(width: 43, height: 43)
                        .foregroundStyle(viewModel.canProceed ? .black : .gray)
                }
                .disabled(!viewModel.canProceed)
                .padding(.top, 40)
            }
        }
    }
}

#Preview {
    OnboardingView()
        .modelContainer(for: AppSchema.models, inMemory: true)
}
