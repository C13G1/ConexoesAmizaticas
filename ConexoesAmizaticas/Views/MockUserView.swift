//
//  MockUserView.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import SwiftUI

struct MockUserView: View {
    @Binding var user: User
    var body: some View {
        VStack {
            Image(uiImage: UIImage(data: user.profileImage)!) 
            Text(user.name)
            Text(user.id.uuidString)
        }
    }
}
