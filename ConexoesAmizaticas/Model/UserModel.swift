//
//  UserModel.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//
import SwiftData
import SwiftUI
 
@Model
class User: Codable {
    private(set) var name:         String
    private(set) var profileImage: Data
    private(set) var id:           UUID
    
    init(name: String = "DefaultName", profilePicture: Data = UIImage(named: "defaultPicture")?.jpegData(compressionQuality: 1) ?? Data(), id: UUID = UUID()) {
        self.name         = name
        self.profileImage = profilePicture
        self.id           = id
    }
    
    required init(from decoder: any Decoder) throws {
        let container     = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name         = try container.decode(String.self, forKey: .name)
        self.profileImage = try container.decode(Data.self, forKey: .profilePicture)
        self.id           = try container.decode(UUID.self, forKey: .id)
    }
    func editName(_ name: String) {
        self.name = name
    }
    
    func editProfileImageData(_ image: Data) {
        self.profileImage = image
    }
    
    func encode(to encoder: any Encoder) throws {}

}

struct userDTO: Codable {
    var name: String
    var profilePicture: Data
    var id: UUID
}
