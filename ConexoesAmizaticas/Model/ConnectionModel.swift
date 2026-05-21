//
//  ConnectionModel.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import SwiftData
import Foundation

@Model
class Connection {
    private(set) var friend : User
    var metaManager         : MetaManager
    var feedManager         : FeedManager
    var firstConnection     : Date
    var lastMet             : Date?
    var timeConnected       : TimeInterval {
        let endDate       = Date.now
        let timeConnected = endDate.timeIntervalSince(firstConnection)
        
        return timeConnected
    }
    var recordNotMeet: TimeInterval? {
        let endDate       = Date.now
        guard let lastMet = lastMet else { return nil }
        let timeConnected = endDate.timeIntervalSince(lastMet)
        
        return timeConnected
    }
    
    init(friend: User, lastMet: Date? = nil, score: Double = 1.0) {
        self.friend          = friend
        self.metaManager     = MetaManager(score: score)
        self.feedManager     = FeedManager()
        self.firstConnection = Date.now
        self.lastMet         = lastMet
    }
}
