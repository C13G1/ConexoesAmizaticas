//
//  MetaManagerTests.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 28/05/26.
//


import Testing
import Foundation
@testable import ConexoesAmizaticas

struct MetaManagerTests {

    // MARK: - Init

    @Test("Init usa score padrão de 10 e meta mensal")
    func defaultInit() {
        let mm = MetaManager()
        #expect(mm.score == 10.0)
        #expect(mm.meta == .mensal)
        #expect(mm.lastDecayDate == nil)
        #expect(mm.currentRelationshipState == .afastados)
    }

    @Test("Init com score customizado define o estado corretamente",
          arguments: [
            (0.0,  RelationshipState.afastados),
            (15.0, RelationshipState.afastados),
            (20.0, RelationshipState.distantes),
            (29.9, RelationshipState.distantes),
            (30.0, RelationshipState.estaveis),
            (39.9, RelationshipState.estaveis),
            (40.0, RelationshipState.proximos),
            (49.9, RelationshipState.proximos),
            (50.0, RelationshipState.inseparaveis)
          ])
    func initSetsCorrectState(score: Double, expected: RelationshipState) {
        let mm = MetaManager(score: score)
        #expect(mm.currentRelationshipState == expected)
    }

    // MARK: - setMeta

    @Test("setMeta atualiza a meta")
    func setMetaUpdatesMeta() {
        let mm = MetaManager()
        mm.setMeta(.semanal)
        #expect(mm.meta == .semanal)
    }

    // MARK: - addOrSubtractScore

    @Test("addOrSubtractScore soma valor positivo")
    func addPositiveScore() {
        let mm = MetaManager(score: 10)
        mm.addOrSubtractScore(15)
        #expect(mm.score == 25)
        #expect(mm.currentRelationshipState == .distantes)
    }

    @Test("addOrSubtractScore subtrai valor negativo")
    func addNegativeScore() {
        let mm = MetaManager(score: 30)
        mm.addOrSubtractScore(-10)
        #expect(mm.score == 20)
        #expect(mm.currentRelationshipState == .distantes)
    }

    @Test("Score é limitado em 50 (cap superior)")
    func scoreCapsAtFifty() {
        let mm = MetaManager(score: 45)
        mm.addOrSubtractScore(100)
        #expect(mm.score == 50)
        #expect(mm.currentRelationshipState == .inseparaveis)
    }

    @Test("Score é limitado em 0 (cap inferior)")
    func scoreCapsAtZero() {
        let mm = MetaManager(score: 5)
        mm.addOrSubtractScore(-100)
        #expect(mm.score == 0)
        #expect(mm.currentRelationshipState == .afastados)
    }

    @Test("Adicionar zero não altera o score")
    func addingZeroKeepsScore() {
        let mm = MetaManager(score: 25)
        mm.addOrSubtractScore(0)
        #expect(mm.score == 25)
    }

    // MARK: - applyDecayIfNeeded

    @Test("Decay não é aplicado quando meta é nenhuma")
    func decayNotAppliedForMetaNenhuma() {
        let mm = MetaManager(score: 50)
        mm.setMeta(.nenhuma)
        let lastMet = Calendar.current.date(byAdding: .day, value: -365, to: .now)
        mm.applyDecayIfNeeded(lastMet: lastMet)
        #expect(mm.score == 50)
    }

    @Test("Decay não é aplicado se nenhum período foi completado")
    func decayNotAppliedWithinPeriod() {
        let mm = MetaManager(score: 50)
        mm.setMeta(.semanal) // 7 days
        let lastMet = Calendar.current.date(byAdding: .day, value: -3, to: .now)
        mm.applyDecayIfNeeded(lastMet: lastMet)
        #expect(mm.score == 50)
    }

    @Test("Aplica -5 por cada período perdido (1 período)")
    func decayOnePeriod() {
        let mm = MetaManager(score: 50)
        mm.setMeta(.semanal) // 7 dias
        let lastMet = Calendar.current.date(byAdding: .day, value: -10, to: .now)
        mm.applyDecayIfNeeded(lastMet: lastMet)
        // 10 / 7 = 1 período perdido -> -5
        #expect(mm.score == 45)
    }

    @Test("Aplica decay proporcional a múltiplos períodos perdidos")
    func decayMultiplePeriods() {
        let mm = MetaManager(score: 50)
        mm.setMeta(.semanal) // 7 dias
        let lastMet = Calendar.current.date(byAdding: .day, value: -30, to: .now)
        mm.applyDecayIfNeeded(lastMet: lastMet)
        // 30 / 7 = 4 períodos -> -20
        #expect(mm.score == 30)
    }

    @Test("Chamar applyDecayIfNeeded múltiplas vezes não aplica decay duplicado")
    func decayIsNotDoubleApplied() {
        let mm = MetaManager(score: 50)
        mm.setMeta(.semanal)
        let lastMet = Calendar.current.date(byAdding: .day, value: -10, to: .now)

        mm.applyDecayIfNeeded(lastMet: lastMet)
        let scoreAfterFirst = mm.score

        mm.applyDecayIfNeeded(lastMet: lastMet)
        #expect(mm.score == scoreAfterFirst)
    }

    @Test("Sem lastMet e sem lastDecayDate, nenhum decay é aplicado")
    func decayNotAppliedWithoutBaseDate() {
        let mm = MetaManager(score: 50)
        mm.setMeta(.semanal)
        mm.applyDecayIfNeeded(lastMet: nil)
        #expect(mm.score == 50)
    }

    @Test("Decay nunca leva score abaixo de zero")
    func decayDoesNotGoBelowZero() {
        let mm = MetaManager(score: 5)
        mm.setMeta(.semanal)
        let lastMet = Calendar.current.date(byAdding: .day, value: -100, to: .now)
        mm.applyDecayIfNeeded(lastMet: lastMet)
        #expect(mm.score == 0)
        #expect(mm.currentRelationshipState == .afastados)
    }

    @Test("Encontro recente reseta a base de decay")
    func recentMeetingResetsBase() {
        let mm = MetaManager(score: 50)
        mm.setMeta(.semanal)

        // primeiro: aplica decay com base antiga
        let oldDate = Calendar.current.date(byAdding: .day, value: -30, to: .now)
        mm.applyDecayIfNeeded(lastMet: oldDate)
        let scoreAfterDecay = mm.score

        // agora um encontro recente acontece
        let recentMeet = Calendar.current.date(byAdding: .day, value: -1, to: .now)
        mm.applyDecayIfNeeded(lastMet: recentMeet)

        // não deveria aplicar nenhum decay novo
        #expect(mm.score == scoreAfterDecay)
    }
}
