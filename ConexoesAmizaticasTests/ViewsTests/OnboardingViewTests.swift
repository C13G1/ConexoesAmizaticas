//
//  OnboardingViewTests.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 28/05/26.
//

import Testing
import Foundation
import SwiftUI
import SwiftData
@testable import ConexoesAmizaticas

@MainActor
struct OnboardingViewLogicTests {

    private func makeContext() throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: AppSchema.schema,
            configurations: config
        )
        return ModelContext(container)
    }

    private func canProceed(name: String) -> Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    @Test("canProceed rejeita string vazia")
    func canProceedRejectsEmpty() {
        #expect(canProceed(name: "") == false)
    }

    @Test("canProceed aceita nome válido")
    func canProceedAcceptsValid() {
        #expect(canProceed(name: "Thomas") == true)
    }

    @Test("canProceed aceita nome com espaços no meio")
    func canProceedAcceptsMiddleSpaces() {
        #expect(canProceed(name: "Maria Silva") == true)
    }

    private func applyCharacterLimit(_ input: String, limit: Int = 10) -> String {
        input.count > limit ? String(input.prefix(limit)) : input
    }

    @Test("Nome dentro do limite passa intacto")
    func nameWithinLimit() {
        #expect(applyCharacterLimit("Lucas") == "Lucas")
        #expect(applyCharacterLimit("1234567890") == "1234567890") // exatamente 10
    }

    @Test("Nome acima do limite é cortado em 10 caracteres")
    func nameTruncatedAtLimit() {
        let truncated = applyCharacterLimit("UmNomeMuitoLongo")
        #expect(truncated.count == 10)
        #expect(truncated == "UmNomeMuit")
    }

    private func performCreateProfile(name: String, imageData: Data?, in context: ModelContext) {
        let finalImageData = imageData
            ?? UIImage(named: "defaultPicture")?.jpegData(compressionQuality: 1)
            ?? Data()
        let user = User(
            name: name.trimmingCharacters(in: .whitespaces),
            profilePicture: finalImageData
        )
        context.insert(user)
    }

    @Test("createProfile insere um User no contexto")
    func createProfileInsertsUser() throws {
        let context = try makeContext()
        performCreateProfile(name: "Teste", imageData: Data([0x01]), in: context)
        try context.save()

        let users = try context.fetch(FetchDescriptor<User>())
        #expect(users.count == 1)
        #expect(users.first?.getName() == "Teste")
    }

    @Test("createProfile remove espaços nas bordas do nome")
    func createProfileTrimsName() throws {
        let context = try makeContext()
        performCreateProfile(name: "  João  ", imageData: nil, in: context)
        try context.save()

        let users = try context.fetch(FetchDescriptor<User>())
        #expect(users.first?.getName() == "João")
    }
}
