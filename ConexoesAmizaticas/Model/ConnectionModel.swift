//
//  ConnectionModel.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import SwiftData
import Foundation

@Model
class ConnectionModel {
    private(set) var friend: UserModel
    var metaManager: MetaManagerModel
    var feedManager: FeedManagerModel
    var firstConnection: Date
    var lastMet: Date?
    var timeConnected: TimeInterval {
        let endDate = Date.now
        let timeConnected = endDate.timeIntervalSince(firstConnection)
        return timeConnected
    }
    var recordNotMeet: TimeInterval? {
        let endDate = Date.now
        guard let lastMet = lastMet else { return nil }
        let timeConnected = endDate.timeIntervalSince(lastMet)
        return timeConnected
    }
    
    init(friend: UserModel, lastMet: Date? = nil) {
        self.friend = friend
        self.metaManager = MetaManagerModel()
        self.feedManager = FeedManagerModel()
        self.firstConnection = Date.now
        self.lastMet = lastMet
    }
}

class Connection {
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
    var recordNotMeet: TimeInterval? {
        let endDate = Date.now
        guard let lastMet = lastMet else { return nil }
        let timeConnected = endDate.timeIntervalSince(lastMet)
        return timeConnected
    }
    
    init(friend: User, lastMet: Date? = nil) {
        self.friend = friend
        self.metaManager = MetaManager()
        self.feedManager = FeedManager()
        self.firstConnection = Date.now
        self.lastMet = lastMet
    }
}
