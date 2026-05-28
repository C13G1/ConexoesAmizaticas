//
//  ConnectionModel.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import SwiftData
import Foundation

/// Represents a persistent relationship between the current user and a friend.
///
/// A `Connection` ties together the `User` profile of the friend, a `MetaManager` to track the relationship health,
/// and a `FeedManager` to store shared moments. It calculates crucial states, such as whether a friendship has fallen into the "vacuum" state.
@Model
class Connection: Hashable {
    private(set) var id: UUID = UUID()
    
    /// The profile of the friend associated with this connection.
    private(set) var friend: User
    
    var metaManager: MetaManager
    var feedManager: FeedManager
    
    var firstConnection: Date
    var lastMet: Date?
    
    /// The total duration since the connection was initially established.
    var timeConnected: TimeInterval {
        Date.now.timeIntervalSince(firstConnection)
    }
    
    /// The duration since the two users last registered a physical meeting.
    var timeSinceLastMet: TimeInterval {
        Date.now.timeIntervalSince(lastMet ?? Date.now)
    }
    
    var recordNotMeet: TimeInterval? {
        guard let lastMet = lastMet else { return nil }
        return Date.now.timeIntervalSince(lastMet)
    }
    
    var recordTimeNotMeeting: TimeInterval?

    /// A boolean indicating if the connection is at risk due to a lack of recent interactions.
    /// Returns `true` if more than 30 days have passed since the `lastMet` date.
    var inVacuo: Bool {
        let threshold: TimeInterval = 30 * 24 * 3600
        if let lastMet = lastMet {
            return Date.now.timeIntervalSince(lastMet) > threshold
        }
        return Date.now.timeIntervalSince(firstConnection) > threshold
    }

    init(friend: User, lastMet: Date? = nil, score: Double = 15.0) {
        self.friend = friend
        self.metaManager = MetaManager(score: score)
        self.feedManager = FeedManager()
        self.firstConnection = Date.now
        self.lastMet = lastMet
    }
}
