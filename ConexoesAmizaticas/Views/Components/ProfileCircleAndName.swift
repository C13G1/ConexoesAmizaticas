//
//  ProfileCircleAndName.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 26/05/26.
//

import SwiftUI

struct ProfileCircleAndName: View {
    @Binding var vm: InicialViewModel
    var width = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            if let uiImage = UIImage(data: vm.profile.profilePicture ) {
                NavigationLink {
                    UserProfileView(vm: $vm)
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: width * 0.29)
                            .foregroundStyle(.black)
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: width
                                   * 0.25, height: width
                                   * 0.25)
                            .clipShape(Circle())
                    }
                }
            } else {
                ZStack {
                    Circle()
                        .frame(width: width * 0.29)
                        .foregroundStyle(.black)
                    Circle()
                        .frame(width: width
                               * 0.25, height: width
                               * 0.25)
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
    @Previewable @State var viewModel = InicialViewModel()
    ProfileCircleAndName(
        vm: $viewModel
    )
}
