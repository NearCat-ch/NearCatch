//
//  CBSession.swift
//  NearCatch
//
//  Created by Wonhyuk Choi on 2022/11/30.
//

import CoreBluetooth
import Foundation
import os

/// Transfer UUID
/// peripheral - service - character
struct TransferService {
    static let serviceUUID = CBUUID(string: "E20A39F4-73F5-4BC4-A12F-17D1AD07A926")
    static let characteristicUUID = CBUUID(string: "08590F7E-DB05-467E-8757-72F6FAEB13E6")
}

class CBSession: NSObject {
    var peerDataFromCentralHandler: ((Data, CBCentral) -> Void)?
    var peerDataFromPeripheralHandler: ((Data, CBPeripheral) -> Void)?
    var peerConnectedHandler: ((CBPeripheral) -> Void)?
    var peerDisconnectedHandler: ((CBPeripheral) -> Void)?
    
    private let cbcManager: CBCentralManager // 수신용
    private let cbpManager: CBPeripheralManager // 송신용
    
    var discoveredPeripherals = [CBPeripheral]()
    var transferCharacteristics = [CBPeripheral:CBCharacteristic]() // 구독한 chracteristic
    var connectedCentrals = [CBCentral]()
    var transferCharacteristic: CBMutableCharacteristic? // my chracteristic
    
