//
//  ProfileCircleAndName.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 26/05/26.
//

import SwiftUI

/// A compact visual identifier showing the user's avatar and name.
///
/// Placed inside the top `ToolBar`, this component acts as the primary gateway to the `UserProfileView`.
/// It extracts the active profile data directly from the root `InitialViewModel`.
struct ProfileCircleAndName: View {
    @Binding var vm: InitialViewModel
    var width = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            if let uiImage = UIImage(data: vm.profile.profilePicture) {
                NavigationLink {
                    UserProfileView(vm: $vm)
                } label: {
                    ZStack {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: width * 0.25, height: width * 0.25)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(.themeBackground, lineWidth: 8)
                            )
                    }
                }
            } else {
                // Fallback avatar if the user profile image is missing.
                ZStack {
                    Circle()
                        .frame(width: width * 0.3)
                        .foregroundStyle(.black)
                    Circle()
                        .frame(width: width * 0.25, height: width * 0.25)
                        .foregroundStyle(.gray)
                }
            }
            
            Text(vm.profile.name)
                .font(.custom("Sora-ExtraBold", size: 20))
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    @Previewable @State var viewModel = InitialViewModel()
    ProfileCircleAndName(
        vm: $viewModel
    )
}
