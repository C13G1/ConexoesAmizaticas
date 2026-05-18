//
//  UserModel.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//
import SwiftData
import SwiftUI

@Model
class User {
    private(set) var name: String
    private(set) var profilePicture: Image
    private(set) var id: UUID
    
    init(name: String, profilePicture: Image = Image("defaultPicture")) {
        self.name = name
        self.profilePicture = profilePicture
        self.id = UUID()
    }
    required init(from decoder: any Decoder) throws {
        
    }
    func editProfilePicture(_ image: Image) {
        self.profilePicture = image
    }
    func editName(_ name: String) {
        self.name = name
    }
}

extension User: Codable {
    
    func encode(to encoder: any Encoder) throws {
        
    }
    
}
