//
//  CloudKitManager.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 27/05/26.
//

import CloudKit
import Foundation

/// Handles CloudKit-based push notifications between Zelu users.
///
/// Uses the public CloudKit database so no iCloud account pairing is needed between users.
/// All notifications are targeted by `recipientID` (the recipient's local UUID), so each device
/// only subscribes to records addressed to itself.
struct CloudKitManager {
    private static let database = CKContainer(
        identifier: "iCloud.com.AppleDeveloperAcademyMackenzie.POCCloudKit"
    ).publicCloudDatabase

    // MARK: - Proximity Ping (A detects B via BLE → A notifies B via CloudKit)

    /// Subscribes to pushes sent when a known friend physically detects this device via BLE.
    /// Safe to call on every launch — exits early if the subscription exists.
    static func subscribeToProximityPings(userID: UUID) {
        let subscriptionID = "proximity-pings-\(userID.uuidString)"
        database.fetch(withSubscriptionID: subscriptionID) { existing, _ in
            guard existing == nil else { return }
            let predicate = NSPredicate(format: "recipientID == %@", userID.uuidString)
            let subscription = CKQuerySubscription(
                recordType: "ProximityPing",
                predicate: predicate,
                subscriptionID: subscriptionID,
                options: .firesOnRecordCreation
            )
            let info = CKSubscription.NotificationInfo()
            info.alertBody = "Alguém está por perto no Zelu!"
            info.soundName = "default"
            info.shouldBadge = false
            subscription.notificationInfo = info
            database.save(subscription) { _, _ in }
        }
    }

    /// Writes a `ProximityPing` record after detecting a known friend via BLE,
    /// triggering a CloudKit push to that friend's device.
    static func notifyFriendNearby(friendID: UUID, senderName: String) {
        let record = CKRecord(recordType: "ProximityPing")
        record["recipientID"] = friendID.uuidString
        record["senderName"] = senderName
        database.save(record) { _, _ in }
    }

}
