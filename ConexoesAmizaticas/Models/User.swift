//
//  User.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import SwiftData
import SwiftUI

/// Represents a user profile within the application context.
///
/// This model conforms to `Codable` to facilitate serialization, primarily for transferring
/// profile information to nearby peers over Bluetooth via the `BLEManager`.
@Model
class User: Codable {
    private(set) var name:           String
    private(set) var profilePicture: Data
    private(set) var id:             UUID

    init(
        name: String = "DefaultName",
        profilePicture: Data = UIImage(named: "defaultPicture")?.jpegData(compressionQuality: 1) ?? Data(),
        id: UUID = UUID()
    ) {
        self.name           = name
        self.profilePicture = profilePicture
        self.id             = id
    }

    required init(from decoder: any Decoder) throws {
        let container       = try decoder.container(keyedBy: CodingKeys.self)
        self.name           = try container.decode(String.self, forKey: .name)
        self.profilePicture = try container.decode(Data.self, forKey: .profilePicture)
        self.id             = try container.decode(UUID.self, forKey: .id)
    }

    /// Updates the user's display name.
    func editName(_ name: String) {
        self.name = name
    }

    /// Updates the user's avatar image.
    func editProfileImageData(_ image: Data) {
        self.profilePicture = image
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(profilePicture, forKey: .profilePicture)
        try container.encode(id, forKey: .id)
    }

    func getProfileImageData() -> Data { return profilePicture }
    func getName() -> String { return name }
    func getID() -> UUID { return id }

    /// The set of properties serialized when the model is encoded or decoded.
    private enum CodingKeys: String, CodingKey {
        case name
        case profilePicture
        case id
    }
}
