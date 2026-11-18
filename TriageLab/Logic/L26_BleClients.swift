import Foundation

// Case C26. Connects to a heart band.
final class BandClientA: FakeCentralDelegate {
    private let central = FakeCentral(dropLinkAfter: nil)
    var onStatus: ((String) -> Void)?

    func start() {
        central.delegate = self
        onStatus?("Scanning...")
        central.scan()
    }

    func central(didDiscover peripheral: FakePeripheral) {
        onStatus?("Found \(peripheral.name). Connecting...")
        central.connect(peripheral)
    }

    func central(didConnect peripheral: FakePeripheral) {
        onStatus?("Connected to \(peripheral.name)")
    }

    func central(didDisconnect peripheral: FakePeripheral) {
        onStatus?("Disconnected")
    }

    func peripheral(_ peripheral: FakePeripheral, didUpdateHeartRate bpm: Int) {}
}

// Case C27. Shows the heart rate from the band.
final class BandClientB: FakeCentralDelegate {
    private let central = FakeCentral(dropLinkAfter: 6)
    private var band: FakePeripheral?
    private var hasSubscribed = false
    var onStatus: ((String) -> Void)?
    var onHeartRate: ((Int) -> Void)?

    func start() {
        central.delegate = self
        onStatus?("Scanning...")
        central.scan()
    }

    func central(didDiscover peripheral: FakePeripheral) {
        band = peripheral
        central.connect(peripheral)
    }

    func central(didConnect peripheral: FakePeripheral) {
        onStatus?("Connected")
        if !hasSubscribed {
            peripheral.subscribeToHeartRate()
            hasSubscribed = true
        }
    }

    func central(didDisconnect peripheral: FakePeripheral) {
        onStatus?("Reconnecting...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            central.connect(peripheral)
        }
    }

    func peripheral(_ peripheral: FakePeripheral, didUpdateHeartRate bpm: Int) {
        onHeartRate?(bpm)
    }
}
