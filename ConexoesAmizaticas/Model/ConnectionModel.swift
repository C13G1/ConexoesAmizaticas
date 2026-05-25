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
    var timeSinceLastMet   : TimeInterval {
        let endDate       = Date.now
        let timeConnected = endDate.timeIntervalSince(lastMet ?? Date.now)
        
        return timeConnected
    }
    var recordTimeNotMeeting: TimeInterval?
    
    init(friend: User, lastMet: Date? = nil) {
        self.friend          = friend
        self.metaManager     = MetaManager()
        self.feedManager     = FeedManager()
        self.firstConnection = Date.now
        self.lastMet         = lastMet
    }
}
