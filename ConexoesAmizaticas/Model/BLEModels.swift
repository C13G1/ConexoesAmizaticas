//
//  BLEModels.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 15/05/26.
//

import Foundation
import CoreBluetooth


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
