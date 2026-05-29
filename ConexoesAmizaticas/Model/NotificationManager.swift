//
//  NotificationManager.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 27/05/26.
//

import Foundation
import UserNotifications
import CoreBluetooth
import UIKit

struct NotificationManager {

    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    static func scheduleMetaReminder(for connection: Connection) {
        let id = "meta_\(connection.id.uuidString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])

        let meta = connection.metaManager.meta
        guard meta != .nenhuma, meta.days > 0 else { return }

        let reference = connection.lastMet ?? connection.firstConnection
        let totalInterval = TimeInterval(meta.days) * 86400
        let notifyDate = reference.addingTimeInterval(totalInterval * 0.8)
        let deadlineDate = reference.addingTimeInterval(totalInterval)
        let now = Date()

        guard deadlineDate > now else { return }

        let content = UNMutableNotificationContent()
        content.title = "Tá na hora de marcar um encontro!"
        content.body = "Você prometeu se encontrar com \(connection.friend.name) \(meta.displayText). O prazo está chegando!"
        content.sound = .default

        let trigger: UNNotificationTrigger?
        if notifyDate <= now {
            trigger = nil
        } else {
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notifyDate)
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        }

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    static func cancelMetaReminder(for connection: Connection) {
        let id = "meta_\(connection.id.uuidString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

    static func rescheduleAll(connections: [Connection]) {
        for connection in connections {
            scheduleMetaReminder(for: connection)
        }
    }
}

// Scans for nearby Zelu users in the background and fires a local notification.
class ProximityNotifier: NSObject, CBCentralManagerDelegate {
    static let shared = ProximityNotifier()

    private var centralManager: CBCentralManager?
    private let serviceID = CBUUID(string: "451A3F17-0062-41E1-82CC-98496CDA05FB")
    private var lastNotificationDate: Date?
    private let cooldown: TimeInterval = 5 * 60

    private override init() { super.init() }

    func start() {
        guard centralManager == nil else { return }
        centralManager = CBCentralManager(
            delegate: self,
            queue: nil,
            options: [CBCentralManagerOptionRestoreIdentifierKey: "com.conexoesamizaticas.proximity"]
        )
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(
                withServices: [serviceID],
                options: [CBCentralManagerScanOptionAllowDuplicatesKey: false]
            )
        }
    }

    // Called by iOS when the app is relaunched in background after being terminated by the system
    // (not force-quit). Restarting the scan here resumes proximity detection immediately.
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String: Any]) {
        if central.state == .poweredOn {
            central.scanForPeripherals(
                withServices: [serviceID],
                options: [CBCentralManagerScanOptionAllowDuplicatesKey: false]
            )
        }
    }

    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi: NSNumber
    ) {
        if let last = lastNotificationDate, Date().timeIntervalSince(last) < cooldown { return }
        lastNotificationDate = Date()

        // Local notification — fires immediately on this device (app in background)
        let content = UNMutableNotificationContent()
        content.title = "Alguém com Zelu está por perto!"
        content.body = "Abra o app para registrar um encontro com seu amigo."
        content.sound = .default
        let request = UNNotificationRequest(
            identifier: "proximity_\(UUID().uuidString)",
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(request)

        // reinicia o scan depois do cooldown de 5 min, evita spam
        central.stopScan()
        DispatchQueue.main.asyncAfter(deadline: .now() + cooldown) { [weak self] in
            guard let self, central.state == .poweredOn else { return }
            central.scanForPeripherals(
                withServices: [self.serviceID],
                options: [CBCentralManagerScanOptionAllowDuplicatesKey: false]
            )
        }
    }
}
