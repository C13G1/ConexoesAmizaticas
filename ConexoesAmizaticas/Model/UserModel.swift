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
    private var name: String
    private var profilePicture: Data
    public var id: UUID
    
    init(name: String = "DaultName", profilePicture: Data = Data()) {
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
    private var name: String
    private var profilePicture: Image
    public var id: UUID
    
    init(name: String = "DefaultName", profilePicture: Image = Image("defaultPicture")) {
        self.name = name
        self.profilePicture = profilePicture
        self.id = UUID()
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
