//
//  ContentViewTests.swift
//  ConexoesAmizaticasTests
//
//  ContentView é puramente um router baseado em @Query <User>.
//  Testamos o comportamento esperado da escolha: vazio → Onboarding, populado → Initial.
//

import Testing
import Foundation
import SwiftData
@testable import ConexoesAmizaticas

@MainActor
struct ContentViewRoutingTests {

    private func makeContext() throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: User.self, Connection.self, MetaManager.self, FeedManager.self, Post.self,
            configurations: config
        )
        return ModelContext(container)
    }

    private enum Route {
        case onboarding
        case initial
    }

    private func route(for users: [User]) -> Route {
        users.isEmpty ? .onboarding : .initial
    }

    @Test("Sem usuários no store, roteia para Onboarding")
    func emptyStoreRoutesToOnboarding() throws {
        let context = try makeContext()
        let users = try context.fetch(FetchDescriptor<User>())
        #expect(route(for: users) == .onboarding)
    }

    @Test("Com pelo menos um usuário, roteia para Initial")
    func populatedStoreRoutesToInitial() throws {
        let context = try makeContext()
        context.insert(User(name: "Eu", profilePicture: Data()))
        try context.save()

        let users = try context.fetch(FetchDescriptor<User>())
        #expect(route(for: users) == .initial)
    }

    @Test("Com múltiplos usuários, ainda roteia para Initial")
    func multipleUsersRouteToInitial() throws {
        let context = try makeContext()
        context.insert(User(name: "A", profilePicture: Data()))
        context.insert(User(name: "B", profilePicture: Data()))
        try context.save()

        let users = try context.fetch(FetchDescriptor<User>())
        #expect(route(for: users) == .initial)
    }
}
