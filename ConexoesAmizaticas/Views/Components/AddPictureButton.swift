//
//  AddPictureButton.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 23/05/26.
//

import SwiftUI
import SwiftData

struct AddPictureButton: View {
    let viewModel: FriendFeedViewModel
    
    var body: some View {
        Button {
            viewModel.isPickerPresented = true
        } label: {
            ZStack {
                CurvedRectangle(depth: 0.58)
                    .stroke(Color.green,
                            style: StrokeStyle(
                            lineWidth: 30,
                            lineCap: .round
                        )
                    )
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 80)
            }
        }
    }
}

#Preview {
    let friend = User(name: "nome")
    let conn = Connection(friend: friend)
    return AddPictureButton(viewModel: FriendFeedViewModel(connection: conn))
}
