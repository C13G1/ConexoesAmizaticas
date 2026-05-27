//
//  FriendProfileViewModel.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 20/05/26.
//

import Foundation
import SwiftUI
import SwiftData

class FriendProfileViewModel {
    private(set) var connection: Connection
    
    init(connection: Connection) {
        self.connection = connection
        self.setRecordTimeNotMeeting()
    }
    
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
    
    func getConnectionTime() -> Int {
        let connectionDate = Date(timeIntervalSinceNow: connection.timeConnected)
        let now = Date()
        let days = Calendar.current.dateComponents([.day], from: connectionDate, to: now).day ?? 1
        return days
    }
    
    func getTimeSinceLastMet() -> Int {
        let connectionDate = Date(timeIntervalSinceNow: connection.timeSinceLastMet)
        let now = Date()
        let days = Calendar.current.dateComponents([.day], from: connectionDate, to: now).day ?? 0
        return days
    }
    
    func getLastMeet() -> Date? {
        return connection.lastMet
    }
    
    func setRecordTimeNotMeeting() {
        if connection.timeSinceLastMet > connection.recordTimeNotMeeting ?? 0 {
            connection.recordTimeNotMeeting = connection.timeSinceLastMet
        }
    }
    
    func getRecordTimeNotMeeting() -> Int{
        setRecordTimeNotMeeting()
        
        let connectionDate = Date(timeIntervalSinceNow: connection.recordTimeNotMeeting ?? 0)
        let now = Date()
        let days = Calendar.current.dateComponents([.day], from: connectionDate, to: now).day ?? 0
        return days
    }
    
    func getProfileColor() -> Color{
        return Color(connection.metaManager.currentRelationshipState.color)
    }
    
    func getTimeUntilMeet() -> Int{
        let connectionDate = Date(timeIntervalSinceNow: connection.timeSinceLastMet)
        let now = Date()
        let daysUntil = Calendar.current.dateComponents([.day], from: connectionDate, to: now).day ?? 0
        let trueDays = daysUntil - connection.metaManager.meta.days
        return trueDays
    }
}
