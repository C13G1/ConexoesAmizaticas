//
//  SceneType.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import Foundation

/// Identifies which root scene is currently driving the SpriteKit simulation.
///
/// `FriendsScene` reuses the same node layout across the home and search screens but tweaks
/// its behavior based on this value (e.g., enabling the spiral "vacuum" affordance only on `.initial`).
enum SceneType {
    case initial
    case search
}
