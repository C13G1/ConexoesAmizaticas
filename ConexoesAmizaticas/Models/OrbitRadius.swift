//
//  OrbitRadius.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import Foundation

/// Typed raw values for the orbit distances used by `OrbitNode` in the SpriteKit scene.
///
/// The numbers here intentionally mirror `RelationshipState.orbitRadius`. They live as a separate
/// enum because `OrbitNode` needs a strongly-typed constructor parameter, not a `Double`.
enum OrbitRadius: Double {
    case afastados    = 100
    case distantes    = 200
    case estaveis     = 300
    case proximos     = 400
    case inseparaveis = 500
}
