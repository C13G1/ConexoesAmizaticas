//
//  BLEModels.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 15/05/26.
//

import Foundation
import CoreBluetooth
import SwiftUI

let SCORE_AMIGO: Double = 1 / 4
let SCORE_AMIGO_PROXIMO: Double = 1 / 2
let SCORE_MELHOR_AMIGO: Double = 5 / 6

class User {
    private(set) var name: String
    private(set) var profilePicture: Image
    let id: UUID
    
    init(name: String, profilePicture: Image = Image("defaultPicture")) {
        self.name = name
        self.profilePicture = profilePicture
        self.id = UUID()
    }
    
    func editProfilePicture(_ image: Image) {
        self.profilePicture = image
    }
    func editName(_ name: String) {
        self.name = name
    }
}

class Connection {
    let friend: User
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

class MetaManager {
    private(set) var meta: RelationshipState
    private(set) var currentRelationshipState: RelationshipState
    private(set) var score: Double
    
    func setMeta(_ meta: RelationshipState) {
        self.meta = meta
    }
    
    private func calculateRelationshipState() {
        var rs: RelationshipState = .conhecido
        if self.score < SCORE_AMIGO {
            rs = .conhecido
        }
        else if self.score >= SCORE_AMIGO {
            rs = .amigo
        }
        else if self.score >= SCORE_AMIGO_PROXIMO {
            rs = .amigoProximo
        }
        else if self.score >= SCORE_MELHOR_AMIGO {
            rs = .melhorAmigo
        }
        currentRelationshipState = rs
    }
    
    func addOrSubtractScore(_ score: Double) {
        self.score += score
        calculateRelationshipState()
    }
    
    init() {
        self.meta = .conhecido
        self.currentRelationshipState = .conhecido
        self.score = 0.0
    }
}

class FeedManager {
    private var posts: [Post]
    
    init(){}
    
    func addPost(_ post: Post) {
        posts.append(post)
    }
    
    func deletePost(id: UUID) {
        posts.removeAll(where: {$0.id == id})
    }
    
}

class Post: Identifiable {
    var images: [Image]
    var text: String?
    var date: Date
    var id: UUID
    
    init(images: [Image], text: String? = nil, date: Date = Date.now) {
        self.images = images
        self.text = text
        self.date = date
        self.id = UUID()
    }
    
    func editText(_ newText: String) {
        self.text = newText
    }
    
    func appendImage(_ image: Image) {
        images.append(image)
    }
    
    func deleteImage(_ image: Image) {
        images.removeAll(where: {$0 == image})
    }
}

enum RelationshipState {
    case conhecido
    case amigo
    case amigoProximo
    case melhorAmigo
}

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate {
    var view: BLEView!
    var centralManager: CBCentralManager!
    var peripheralManager: CBPeripheralManager!
    let serviceID: CBUUID = CBUUID(string: "451A3F17-0062-41E1-82CC-98496CDA05FB")
    let characteristicID: CBUUID = CBUUID(string: "B2C20EFB-B20F-4F0D-B708-4EA408F2C500")
    let advertisingKey: Int = Int.random(in: 1...100_000_000)
    let profile = User(name: "souja boy")
    
    init(view: BLEView!) {
        self.view = view
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func startBLE() {
        centralManager.scanForPeripherals(withServices: [serviceID])
        peripheralManager.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey: [serviceID],
            CBAdvertisementDataLocalNameKey: "\(advertisingKey)"
        ])
    }
    
    func stopBLE() {
        centralManager.stopScan()
        peripheralManager.stopAdvertising()
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [serviceID], options: nil)
        } else {
            print("deu errado :(")
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        let peripheralKey = Int(advertisementData[CBAdvertisementDataLocalNameKey] as! String)!
        if peripheralKey > advertisingKey {
            centralManager.stopScan()
        }
        else {
            centralManager.connect(peripheral)
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([serviceID])
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Erro ao descobrir serviços: \(error.localizedDescription)")
            return
        }
        guard let services = peripheral.services else { return }
        
        for service in services {
            peripheral.discoverCharacteristics([characteristicID], for: service)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid == characteristicID {
                peripheral.readValue(for: characteristic)
            }
        }
    }
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if peripheral.state == .poweredOn {
            let characteristic = CBMutableCharacteristic(type: characteristicID,
                                                         properties: [],
                                                         value: nil,
                                                         permissions: .readable)
            let service = CBMutableService(type: serviceID, primary: true)
            service.characteristics = [characteristic]
            
            peripheral.add(service)
            peripheral.startAdvertising(
                [CBAdvertisementDataServiceUUIDsKey: [serviceID],
                    CBAdvertisementDataLocalNameKey: "sla"])
        } else {
            print("deu errado :(")
        }
    }
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        if request.characteristic.uuid == characteristicID {
            if let data = try? JSONEncoder().encode(profile) {
                request.value = data
                peripheral.respond(to: request, withResult: .success)
            }
            else {
                peripheral.respond(to: request, withResult: .unlikelyError)
            }
        }
    }
}
