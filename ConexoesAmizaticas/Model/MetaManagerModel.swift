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
    
    private func calculateRelationshipState() -> RelationshipState {
        if self.score < SCORE_DISTANTES {
            return .afastados
        }
        else if self.score < SCORE_ESTAVEIS {
            return .distantes
        }
        else if self.score < SCORE_PROXIMOS {
            return .estaveis
        }
        else if self.score < SCORE_INSEPARAVEIS {
            return .proximos
        }
        else {
            return .inseparaveis
        }
        
    }
    
    func setMeta(_ meta: Meta) {
        self.meta = meta
    }
    
    func addOrSubtractScore(_ value: Double) {
        self.score = min(100, max(0, self.score + value))
        self.currentRelationshipState = calculateRelationshipState()
    }
}
