//
//  ProfileHeader.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 27/05/26.
//

import SwiftUI

/// A large-scale presentation of the user's avatar and name, utilized in the `UserProfileView`.
///
/// Similar to `ProfileCircleAndName` but scaled up for a dedicated profile screen, establishing visual hierarchy.
struct ProfileHeader: View {
    @Binding var vm: InitialViewModel
    var width = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            if let uiImage = UIImage(data: vm.profile.profilePicture) {
                ZStack {
                    Circle()
                        .frame(width: width * 0.52)
                        .foregroundStyle(.lightBackground)
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: width * 0.48, height: width * 0.48)
                        .clipShape(Circle())
                }
            } else {
                ZStack {
                    Circle()
                        .frame(width: width * 0.52)
                        .foregroundStyle(.lightBackground)
                    Circle()
                        .frame(width: width * 0.48, height: width * 0.48)
                        .foregroundStyle(.gray)
                }
            }
            
            Text(vm.profile.name)
                .font(.custom("Sora-ExtraBold", size: 45))
                .foregroundStyle(.lightBackground)
        }
    }
}

#Preview {
    @Previewable @State var viewModel = InitialViewModel()
    ProfileHeader(
        vm: $viewModel
    )
    .preferredColorScheme(.dark)
}
