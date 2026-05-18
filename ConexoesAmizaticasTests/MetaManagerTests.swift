//
//  PostTests.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 18/05/26.
//

import SwiftUI
import Testing
@testable import ConexoesAmizaticas

struct MetaManagerTests {
    var meta: MetaManager = MetaManager()
    
    @Test func setMetaWithSuccessTest() {
        let sut = meta
        sut.setMeta(.amigo)
        
        #expect(sut.meta == .amigo)
    }
    
    @Test func addOrSubtractScoreWithSuccessTest() {
        let sut = meta
        sut.addOrSubtractScore(100.0)
        
        #expect(sut.score == 100.0)
    }
}
