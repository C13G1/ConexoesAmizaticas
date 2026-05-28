//
//  Enums.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import Foundation
import UIKit

/// Defines the current health and status of a friendship based on the connection score.
///
/// The state directly influences the visual representation of the connection in the SpriteKit scene,
/// determining its orbital radius, movement speed, and color.
enum RelationshipState: String, Codable {
    case afastados    = "afastados"
    case distantes    = "distantes"
    case estaveis     = "estaveis"
    case proximos     = "proximos"
    case inseparaveis = "inseparaveis"
    
    /// The distance from the center node in the graphical visualizer.
    var orbitRadius: Double {
        switch self {
        case .afastados: return 100
        case .distantes: return 200
        case .estaveis: return 300
        case .proximos: return 400
        case .inseparaveis: return 500
        }
    }
    
    /// The velocity at which the node travels along its orbit.
    var orbitSpeed: Double {
        switch self {
        case .afastados: return 1
        case .distantes: return 2
        case .estaveis: return 3
        case .proximos: return 4
        case .inseparaveis: return 5
        }
    }
    
    /// The thematic color identifying this specific relationship state.
    var color: UIColor {
        switch self {
        case .afastados: return UIColor.themeAfastados
        case .distantes: return UIColor.themeDistantes
        case .estaveis: return UIColor.themeEstaveis
        case .proximos: return UIColor.themeProximos
        case .inseparaveis: return UIColor.themeInseparaveis
        }
    }
}

enum SceneType {
    case initial
    case search
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

/// Represents the commitment goal set by the user to meet a specific friend.
enum Meta: String, Codable {
    case semanal = "semanalmente"
    case quinzenal = "quizenal"
    case mensal = "mensal"
    case bimestral = "bimestral"
    case semestral = "semestral"
    case anual = "anual"
    
    /// The numeric equivalent of the goal in days.
    var days: Int {
        switch self {
        case .semanal: return 7
        case .quinzenal: return 15
        case .mensal: return 30
        case .bimestral: return 60
        case .semestral: return 182
        case .anual: return 360
        }
    }
}
