//
//  ConexoesAmizaticasTests.swift
//  ConexoesAmizaticasTests
//
//  Created by Enzo Ferroni on 14/05/26.
//

import SwiftUI
import Testing
@testable import ConexoesAmizaticas

struct UserTests {
    var user: User = User(name: "Name", profilePicture: Image("image"))
        
    @Test func editNameWithSuccessTest() {
        let sut = user
        sut.editName("Nome2")
        
        #expect(sut.name == "Nome2")
    }
    
    @Test func editProfilePictureWithSuccessTest() {
        let sut = user
        let img_update: Image = Image("image2")
        
        sut.editProfilePicture(img_update)
        
        #expect(sut.profilePicture == img_update)
    }
}
