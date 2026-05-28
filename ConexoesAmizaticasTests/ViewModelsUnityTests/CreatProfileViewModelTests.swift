//
//  CreatProfileViewModelTests.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 28/05/26.
//

import Testing
import Foundation
import SwiftUI
import SwiftData
@testable import ConexoesAmizaticas

@MainActor
struct CreatProfileViewModelTests {

    private func makeContext() throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: User.self, Connection.self, MetaManager.self, FeedManager.self, Post.self,
            configurations: config
        )
        return ModelContext(container)
    }

    @Test("Init com store vazio começa com profile vazio")
    func initStartsEmpty() throws {
        let context = try makeContext()
        let vm = CreatProfileViewModel(modelContext: context)
        #expect(vm.profile.isEmpty)
    }

    @Test("fetchData carrega os usuários existentes do store")
    func fetchDataLoadsExistingUsers() throws {
        let context = try makeContext()
        let existing = User(name: "Existente", profilePicture: Data(), id: UUID())
        context.insert(existing)
        try context.save()

        let vm = CreatProfileViewModel(modelContext: context)

        #expect(vm.profile.count == 1)
        #expect(vm.profile.first?.getName() == "Existente")
    }

    @Test("modelContext é preservado depois do init")
    func modelContextIsStored() throws {
        let context = try makeContext()
        let vm = CreatProfileViewModel(modelContext: context)
        #expect(vm.modelContext === context)
    }

    @Test("fetchData ordena resultados por id estável entre chamadas")
    func fetchDataIsStable() throws {
        let context = try makeContext()
        let u1 = User(name: "A", profilePicture: Data(), id: UUID())
        let u2 = User(name: "B", profilePicture: Data(), id: UUID())
        context.insert(u1)
        context.insert(u2)
        try context.save()

        let vm = CreatProfileViewModel(modelContext: context)
        let firstOrder = vm.profile.map(\.id)

        vm.fetchData()
        let secondOrder = vm.profile.map(\.id)

        #expect(firstOrder == secondOrder)
    }
}
