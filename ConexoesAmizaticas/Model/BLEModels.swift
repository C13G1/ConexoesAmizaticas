//
//  BLEModels.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 15/05/26.
//

import Foundation
import CoreBluetooth
import UIKit
import SwiftUI

let BUFFER_SIZE = 1024


class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate, StreamDelegate {
    var view: BLEView
    var centralManager: CBCentralManager!
    var peripheralManager: CBPeripheralManager!
    var connectedPeripheral: CBPeripheral!
    let serviceID: CBUUID = CBUUID(string: "451A3F17-0062-41E1-82CC-98496CDA05FB")
    let portCharacteristicID: CBUUID = CBUUID(string: "B2C20EFB-B20F-4F0D-B708-4EA408F2C500")
    let advertisingKey: Int = Int.random(in: 1...100_000_000)
    var psm: CBL2CAPPSM!
    var channelL2CAP: CBL2CAPChannel!
    var inputStream: InputStream!
    var outputStream: OutputStream!
    var dataStream: Data = Data()
    let profile = User(name: "souja boy", profilePicture: UIImage(named: "yodaPicture")!.jpegData(compressionQuality: 0.1)!)
    
    init(view: BLEView) {
        self.view = view
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        print("init blemanager")
    }
    
    func startBLE() {
        print("start ble")
        centralManager.scanForPeripherals(withServices: [serviceID])
        peripheralManager.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey: [serviceID],
            CBAdvertisementDataLocalNameKey: "\(advertisingKey)"
        ])
    }
    
    func stopBLE() {
        print("stop ble")
        centralManager.stopScan()
        peripheralManager.stopAdvertising()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("central power on")
            centralManager.scanForPeripherals(withServices: [serviceID], options: nil)
        } else {
            print("deu errado :(")
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        let peripheralKey = Int(advertisementData[CBAdvertisementDataLocalNameKey] as! String)!
        if peripheralKey > advertisingKey {
            print("virou peripheral")
            centralManager.stopScan()
            peripheralManager.publishL2CAPChannel(withEncryption: false)
        }
        else {
            print("virou central")
            self.connectedPeripheral = peripheral
            centralManager.connect(connectedPeripheral)
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("central connected")
        peripheral.delegate = self
        peripheral.discoverServices([serviceID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Erro ao descobrir serviços: \(error.localizedDescription)")
            return
        }
        guard let services = peripheral.services else { return }
        print("found services")
        
        for service in services {
            peripheral.discoverCharacteristics([portCharacteristicID], for: service)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        guard let characteristics = service.characteristics else { return }
        print("discovered characteristics")
        for characteristic in characteristics {
            if characteristic.uuid == portCharacteristicID {
                peripheral.readValue(for: characteristic)
            }
        }
    }
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if peripheral.state == .poweredOn {
            print("peripheral powered on")
            let characteristic = CBMutableCharacteristic(type: portCharacteristicID,
                                                         properties: [.read],
                                                         value: nil,
                                                         permissions: [.readable])
            let service = CBMutableService(type: serviceID, primary: true)
            service.characteristics = [characteristic]
            
            peripheral.add(service)
            peripheral.startAdvertising(
                [CBAdvertisementDataServiceUUIDsKey: [serviceID],
                    CBAdvertisementDataLocalNameKey: "\(advertisingKey)"])
        } else {
            print("deu errado :(")
        }
    }
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("received read request")
        if request.characteristic.uuid == portCharacteristicID {
            let data = Data(bytes: &psm, count: 16)
            request.value = data
            peripheral.respond(to: request, withResult: .success)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        print("updated value")
        if let error = error {
            print(error)
        }
        if characteristic.uuid == portCharacteristicID {
            guard let data = characteristic.value else {
                print("psm is empty")
                return
            }
            self.psm = data.withUnsafeBytes({$0.load(as: CBL2CAPPSM.self)})
            peripheral.openL2CAPChannel(self.psm)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didPublishL2CAPChannel PSM: CBL2CAPPSM, error: (any Error)?) {
        if let error = error {
            print(error)
        }
        print("published L2CAP channel")
        self.psm = PSM
    }
    
    func peripheral(_ peripheral: CBPeripheral, didOpen channel: CBL2CAPChannel?, error: (any Error)?) {
        if let error = error {
            print(error)
        }
        guard let channel = channel else {
            print("channel is nil")
            return
        }
        print("opened L2CAP channel")
        self.channelL2CAP = channel
        guard let outputStream = channel.outputStream,
              let inputStream = channel.inputStream else {
            print("couldnt create streams")
            return
        }
        self.outputStream = outputStream
        self.inputStream = inputStream
        self.outputStream.delegate = self
        self.inputStream.delegate = self
        self.inputStream.schedule(in: .main, forMode: .default)
        self.outputStream.schedule(in: .main, forMode: .default)
        self.outputStream.open()
        self.inputStream.open()
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didOpen channel: CBL2CAPChannel?, error: (any Error)?) {
        
        if let error = error {
            print(error)
        }
        guard let channel = channel else {
            print("channel is nil")
            return
        }
        print("opened L2CAP channel")
        self.channelL2CAP = channel
        guard let outputStream = channel.outputStream,
              let inputStream = channel.inputStream else {
            print("couldnt create streams")
            return
        }
        self.outputStream = outputStream
        self.inputStream = inputStream
        self.outputStream.delegate = self
        self.inputStream.delegate = self
        self.inputStream.schedule(in: .main, forMode: .default)
        self.outputStream.schedule(in: .main, forMode: .default)
        self.outputStream.open()
        self.inputStream.open()
    }
    
    func receiveData() {
        print("trying to receive data")
        var buffer = [UInt8](repeating: 0, count: 1024)
        while inputStream.hasBytesAvailable {
            print("reading bytes")
            let bytesReceived = inputStream.read(&buffer, maxLength: BUFFER_SIZE)
            
            if bytesReceived > 0 {
                self.dataStream.append(buffer, count: bytesReceived)
            }
            else {
                print("eita porra")
            }
        }
        do {
            try decodeData()
        }
        catch {
            print("erro decodificando data")
        }
    }
    
    func decodeData() throws {
        let friendDTO = try JSONDecoder().decode(userDTO.self, from: self.dataStream)
        let friend = User(name: friendDTO.name, profilePicture: friendDTO.profilePicture, id: friendDTO.id)
        print("data decoded")
        view.updateFriend(friend)
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            receiveData()
        case .errorOccurred:
            print("erro na stream")
        case .openCompleted:
            print("stream aberta")
        case .endEncountered:
            print("stream fechada")
        case .hasSpaceAvailable:
            print("espaço aberto")
        default:
            print("vish sla")
        }
    }
    
    func sendProfile() throws {
        
        print("trying to send data")
        if self.outputStream.hasSpaceAvailable {
            let profileDTO = userDTO(name: profile.name, profilePicture: profile.profilePicture, id: profile.id)
            let data = try JSONEncoder().encode(profileDTO)
            data.withUnsafeBytes { buffer in
                guard let pointer = buffer.bindMemory(to: UInt8.self).baseAddress else {
                    print("erro ao criar ponteiro")
                    return
                }
                print("data created")
                let bytesWritten = self.outputStream.write(pointer, maxLength: data.count)
                if bytesWritten < 0 {
                    print("erro ao enviar dados")
                }
                else {
                    print("dados enviados")
                }
            }
        }
        else {
            print("no space available")
        }
    }
}
