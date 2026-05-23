//
//  Enums.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import Foundation

enum RelationshipState: String, Codable {
    case conhecido = "conhecido"
    case amigo = "amigo"
    case amigoProximo = "amigo próximo"
    case melhorAmigo = "melhor amigo"
}

enum OrbitRadius: Double {
    case conhecido = 100
    case amigo = 200
    case amigoProximo = 300
    case melhorAmigo = 400
}

enum CodingKeys: String, CodingKey {
    case name
    case profilePicture
    case id
}
