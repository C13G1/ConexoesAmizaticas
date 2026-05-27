//
//  ConnectionModel.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import SwiftData
import Foundation

@Model
class Connection: Hashable {
    private(set) var id: UUID = UUID()
    private(set) var friend: User
    var metaManager: MetaManager
    var feedManager: FeedManager
    var firstConnection: Date
    var lastMet: Date?
    var timeConnected: TimeInterval {
        let endDate = Date.now
        let timeConnected = endDate.timeIntervalSince(firstConnection)
        
        return timeConnected
    }
    var timeSinceLastMet   : TimeInterval {
        let endDate       = Date.now
        let timeConnected = endDate.timeIntervalSince(lastMet ?? Date.now)
        return timeConnected
    }
    
    var recordNotMeet: TimeInterval? {
        let endDate = Date.now
        guard let lastMet = lastMet else { return nil }
        let timeConnected = endDate.timeIntervalSince(lastMet)
        return timeConnected
    }
    var recordTimeNotMeeting: TimeInterval?

    var inVacuo: Bool {
        let threshold: TimeInterval = 30 * 24 * 3600
        if let lastMet = lastMet {
            return Date.now.timeIntervalSince(lastMet) > threshold
        }
        return Date.now.timeIntervalSince(firstConnection) > threshold
    }

    init(friend: User, lastMet: Date? = nil, score: Double = 15.0) {
        self.friend          = friend
        self.metaManager     = MetaManager(score: score)
        self.feedManager     = FeedManager()
        self.firstConnection = Date.now
        self.lastMet = lastMet
    }
}
