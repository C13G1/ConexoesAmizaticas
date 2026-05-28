//
//  EditProfileView.swift
//  ConexoesAmizaticas
//

import SwiftUI
import PhotosUI
import SwiftData

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
                        .frame(width: 120, height: 120)
                        .foregroundStyle(.gray.opacity(0.15))
                    if let data = profileImageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 120, height: 120)
                    } else {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 44))
                            .foregroundStyle(.gray)
                    }
                    // camera badge
                    Image(systemName: "camera.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                        .padding(6)
                        .background(Color.gray)
                        .clipShape(Circle())
                        .offset(x: 40, y: 40)
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
                .font(.custom("Sora-Regular", size: 16))
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 32)

            Spacer()
        }
        .padding(.top, 40)
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
