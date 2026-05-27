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

    // avisa quando encontra um amigo no ble
    var onFriendFound: ((User) -> Void)?
    var onConnectionOpened: (() -> Void)?

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
    let profile: User
    private var didSendProfile = false

    init(profile: User) {
        self.profile = profile
        super.init()
    }

    func startBLE() {
        print("start ble")
        didSendProfile = false
        dataStream = Data()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    func stopBLE() {
        print("stop ble")
        centralManager?.stopScan()
        peripheralManager?.stopAdvertising()
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("central power on")
            centralManager.scanForPeripherals(withServices: [serviceID], options: nil)
        } else {
            print("central state: \(central.state.rawValue)")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi: NSNumber) {
        guard let keyString = advertisementData[CBAdvertisementDataLocalNameKey] as? String,
              let peripheralKey = Int(keyString) else { return }

        if peripheralKey > advertisingKey {
            print("virou peripheral")
            centralManager.stopScan()
            peripheralManager.publishL2CAPChannel(withEncryption: false)
        } else {
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
            let characteristic = CBMutableCharacteristic(
                type: portCharacteristicID,
                properties: [.read],
                value: nil,
                permissions: [.readable]
            )
            let service = CBMutableService(type: serviceID, primary: true)
            service.characteristics = [characteristic]
            peripheral.add(service)
            peripheral.startAdvertising([
                CBAdvertisementDataServiceUUIDsKey: [serviceID],
                CBAdvertisementDataLocalNameKey: "\(advertisingKey)"
            ])
        } else {
            print("peripheral state: \(peripheral.state.rawValue)")
        }
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("received read request")
        guard request.characteristic.uuid == portCharacteristicID, self.psm != nil else {
            peripheral.respond(to: request, withResult: .attributeNotFound)
            return
        }
        // CBL2CAPPSM é UInt16 (2 bytes)
        // o MemoryLayout evita out of range
        var psmValue = self.psm!
        let data = Data(bytes: &psmValue, count: MemoryLayout<CBL2CAPPSM>.size)
        request.value = data
        peripheral.respond(to: request, withResult: .success)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        print("updated value")
        if let error = error { print(error); return }
        guard characteristic.uuid == portCharacteristicID,
              let data = characteristic.value,
              data.count >= MemoryLayout<CBL2CAPPSM>.size else {
            print("psm data inválido")
            return
        }
        self.psm = data.withUnsafeBytes { $0.load(as: CBL2CAPPSM.self) }
        peripheral.openL2CAPChannel(self.psm)
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didPublishL2CAPChannel PSM: CBL2CAPPSM, error: (any Error)?) {
        if let error = error { print(error); return }
        print("published L2CAP channel")
        self.psm = PSM
    }

    // configura as streams após abrir canal L2CAP deixando o mesmo código para central e peripheral
    private func setupStreams(for channel: CBL2CAPChannel) {
        guard let output = channel.outputStream,
              let input = channel.inputStream else {
            print("couldnt create streams")
            return
        }
        self.channelL2CAP = channel
        self.outputStream = output
        self.inputStream = input
        self.outputStream.delegate = self
        self.inputStream.delegate = self
        self.inputStream.schedule(in: .main, forMode: .default)
        self.outputStream.schedule(in: .main, forMode: .default)
        self.outputStream.open()
        self.inputStream.open()
        DispatchQueue.main.async { self.onConnectionOpened?() }
    }

    func peripheral(_ peripheral: CBPeripheral, didOpen channel: CBL2CAPChannel?, error: (any Error)?) {
        if let error = error { print(error); return }
        guard let channel = channel else { print("channel is nil"); return }
        print("opened L2CAP channel (central)")
        setupStreams(for: channel)
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didOpen channel: CBL2CAPChannel?, error: (any Error)?) {
        if let error = error { print(error); return }
        guard let channel = channel else { print("channel is nil"); return }
        print("opened L2CAP channel (peripheral)")
        setupStreams(for: channel)
    }

    func receiveData() {
        print("trying to receive data")
        var buffer = [UInt8](repeating: 0, count: BUFFER_SIZE)
        while inputStream.hasBytesAvailable {
            let bytesReceived = inputStream.read(&buffer, maxLength: BUFFER_SIZE)
            if bytesReceived > 0 {
                self.dataStream.append(contentsOf: buffer.prefix(bytesReceived))
            }
        }
        do {
            try decodeData()
        } catch {
            print("erro decodificando data: \(error)")
        }
    }

    func decodeData() throws {
        let friendDTO = try JSONDecoder().decode(userDTO.self, from: self.dataStream)
        let friend = User(name: friendDTO.name, profilePicture: friendDTO.profilePicture, id: friendDTO.id)
        print("data decoded: \(friend.name)")
        DispatchQueue.main.async { self.onFriendFound?(friend) }
    }

    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            receiveData()
        case .openCompleted:
            // envia o perfil quando o outputStream ta ok
            if aStream === outputStream && !didSendProfile {
                didSendProfile = true
                try? sendProfile()
            }
        case .errorOccurred:
            print("erro na stream")
        case .endEncountered:
            print("stream fechada")
        default:
            break
        }
    }

    func sendProfile() throws {
        print("trying to send data")
        guard outputStream.hasSpaceAvailable else {
            print("no space available")
            return
        }
        let profileDTO = userDTO(name: profile.name, profilePicture: profile.profilePicture, id: profile.id)
        let data = try JSONEncoder().encode(profileDTO)
        data.withUnsafeBytes { buffer in
            guard let pointer = buffer.bindMemory(to: UInt8.self).baseAddress else {
                print("erro ao criar ponteiro")
                return
            }
            let bytesWritten = self.outputStream.write(pointer, maxLength: data.count)
            print(bytesWritten >= 0 ? "dados enviados (\(bytesWritten) bytes)" : "erro ao enviar dados")
        }
    }
}
