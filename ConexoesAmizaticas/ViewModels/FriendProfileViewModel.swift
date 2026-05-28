//
//  FriendProfileViewModel.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 20/05/26.
//

import Foundation
import SwiftUI
import SwiftData

/// A presentation layer responsible for formatting the raw database connection data into human-readable metrics.
///
/// It acts as a bridge between the complex `Connection` model and the `FriendsProfileView`, isolating UI
/// components from database calculations like calendar math, goal tracking, and dynamic styling based on relationship state.
class FriendProfileViewModel {
    private(set) var connection: Connection
    
    init(connection: Connection) {
        self.connection = connection
        self.setRecordTimeNotMeeting()
    }
    
    /// Overwrites the current interaction goal established for this relationship.
    func defineMeta(meta: Meta){
        connection.metaManager.setMeta(meta)
    }
    
    func getMeta() -> Meta {
        return connection.metaManager.meta
    }
    
    func getFriendImage() -> UIImage? {
        return UIImage(data: connection.friend.getProfileImageData())
    }
    
    func getFriendName() -> String {
        return connection.friend.getName()
    }
    
    /// Calculates the total lifespan of the friendship in exact days.
    func getConnectionTime() -> Int {
        let connectionDate = Date(timeIntervalSinceNow: connection.timeConnected)
        let now = Date()
        let days = Calendar.current.dateComponents([.day], from: connectionDate, to: now).day ?? 1
        return days
    }
    
    /// Computes the elapsed days since the user and the friend last recorded a physical meeting.
    func getTimeSinceLastMet() -> Int {
        let connectionDate = Date(timeIntervalSinceNow: connection.timeSinceLastMet)
        let now = Date()
        let days = Calendar.current.dateComponents([.day], from: connectionDate, to: now).day ?? 0
        return days
    }
    
    func getLastMeet() -> Date? {
        return connection.lastMet
    }
    
    /// Validates if the current absence streak breaks the historical record for this specific friendship.
    func setRecordTimeNotMeeting() {
        if connection.timeSinceLastMet > connection.recordTimeNotMeeting ?? 0 {
            connection.recordTimeNotMeeting = connection.timeSinceLastMet
        }
    }
    
    func getRecordTimeNotMeeting() -> Int {
        setRecordTimeNotMeeting()
        
        let connectionDate = Date(timeIntervalSinceNow: connection.recordTimeNotMeeting ?? 0)
        let now = Date()
        let days = Calendar.current.dateComponents([.day], from: connectionDate, to: now).day ?? 0
        return days
    }
    
    /// Derives the visual UI theme color based on the current health score of the relationship.
    func getProfileColor() -> Color {
        return Color(connection.metaManager.currentRelationshipState.color)
    }
    
    /// Computes the remaining time before the user fails their set relationship goal (`Meta`).
    /// - Returns: A positive integer representing remaining days, or a negative integer if the goal is overdue.
    func getTimeUntilMeet() -> Int {
        let connectionDate = Date(timeIntervalSinceNow: connection.timeSinceLastMet)
        let now = Date()
        let daysUntil = Calendar.current.dateComponents([.day], from: connectionDate, to: now).day ?? 0
        let trueDays = daysUntil - connection.metaManager.meta.days
        return trueDays
    }
}
