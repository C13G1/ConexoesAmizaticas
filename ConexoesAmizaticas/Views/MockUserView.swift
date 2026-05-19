//
//  MockUserView.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import SwiftUI

struct MockUserView: View {
    @State var user: User = User()
    var body: some View {
        VStack {
            user.profilePicture
            Text(user.name)
            Text(user.id.uuidString)
        }
    }
}

#Preview {
    MockUserView()
}
