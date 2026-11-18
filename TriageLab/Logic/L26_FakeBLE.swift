import Foundation

// A tiny fake Bluetooth world. It behaves like Core Bluetooth in the ways that matter here:
//  - The central keeps peripherals WEAKLY. The app must keep its own strong reference.
//  - Connecting has NO timeout.
//  - When the link drops, notifications are switched off. After reconnecting you must subscribe AGAIN.
protocol FakeCentralDelegate: AnyObject {
    func central(didDiscover peripheral: FakePeripheral)
    func central(didConnect peripheral: FakePeripheral)
    func central(didDisconnect peripheral: FakePeripheral)
    func peripheral(_ peripheral: FakePeripheral, didUpdateHeartRate bpm: Int)
}

final class FakePeripheral {
    let name: String
    fileprivate(set) var isConnected = false
    fileprivate(set) var isSubscribed = false

    init(name: String) {
        self.name = name
    }

    func subscribeToHeartRate() {
        isSubscribed = true
        Log.info(.ble, "ble_subscribe", ["device": name])
    }
}

final class FakeCentral {
    weak var delegate: FakeCentralDelegate?
    private let dropLinkAfter: Double?
    private var bpm = 70

    init(dropLinkAfter: Double?) {
        self.dropLinkAfter = dropLinkAfter
    }

    func scan() {
        Log.info(.ble, "ble_scan_start")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let peripheral = FakePeripheral(name: "HeartBand-7")
            Log.info(.ble, "ble_discovered", ["device": peripheral.name])
            self?.delegate?.central(didDiscover: peripheral)
        }
    }

    func connect(_ peripheral: FakePeripheral) {
        Log.info(.ble, "ble_connect_start", ["device": peripheral.name])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self, weak peripheral] in
            guard let self = self, let peripheral = peripheral else { return }
            peripheral.isConnected = true
            Log.info(.ble, "ble_connected", ["device": peripheral.name])
            self.delegate?.central(didConnect: peripheral)
            self.startNotifications(for: peripheral)
            if let drop = self.dropLinkAfter {
                DispatchQueue.main.asyncAfter(deadline: .now() + drop) { [weak self, weak peripheral] in
                    guard let self = self, let peripheral = peripheral, peripheral.isConnected else { return }
                    peripheral.isConnected = false
                    peripheral.isSubscribed = false
                    Log.error(.ble, "ble_link_lost", ["device": peripheral.name])
                    self.delegate?.central(didDisconnect: peripheral)
                }
            }
        }
    }

    private func startNotifications(for peripheral: FakePeripheral) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self, weak peripheral] in
            guard let self = self, let peripheral = peripheral, peripheral.isConnected else { return }
            if peripheral.isSubscribed {
                self.bpm += 1
                self.delegate?.peripheral(peripheral, didUpdateHeartRate: self.bpm)
            }
            self.startNotifications(for: peripheral)
        }
    }
}
