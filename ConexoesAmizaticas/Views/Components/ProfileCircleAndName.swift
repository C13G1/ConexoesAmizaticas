//
//  ProfileCircleAndName.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 26/05/26.
//

import SwiftUI

struct ProfileCircleAndName: View {
    var user: User = User()
    var circleWidthMultiplier: Double
    var imageMultiplier: Double
    var fontSize: Int
    var isInitialView: Bool
    
    var body: some View {
        VStack {
            if let uiImage = UIImage(data: user.profilePicture) {
                ZStack {
                    Circle()
                        .frame(width: UIScreen.main.bounds.width * circleWidthMultiplier)
                        .foregroundStyle(isInitialView ? .black : .lightBackground)
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width
                               * imageMultiplier, height: UIScreen.main.bounds.width
                               * imageMultiplier)
                        .clipShape(Circle())
                }
            } else {
                ZStack {
                    Circle()
                        .frame(width: UIScreen.main.bounds.width * circleWidthMultiplier)
                        .foregroundStyle(isInitialView ? .black : .lightBackground)
                    Circle()
                        .frame(width: UIScreen.main.bounds.width
                               * imageMultiplier, height: UIScreen.main.bounds.width
                               * imageMultiplier)
                        .foregroundStyle(.gray)
                }
            }
            
            Text(user.name)
                .font(.custom("Sora-ExtraBold", size: CGFloat(fontSize)))
                .foregroundStyle(isInitialView ? .black : .lightBackground)
        }
    }
}

#Preview {
    ProfileCircleAndName(circleWidthMultiplier: 0.29, imageMultiplier: 0.25, fontSize: 20, isInitialView: true)
}
