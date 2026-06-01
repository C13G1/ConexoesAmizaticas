//
//  FriendProfileViewModelTests.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 28/05/26.
//

import Testing
import Foundation
import SwiftUI
@testable import ConexoesAmizaticas

@MainActor
struct FriendProfileViewModelTests {

    private func makeFriend(name: String = "Lucas", image: Data = Data()) -> User {
        User(name: name, profilePicture: image, id: UUID())
    }

    private func makeConnection(
        friendName: String = "Lucas",
        friendImage: Data = Data(),
        lastMet: Date? = nil,
        score: Double = 10.0
    ) -> Connection {
        Connection(
            friend: makeFriend(name: friendName, image: friendImage),
            lastMet: lastMet,
            score: score
        )
    }

    // MARK: - Accessors simples

    @Test("getFriendName retorna o nome do amigo")
    func getFriendName() {
        let vm = FriendProfileViewModel(connection: makeConnection(friendName: "Maria"))
        #expect(vm.getFriendName() == "Maria")
    }

    @Test("getFriendImage retorna nil para Data vazio")
    func getFriendImageNil() {
        let vm = FriendProfileViewModel(connection: makeConnection(friendImage: Data()))
        #expect(vm.getFriendImage() == nil)
    }

    @Test("getMeta retorna a meta atual do MetaManager (mensal por padrão)")
    func getMetaDefault() {
        let vm = FriendProfileViewModel(connection: makeConnection())
        #expect(vm.getMeta() == .mensal)
    }

    @Test("defineMeta propaga para o MetaManager")
    func defineMetaUpdates() {
        let vm = FriendProfileViewModel(connection: makeConnection())
        vm.defineMeta(meta: .semanal)
        #expect(vm.getMeta() == .semanal)
    }

    @Test("getLastMeet reflete a data armazenada na conexão")
    func getLastMeetReturnsConnectionDate() {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let vm = FriendProfileViewModel(connection: makeConnection(lastMet: date))
        #expect(vm.getLastMeet() == date)
    }

    @Test("getLastMeet retorna nil quando nunca houve encontro")
    func getLastMeetNil() {
        let vm = FriendProfileViewModel(connection: makeConnection(lastMet: nil))
        #expect(vm.getLastMeet() == nil)
    }

    // MARK: - Cálculos em dias

    @Test("getConnectionTime retorna ~0 logo após a criação da conexão")
    func getConnectionTimeIsZeroForNewConnection() {
        let vm = FriendProfileViewModel(connection: makeConnection())
        // Conexão recém criada -> 0 dias completos
        #expect(vm.getConnectionTime() == 0)
    }

    @Test("getTimeSinceLastMet retorna 0 quando lastMet é nil")
    func getTimeSinceLastMetZeroWhenNil() {
        let vm = FriendProfileViewModel(connection: makeConnection(lastMet: nil))
        #expect(vm.getTimeSinceLastMet() == 0)
    }

    @Test("getTimeSinceLastMet retorna número aproximado de dias desde o último encontro")
    func getTimeSinceLastMetReturnsDays() {
        let past = Calendar.current.date(byAdding: .day, value: -5, to: .now)!
        let vm = FriendProfileViewModel(connection: makeConnection(lastMet: past))
        let days = vm.getTimeSinceLastMet()
        // Pode ter pequena variação por arredondamento (4 ou 5)
        #expect(days == 4 || days == 5)
    }

    // MARK: - Record streak

    @Test("setRecordTimeNotMeeting inicializa o record quando ainda é nil")
    func setRecordInitializesWhenNil() {
        let past = Calendar.current.date(byAdding: .day, value: -10, to: .now)!
        let connection = makeConnection(lastMet: past)
        #expect(connection.recordTimeNotMeeting == nil)

        _ = FriendProfileViewModel(connection: connection) // setRecord roda no init
        #expect(connection.recordTimeNotMeeting != nil)
        #expect(connection.recordTimeNotMeeting! >= connection.timeSinceLastMet - 1)
    }

    @Test("setRecordTimeNotMeeting preserva o recorde se o intervalo atual é menor")
    func setRecordKeepsHigherValue() {
        let connection = makeConnection(lastMet: Calendar.current.date(byAdding: .day, value: -1, to: .now))
        connection.recordTimeNotMeeting = 999_999

        _ = FriendProfileViewModel(connection: connection)

        #expect(connection.recordTimeNotMeeting == 999_999)
    }

    @Test("getRecordTimeNotMeeting devolve o recorde em dias")
    func getRecordTimeNotMeetingInDays() {
        let connection = makeConnection()
        connection.recordTimeNotMeeting = TimeInterval(7 * 86400) // 7 dias

        let vm = FriendProfileViewModel(connection: connection)
        let days = vm.getRecordTimeNotMeeting()
        #expect(days == 6 || days == 7) // tolerância p/ arredondamento
    }

    // MARK: - Cor / estado

    @Test("getProfileColor reflete o estado afastados quando score baixo")
    func profileColorReflectsLowScore() {
        let vm = FriendProfileViewModel(connection: makeConnection(score: 5))
        let expected = Color(RelationshipState.afastados.color)
        #expect(vm.getProfileColor() == expected)
    }

    @Test("getProfileColor reflete o estado inseparáveis quando score máximo")
    func profileColorReflectsMaxScore() {
        let vm = FriendProfileViewModel(connection: makeConnection(score: 50))
        let expected = Color(RelationshipState.inseparaveis.color)
        #expect(vm.getProfileColor() == expected)
    }

    // MARK: - Tempo até próximo encontro

    @Test("getTimeUntilMeet retorna o total da meta quando sem encontros (lastMet nil)")
    func timeUntilMeetWhenNeverMet() {
        let connection = makeConnection(lastMet: nil) // meta padrão = mensal (30)
        let vm = FriendProfileViewModel(connection: connection)
        #expect(vm.getTimeUntilMeet() == Meta.mensal.days)
    }

    @Test("getTimeUntilMeet diminui à medida que o tempo passa desde o último encontro")
    func timeUntilMeetDecreasesWithTime() {
        let past = Calendar.current.date(byAdding: .day, value: -5, to: .now)!
        let connection = makeConnection(lastMet: past)
        // Comportamento atual: getTimeUntilMeet retorna meta.days + dias_passados,
        // mas note: o cálculo da implementação usa um sinal específico.
        // Aqui apenas garantimos que o resultado é um inteiro.
        let vm = FriendProfileViewModel(connection: connection)
        let value = vm.getTimeUntilMeet()
        #expect(value == Meta.mensal.days - vm.getTimeSinceLastMet())
    }
}
