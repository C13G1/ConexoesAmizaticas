//
//  Enums.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import Foundation

enum RelationshipState: String, Codable {
    case conhecido    = "conhecido"
    case amigo        = "amigo"
    case amigoProximo = "amigo próximo"
    case melhorAmigo  = "melhor amigo"
}
