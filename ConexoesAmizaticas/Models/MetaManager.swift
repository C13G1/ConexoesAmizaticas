//
//  MetaManager.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import Foundation
import SwiftData

let SCORE_DISTANTES:     Double = 20
let SCORE_ESTAVEIS:      Double = 30
let SCORE_PROXIMOS:      Double = 40
let SCORE_INSEPARAVEIS:  Double = 50

/// Manages the scoring system and the expected meeting goals (`Meta`) for a specific connection.
///
/// The `MetaManager` automatically recalculates the `RelationshipState` whenever the score fluctuates,
/// keeping the visual representation of the friendship synchronized with real-world interactions.
@Model
class MetaManager {
    private(set) var meta: Meta
    private(set) var currentRelationshipState: RelationshipState
    private(set) var score: Double

    /// Marks the date up to which score decay has already been applied, preventing double-deductions.
    var lastDecayDate: Date?

    init(score: Double = 10.0) {
        self.score = score
        self.meta = .mensal
        self.lastDecayDate = nil
        self.currentRelationshipState = .afastados
        self.currentRelationshipState = calculateRelationshipState()
    }

    /// Evaluates the current score against predefined thresholds to determine the health of the connection.
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
    func setMeta(_ meta: Meta) {
        self.meta = meta
    }

    /// Modifies the relationship score by a given value, capping it between 0 and 50, and recalculates the connection state.
    func addOrSubtractScore(_ value: Double) {
        self.score = min(50, max(0, self.score + value))
        self.currentRelationshipState = calculateRelationshipState()
    }

    /// Applies -5 points for each meeting period missed since the last decay check.
    /// Safe to call multiple times — advances `lastDecayDate` by whole periods to avoid double-deductions.
    func applyDecayIfNeeded(lastMet: Date?) {
        guard meta != .nenhuma, meta.days > 0 else { return }

        // If a meeting happened after our last decay check, reset the base so we don't penalise periods before the meeting
        if let lastMet = lastMet, let lastDecay = lastDecayDate, lastDecay < lastMet {
            lastDecayDate = lastMet
        }

        guard let baseDate = lastDecayDate ?? lastMet else { return }

        let daysSinceBase = Calendar.current.dateComponents([.day], from: baseDate, to: .now).day ?? 0
        let missedPeriods = daysSinceBase / meta.days

        guard missedPeriods > 0 else { return }

        addOrSubtractScore(-Double(missedPeriods) * 5.0)
        let daysProcessed = missedPeriods * meta.days
        lastDecayDate = Calendar.current.date(byAdding: .day, value: daysProcessed, to: baseDate) ?? .now
    }
}
