//
//  Enums.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import Foundation
import UIKit

enum RelationshipState: String, Codable {
    case afastados    = "afastados"
    case distantes    = "distantes"
    case estaveis     = "estaveis"
    case proximos     = "proximos"
    case inseparaveis = "inseparaveis"
    
    var orbitRadius: Double {
        switch self {
        case .afastados:
            return 100
        case .distantes:
            return 200
        case .estaveis:
            return 300
        case .proximos:
            return 400
        case .inseparaveis:
            return 500
        }
    }
    
    var orbitSpeed: Double {
        switch self {
        case .afastados:
            return 1
        case .distantes:
            return 2
        case .estaveis:
            return 3
        case .proximos:
            return 4
        case .inseparaveis:
            return 5
        }
    }
    var color: UIColor {
        switch self {
        case .afastados:
            return UIColor.themeAfastados
        case .distantes:
            return UIColor.themeDistantes
        case .estaveis:
            return UIColor.themeEstaveis
        case .proximos:
            return UIColor.themeProximos
        case .inseparaveis:
            return UIColor.themeInseparaveis
        }
    }
    
}

enum OrbitRadius: Double {
    case afastados    = 100
    case distantes    = 200
    case estaveis     = 300
    case proximos     = 400
    case inseparaveis = 500
}

enum CodingKeys: String, CodingKey {
    case name
    case profilePicture
    case id
}
