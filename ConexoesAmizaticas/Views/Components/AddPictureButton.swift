//
//  AddPictureButton.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 23/05/26.
//

import SwiftUI
import SwiftData
import PhotosUI

/// A stylized button that invokes the native iOS photo picker.
///
/// `AddPictureButton` is heavily customized to fit the app's geometric design language, using a `CurvedRectangle`
/// to create a distinct visual depth. It binds directly to a `FriendFeedViewModel` to seamlessly pass the selected
/// image data into the friend's memory feed.
struct AddPictureButton: View {
    @Environment(\.modelContext) private var modelContext
    
    /// The view model that coordinates the selection and processing of the chosen photos.
    @Bindable var viewModel: FriendFeedViewModel
    
    /// The thematic color applied to the button's stroke, usually matching the current relationship state.
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
        // Automatically triggers the asynchronous upload to SwiftData once an image is chosen.
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