    override init() {
        cbcManager = CBCentralManager(delegate: nil, queue: .main, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        cbpManager = CBPeripheralManager(delegate: nil, queue: nil, options: [CBPeripheralManagerOptionShowPowerAlertKey: true])
        
        super.init()
        
        cbcManager.delegate = self
        cbpManager.delegate = self
    }
    
    deinit {
        invalidate()
    }
    
    func start() {
        setupPeripheral()
        retrievePeripheral()
    }
    
    func suspend() {
        cbcManager.stopScan()
        cbpManager.stopAdvertising()
    }
    
    func invalidate() {
        suspend()
    }
    
    func sendDataToCentral(data: Data, peer: CBCentral) {
        guard let characteristic = transferCharacteristic else { return }
        cbpManager.updateValue(data, for: characteristic, onSubscribedCentrals: [peer])
    }
    
    func sendDataToPeripheral(data: Data, peer: CBPeripheral) {
        guard let characteristic = transferCharacteristics[peer] else { return }
        peer.writeValue(data, for: characteristic, type: .withoutResponse)
    }
    
    private func retrievePeripheral() {
        let connectedPeripherals: [CBPeripheral] = (cbcManager.retrieveConnectedPeripherals(withServices: [TransferService.serviceUUID]))
        
        os_log("Found connected Peripherals with transfer service: %@", connectedPeripherals)
        
        if connectedPeripherals.count > 0 {
            discoveredPeripherals = connectedPeripherals
            for connectedPeripheral in connectedPeripherals {
                cbcManager.connect(connectedPeripheral, options: nil)
            }
        } else {
            cbcManager.scanForPeripherals(withServices: [TransferService.serviceUUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }
    
    private func cleanup(_ peripheral: CBPeripheral) {
        // Don't do anything if we're not connected
        guard case .connected = peripheral.state else { return }
        
        for service in (peripheral.services ?? [] as [CBService]) {
            for characteristic in (service.characteristics ?? [] as [CBCharacteristic]) {
                if characteristic.uuid == TransferService.characteristicUUID && characteristic.isNotifying {
                    // It is notifying, so unsubscribe
                    peripheral.setNotifyValue(false, for: characteristic)
                }
            }
        }
        
        // If we've gotten this far, we're connected, but we're not subscribed, so we just disconnect
        cbcManager.cancelPeripheralConnection(peripheral)
    }
    
    private func setupPeripheral() {
        
        // Build our service.
        
        // Start with the CBMutableCharacteristic.
        let transferCharacteristic = CBMutableCharacteristic(
            type: TransferService.characteristicUUID,
            properties: [.notify, .writeWithoutResponse],
            value: nil,
            permissions: [.readable, .writeable]
        )
        
        // Create a service from the characteristic.
        let transferService = CBMutableService(type: TransferService.serviceUUID, primary: true)
        
        // Add the characteristic to the service.
        transferService.characteristics = [transferCharacteristic]
        
        // And add it to the peripheral manager.
        cbpManager.add(transferService)
        
        // Save the characteristic for later.
        self.transferCharacteristic = transferCharacteristic
        cbpManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [TransferService.serviceUUID]])
    }
}

// MARK: - `CBCentralManagerDelegate`
extension CBSession: CBCentralManagerDelegate {
    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            os_log("CBManager is powered on")
            retrievePeripheral()
            return
        case .poweredOff:
            os_log("CBManager is not powered on")
            return
        case .resetting:
            os_log("CBManager is resetting")
            return
        case .unauthorized:
            os_log("Unexpected authorization")
            return
        case .unknown:
            os_log("CBManager state is unknown")
            return
        case .unsupported:
            os_log("Bluetooth is not supported on this device")
            return
        @unknown default:
            os_log("A previously unknown central manager state occurred")
            return
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
            
            os_log("Connecting to perhiperal %@", peripheral)
            cbcManager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        os_log("Failed to connect to %@. %s", peripheral, String(describing: error))
        cleanup(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        os_log("Peripheral Connected")
        
        // Make sure we get the discovery callbacks
        peripheral.delegate = self
        
        // Search only for services that match our UUID
        peripheral.discoverServices([TransferService.serviceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        os_log("Perhiperal Disconnected")
        
        if let handler = peerDisconnectedHandler {
            DispatchQueue.main.async {
                handler(peripheral)
            }
        }
        
        discoveredPeripherals = discoveredPeripherals.filter { $0 != peripheral }
    }
}

// MARK: - `CBPeripheralManagerDelegate`
extension CBSession: CBPeripheralManagerDelegate {
    internal func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            os_log("CBManager is powered on")
            setupPeripheral()
            return
        case .poweredOff:
            os_log("CBManager is not powered on")
            return
        case .resetting:
            os_log("CBManager is resetting")
            return
        case .unauthorized:
            os_log("Unexpected authorization")
            return
        case .unknown:
            os_log("CBManager state is unknown")
            return
        case .unsupported:
            os_log("Bluetooth is not supported on this device")
            return
        @unknown default:
            os_log("A previously unknown peripheral manager state occurred")
            return
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        os_log("Central subscribed to characteristic")
        
        // save central
        if !connectedCentrals.contains(central) {
            connectedCentrals.append(central)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        os_log("Central unsubscribed from characteristic")
        connectedCentrals = connectedCentrals.filter { $0 != central }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for aRequest in requests {
            guard let requestValue = aRequest.value, let handler = peerDataFromCentralHandler else {
                continue
            }
            
            DispatchQueue.main.async {
                handler(requestValue, aRequest.central)
            }
        }
    }
}

extension CBSession: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        
        for service in invalidatedServices where service.uuid == TransferService.serviceUUID {
            os_log("Transfer service is invalidated - rediscover services")
            peripheral.discoverServices([TransferService.serviceUUID])
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            os_log("Error discovering services: %s", error.localizedDescription)
            cleanup(peripheral)
            return
        }
        
        // Discover the characteristic we want...
        
        // Loop through the newly filled peripheral.services array, just in case there's more than one.
        guard let peripheralServices = peripheral.services else { return }
        for service in peripheralServices {
            peripheral.discoverCharacteristics([TransferService.characteristicUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // Deal with errors (if any).
        if let error = error {
            os_log("Error discovering characteristics: %s", error.localizedDescription)
            cleanup(peripheral)
            return
        }
        
        // Again, we loop through the array, just in case and check if it's the right one
        guard let serviceCharacteristics = service.characteristics else { return }
        for characteristic in serviceCharacteristics where characteristic.uuid == TransferService.characteristicUUID {
            // If it is, subscribe to it
            transferCharacteristics[peripheral] = characteristic
            if let handler = peerConnectedHandler {
                DispatchQueue.main.async {
                    handler(peripheral)
                }
            }
            peripheral.setNotifyValue(true, for: characteristic)
        }
        
        // Once this is complete, we just need to wait for the data to come in.
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // Deal with errors (if any)
        if let error = error {
            os_log("Error discovering characteristics: %s", error.localizedDescription)
            cleanup(peripheral)
            return
        }
        
        guard let data = characteristic.value, let handler = peerDataFromPeripheralHandler else { return }

        DispatchQueue.main.async {
            handler(data, peripheral)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        // Deal with errors (if any)
        if let error = error {
            os_log("Error changing notification state: %s", error.localizedDescription)
            return
        }
        
        // Exit if it's not the transfer characteristic
        guard characteristic.uuid == TransferService.characteristicUUID else { return }
        
        if characteristic.isNotifying {
            // Notification has started
            os_log("Notification began on %@", characteristic)
        } else {
            // Notification has stopped, so disconnect from the peripheral
            os_log("Notification stopped on %@. Disconnecting", characteristic)
            cleanup(peripheral)
        }
    }
}
