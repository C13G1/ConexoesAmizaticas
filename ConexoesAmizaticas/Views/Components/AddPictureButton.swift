//
//  AddPictureButton.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 23/05/26.
//

import SwiftUI
import SwiftData

//
//  AddPictureButton.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 23/05/26.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddPictureButton: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var viewModel: FriendFeedViewModel
    let color: Color
    
    var body: some View {
        Button {
            viewModel.isPickerPresented = true
        } label: {
            ZStack {
                CurvedRectangle(depth: 0.58)
                    .stroke(color,
                            style: StrokeStyle(
                                lineWidth: 30,
                                lineCap: .round
                            )
                    )
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 80)
                
                Image("addPhotoText")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.036)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.05)
            }
        }
        .photosPicker(
            isPresented: $viewModel.isPickerPresented,
            selection: $viewModel.selectedItems,
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: viewModel.selectedItems) { oldValue, newValue in
            if !newValue.isEmpty {
                Task {
                    await viewModel.addPostFromSelection(modelContext: modelContext)
                }
            }
        }
    }
}

#Preview {
    let friend = User(name: "nome")
    let conn = Connection(friend: friend)
    AddPictureButton(viewModel: FriendFeedViewModel(connection: conn), color: .blue)
        .preferredColorScheme(.dark)
}
