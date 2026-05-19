//
//  UserModel.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//
import SwiftData
import SwiftUI

@Model
class UserModel: Codable {
    private(set) var name: String
    private(set) var profilePicture: Data
    private(set) var id: UUID
    
    init(name: String = "DefaultName", profilePicture: Data = Data()) {
        self.name = name
        self.profilePicture = profilePicture
        self.id = UUID()
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.profilePicture = try container.decode(Data.self, forKey: .profilePicture)
        self.id = try container.decode(UUID.self, forKey: .id)
    }
    
    func encode(to encoder: any Encoder) throws {}

}
 
class User {
    private(set) var name: String
    private(set) var profilePicture: Image
    private(set) var id: UUID
    
    init(name: String = "DefaultName", profilePicture: Image = Image("defaultPicture"), id: UUID = UUID()) {
        self.name = name
        self.profilePicture = profilePicture
        self.id = id
    }
    
    func editProfilePicture(_ image: Image) {
        self.profilePicture = image
    }
    
    func editName(_ name: String) {
        self.name = name
    }
    
    func getID() -> UUID{
        return id
    }
}

struct userDTO: Codable {
    var name: String
    var profilePicture: Data
    var id: UUID
}
