//
//  EditFriendProfileView.swift
//  ConexoesAmizaticas
//

import SwiftUI
import PhotosUI
import SwiftData

struct EditFriendProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let connection: Connection

    @State private var name: String
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImageData: Data?

    init(connection: Connection) {
        self.connection = connection
        self._name = State(initialValue: connection.friend.name)
        self._profileImageData = State(initialValue: connection.friend.profilePicture)
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

            TextField("Nome do amigo", text: $name)
                .font(.custom("Sora-Regular", size: 16))
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 32)

            Spacer()
        }
        .padding(.top, 40)
        .navigationTitle("Editar Amigo")
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
        connection.friend.editName(trimmed)
        if let data = profileImageData {
            connection.friend.editProfileImageData(data)
        }
        try? modelContext.save()
        NotificationCenter.default.post(name: .friendProfileUpdated, object: nil)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        EditFriendProfileView(connection: Connection(friend: User(name: "Juliana")))
    }
    .modelContainer(for: [User.self, Connection.self], inMemory: true)
}
