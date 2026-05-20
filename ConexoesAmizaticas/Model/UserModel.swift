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
    private var name         : String
    private var profileImage : Data
    public  var id           : UUID
    
    init(name: String = "DefaultName", profileImage: Data = Data()) {
        self.name         = name
        self.profileImage = profileImage
        self.id           = UUID()
    }
    
    required init(from decoder: any Decoder) throws {
        let container     = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name         = try container.decode(String.self, forKey: .name)
        self.profileImage = try container.decode(Data.self, forKey: .profilePicture)
        self.id           = try container.decode(UUID.self, forKey: .id)
    }
    
    func editProfileImageData(_ image: Data) {
        self.profileImage = image
    }
    
    func editName(_ name: String) {
        self.name = name
    }
    
    func getID() -> UUID{
        return id
    }
    
    func encode(to encoder: any Encoder) throws {}
}

