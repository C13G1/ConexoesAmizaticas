//
//  MetaManagerModel.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import Foundation
import SwiftData

let SCORE_DISTANTES:     Double = 20
let SCORE_ESTAVEIS:      Double = 40
let SCORE_PROXIMOS:      Double = 60
let SCORE_INSEPARAVEIS:  Double = 80

/// Manages the scoring system and the expected meeting goals (`Meta`) for a specific connection.
///
/// The `MetaManager` automatically recalculates the `RelationshipState` whenever the score fluctuates,
/// keeping the visual representation of the friendship synchronized with real-world interactions.
@Model
class MetaManager {
    private(set) var meta: Meta
    private(set) var currentRelationshipState: RelationshipState
    private(set) var score: Double
    
    init(score: Double = 1.0) {
        self.score = score
        self.meta = .mensal
        self.currentRelationshipState = .afastados
        self.currentRelationshipState = calculateRelationshipState()
    }
    
    /// Evaluates the current score against predefined thresholds to determine the health of the connection.
    /// - Returns: The newly calculated `RelationshipState`.
    private func calculateRelationshipState() -> RelationshipState {
        if self.score < SCORE_DISTANTES {
            return .afastados
        } else if self.score < SCORE_ESTAVEIS {
            return .distantes
        } else if self.score < SCORE_PROXIMOS {
            return .estaveis
        } else if self.score < SCORE_INSEPARAVEIS {
            return .proximos
        } else {
            return .inseparaveis
        }
    }
    
    /// Updates the meeting frequency goal.
    /// - Parameter meta: The new frequency target (e.g., weekly, monthly).
    func setMeta(_ meta: Meta) {
        self.meta = meta
    }
    
    /// Modifies the relationship score by a given value, capping it between 0 and 100, and recalculates the connection state.
    /// - Parameter value: The amount to add (or subtract if negative) from the current score.
    func addOrSubtractScore(_ value: Double) {
        self.score = min(100, max(0, self.score + value))
        self.currentRelationshipState = calculateRelationshipState()
    }
}
