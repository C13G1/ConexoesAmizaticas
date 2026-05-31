//
//  UserTests.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 14/05/26.
//



import Testing
import Foundation
@testable import ConexoesAmizaticas

struct UserTests {

    @Test("Init com valores customizados preserva propriedades")
    func initWithCustomValues() {
        let id = UUID()
        let data = Data([0x01, 0x02, 0x03])
        let user = User(name: "Thomas", profilePicture: data, id: id)

        #expect(user.getName() == "Thomas")
        #expect(user.getID() == id)
        #expect(user.getProfileImageData() == data)
    }

    @Test("editName atualiza o nome")
    func editNameUpdatesName() {
        let user = User(name: "Enzo", profilePicture: Data(), id: UUID())
        user.editName("Novo Nome")
        #expect(user.getName() == "Novo Nome")
    }

    @Test("editProfileImageData atualiza a imagem")
    func editProfileImageDataUpdatesImage() {
        let user = User(name: "Enzo", profilePicture: Data(), id: UUID())
        let newImage = Data([0xFF, 0xD8, 0xFF])
        user.editProfileImageData(newImage)
        #expect(user.getProfileImageData() == newImage)
    }

    @Test("Encode e decode via JSON preservam dados")
    func encodeDecodeRoundTrip() throws {
        let id = UUID()
        let data = Data([0xAA, 0xBB, 0xCC])
        let original = User(name: "Round Trip", profilePicture: data, id: id)

        let json = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(User.self, from: json)

        #expect(decoded.getName() == "Round Trip")
        #expect(decoded.getID() == id)
        #expect(decoded.getProfileImageData() == data)
    }

    @Test("Decode falha com JSON inválido")
    func decodeFailsWithInvalidJSON() {
        let invalidJSON = Data("{ \"invalid\": true }".utf8)
        #expect(throws: (any Error).self) {
            try JSONDecoder().decode(User.self, from: invalidJSON)
        }
    }

    @Test("UserDTO codifica e decodifica corretamente")
    func userDTORoundTrip() throws {
        let id = UUID()
        let dto = UserDTO(name: "DTO Test", profilePicture: Data([0x01]), id: id)

        let json = try JSONEncoder().encode(dto)
        let decoded = try JSONDecoder().decode(UserDTO.self, from: json)

        #expect(decoded.name == "DTO Test")
        #expect(decoded.id == id)
        #expect(decoded.profilePicture == Data([0x01]))
    }
}
