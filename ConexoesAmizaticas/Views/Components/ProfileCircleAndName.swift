//
//  ProfileCircleAndName.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 26/05/26.
//

import SwiftUI

struct ProfileCircleAndName: View {
    var user: User = User()
    
    var body: some View {
        VStack {
            if let uiImage = UIImage(data: user.profilePicture) {
                ZStack {
                    Circle()
                        .frame(width: UIScreen.main.bounds.width * 0.29)
                        .foregroundStyle(.black)
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width
                               * 0.25, height: UIScreen.main.bounds.width
                               * 0.25)
                        .clipShape(Circle())
                }
            } else {
                ZStack {
                    Circle()
                        .frame(width: UIScreen.main.bounds.width * 0.29)
                        .foregroundStyle(.black)
                    Circle()
                        .frame(width: UIScreen.main.bounds.width
                               * 0.25, height: UIScreen.main.bounds.width
                               * 0.25)
                        .foregroundStyle(.gray)
                }
            }
            
            Text(user.name)
                .font(.custom("Sora-ExtraBold", size: 20))
        }
    }
}

#Preview {
    ProfileCircleAndName()
}
