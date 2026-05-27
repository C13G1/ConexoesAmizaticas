//
//  ProfileHeader.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 27/05/26.
//

import SwiftUI

struct ProfileHeader: View {
    @Binding var vm: InicialViewModel
    
    var body: some View {
        VStack {
            if let uiImage = UIImage(data: vm.profile.profilePicture ) {
                ZStack {
                    Circle()
                        .frame(width: UIScreen.main.bounds.width * 0.52)
                        .foregroundStyle(.lightBackground)
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width
                               * 0.48, height: UIScreen.main.bounds.width
                               * 0.48)
                        .clipShape(Circle())
                }
            } else {
                ZStack {
                    Circle()
                        .frame(width: UIScreen.main.bounds.width * 0.52)
                        .foregroundStyle(.lightBackground)
                    Circle()
                        .frame(width: UIScreen.main.bounds.width
                               * 0.48, height: UIScreen.main.bounds.width
                               * 0.48)
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
    @Previewable @State var viewModel = InicialViewModel()
    ProfileHeader(
        vm: $viewModel
    )
    .preferredColorScheme(.dark)
}
