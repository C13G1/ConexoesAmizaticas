//
//  EditProfileView.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 27/05/26.
//

import SwiftUI
import PhotosUI
import SwiftData

/// An interface for modifying the current user's core identity data.
///
/// `EditProfileView` binds to the application's global `InicialViewModel` to apply changes directly to the
/// primary `User` model. It features a Save button that commits changes to the database via `modelContext.save()`.
struct EditProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Binding var vm: InicialViewModel

    @State private var name: String
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImageData: Data?

    init(vm: Binding<InicialViewModel>) {
        self._vm = vm
        self._name = State(initialValue: vm.wrappedValue.profile.name)
        self._profileImageData = State(initialValue: vm.wrappedValue.profile.profilePicture)
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(spacing: 32) {
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                ZStack {
                    Circle()
                        .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.3)
                        .foregroundStyle(.gray.opacity(0.15))
                    
                    if let data = profileImageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.3)
                    } else {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 44))
                            .foregroundStyle(.gray)
                    }
                    // camera badge
                    Image(systemName: "pencil")
                        .font(.title)
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(Color.gray)
                        .clipShape(Circle())
                        .offset(x: 80, y: 100)
                }
            }
            .onChange(of: selectedPhoto) { _, item in
                Task {
                    if let data = try? await item?.loadTransferable(type: Data.self) {
                        profileImageData = data
                    }
                }
            }

            TextField("Seu nome", text: $name)
                .font(.custom("Bolota", size: 24))
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 40)

            Spacer()
        }
        .padding(.top, 40)
        .background(.lightBackground)
        .navigationTitle("Editar Perfil")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Salvar") {
                    saveChanges()
                }
                .disabled(!canSave)
            }
        }
    }

    private func saveChanges() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        vm.profile.editName(trimmed)
        if let data = profileImageData {
            vm.profile.editProfileImageData(data)
        }
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    @Previewable @State var viewModel = InicialViewModel()
    NavigationStack {
        EditProfileView(vm: $viewModel)
    }
    .modelContainer(for: [User.self, Connection.self], inMemory: true)
}
