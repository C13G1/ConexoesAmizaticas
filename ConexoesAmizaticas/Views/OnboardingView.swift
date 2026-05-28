//
//  OnboardingView.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 20/05/26.
//

import SwiftUI
import PhotosUI
import SwiftData
import Aptabase

/// The initial setup flow for new users.
///
/// `OnboardingView` collects the user's base identity (name and avatar) and inserts the primary `User`
/// entity into the persistent store. This action acts as the catalyst to unlock the rest of the application
/// through the `ContentView` router.
struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var name: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImageData: Data?
    
    /// Validates input to ensure the user cannot proceed with an empty or whitespace-only name.
    private var canProceed: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 64)
                .frame(width: 361, height: 580)
                .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 64))
            
            VStack(spacing: 0) {
                Text("Seja bem vindo!")
                    .font(.system(size: 36, weight: .bold))
                    .padding(.top, 42)
                
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    ZStack {
                        Circle()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.themeYellow.opacity(0.4))
                        if let data = profileImageData, let uiImage = UIImage(data: data) {
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
                .onChange(of: selectedPhoto) { _, item in
                    Task {
                        if let data = try? await item?.loadTransferable(type: Data.self) {
                            profileImageData = data
                        }
                    }
                }
                
                let characterLimit = 10
                
                TextField("Seu nome", text: $name)
                    .font(.custom("Sora-Regular", size: 16))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.white.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 32)
                    .padding(.top, 20)
                    .onChange(of: name) { oldValue, newValue in
                        if newValue.count > characterLimit {
                            name = String(newValue.prefix(characterLimit))
                        }
                    }
                
                Text("O Zelu é um aplicativo que vai revolucionar sua forma de cultivar seus relacionamentos.")
                    .font(.system(size: 15))
                    .frame(width: 297)
                    .padding(.top, 20)
                    .multilineTextAlignment(.center)
                
                Button(action: createProfile) {
                    Image(systemName: "arrow.right")
                        .resizable()
                        .frame(width: 43, height: 43)
                        .foregroundStyle(canProceed ? .black : .gray)
                }
                .disabled(!canProceed)
                .padding(.top, 40)
            }
        }
    }
    
    /// Finalizes the onboarding by packaging the collected data into a `User` model.
    private func createProfile() {
        let finalImageData = profileImageData
        ?? UIImage(named: "defaultPicture")?.jpegData(compressionQuality: 1)
        ?? Data()
        let user = User(name: name.trimmingCharacters(in: .whitespaces), profilePicture: finalImageData)
        modelContext.insert(user)
        Aptabase.shared.trackEvent("onboarding_completed")
    }
}

#Preview {
    OnboardingView()
        .modelContainer(for: User.self, inMemory: true)
}
