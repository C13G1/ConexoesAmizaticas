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
/// `EditProfileView` binds to the application's global `InitialViewModel` to apply changes directly to the
/// primary `User` model. It features a Save button that commits changes to the database via `modelContext.save()`.

struct EditProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var vm: InitialViewModel
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var editableName: String = ""
    @FocusState private var isNameFocused: Bool
    
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(spacing: 40) {
            ZStack {
                if let uiImage = UIImage(data: vm.profile.profilePicture) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: width * 0.75, height: width * 0.75)
                        .clipShape(Circle())
                }
                
                PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                    Image(systemName: "pencil")
                        .foregroundStyle(.lightBackground)
                        .font(.title)
                        .padding(8)
                        .background(Color.green)
                        .cornerRadius(100)
                }
                .padding(.leading, width * 0.45)
                .padding(.top, height * 0.28)
            }
            .onChange(of: selectedPhoto) { _, newValue in
                if let newValue {
                    Task {
                        if let data = try? await newValue.loadTransferable(type: Data.self) {
                            vm.profile.editProfileImageData(data)
                            try? modelContext.save()
                        }
                    }
                }
            }
            
            VStack(spacing: 2) {
                let characterLimit = 10
                
                TextField("Seu nome", text: $editableName)
                    .font(.custom("Bolota", size: 48))
                    .multilineTextAlignment(.center)
                    .focused($isNameFocused)
                    .onAppear {
                        editableName = vm.profile.name
                    }
                    .onChange(of: editableName) { oldValue, newValue in
                        if newValue.count > characterLimit {
                            editableName = String(newValue.prefix(characterLimit))
                        } else {
                            vm.profile.editName(newValue)
                            try? modelContext.save()
                        }
                    }
                    .onSubmit {
                        isNameFocused = false
                    }
                
                Capsule()
                    .frame(width: width * 0.75, height: 5)
            }
            
            Spacer()
        }
        .foregroundStyle(.black)
        .onTapGesture {
            isNameFocused = false
        }
    }
}

#Preview {
    @Previewable @State var viewModel = InitialViewModel()
    EditProfileView(vm: $viewModel)
}
