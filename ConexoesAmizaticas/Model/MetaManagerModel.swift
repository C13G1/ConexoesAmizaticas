//
//  MetaManagerModel.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import Foundation
import SwiftData

let SCORE_AMIGO: Double = 1 / 4
let SCORE_AMIGO_PROXIMO: Double = 1 / 2
let SCORE_MELHOR_AMIGO: Double = 5 / 6

@Model
class MetaManagerModel {
    private(set) var meta: RelationshipState
    private(set) var currentRelationshipState: RelationshipState
    private(set) var score: Double
    
    init(meta: RelationshipState = .conhecido, currentRelationshipState: RelationshipState = .conhecido, score: Double = 0.0) {
        self.meta = meta
        self.currentRelationshipState = currentRelationshipState
        self.score = score
    }
}

class MetaManager {
    private(set) var meta: RelationshipState
    private(set) var currentRelationshipState: RelationshipState
    private(set) var score: Double
    
    init() {
        self.meta = .conhecido
        self.currentRelationshipState = .conhecido
        self.score = 0.0
    }
    
    private func calculateRelationshipState() {
        var rs: RelationshipState = .conhecido
        if self.score < SCORE_AMIGO {
            rs = .conhecido
        }
        else if self.score >= SCORE_AMIGO {
            rs = .amigo
        }
        else if self.score >= SCORE_AMIGO_PROXIMO {
            rs = .amigoProximo
        }
        else if self.score >= SCORE_MELHOR_AMIGO {
            rs = .melhorAmigo
        }
        currentRelationshipState = rs
    }
    
    func setMeta(_ meta: RelationshipState) {
        self.meta = meta
    }
    
    func addOrSubtractScore(_ score: Double) {
        self.score += score
        calculateRelationshipState()
    }
}
