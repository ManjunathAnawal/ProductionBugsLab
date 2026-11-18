import Foundation

// Case C33. Records the motion sensor for the fall-detection feature.
final class SensorPoller {
    static let shared = SensorPoller()
    private var timer: Timer?
    private let url: URL

    private init() {
        let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        url = base.appendingPathComponent("sensor.csv")
    }

    func start() {
        guard timer == nil else { return }
        Log.info(.lab, "sensor_poller_start")
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            self?.poll()
        }
    }

    private func poll() {
        let line = "\(Date().timeIntervalSince1970),\(Double.random(in: -1...1))\n"
        if !FileManager.default.fileExists(atPath: url.path) {
            _ = FileManager.default.createFile(atPath: url.path, contents: nil)
        }
        guard let handle = try? FileHandle(forWritingTo: url) else { return }
        defer { try? handle.close() }
        _ = try? handle.seekToEnd()
        try? handle.write(contentsOf: Data(line.utf8))
    }
}
