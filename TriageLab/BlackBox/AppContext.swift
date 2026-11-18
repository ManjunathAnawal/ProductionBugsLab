import Foundation

// The "ID card" that goes on every log line (Guide: WHO, WHAT, WHERE, HEALTH).
// Random install ID. No personal data.
final class AppContext: @unchecked Sendable {
    static let shared = AppContext()

    let installID: String
    let sessionID: String
    let appVersion: String
    let build: String
    let iosVersion: String

    private let lock = NSLock()
    private var screen = "launch"

    private init() {
        let key = "bb.installID"
        if let saved = UserDefaults.standard.string(forKey: key) {
            installID = saved
        } else {
            let fresh = UUID().uuidString.lowercased()
            UserDefaults.standard.set(fresh, forKey: key)
            installID = fresh
        }
        sessionID = String(UUID().uuidString.prefix(8)).lowercased()
        appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
        build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
        let v = ProcessInfo.processInfo.operatingSystemVersion
        iosVersion = "\(v.majorVersion).\(v.minorVersion).\(v.patchVersion)"
    }

    func setScreen(_ name: String) {
        lock.lock()
        screen = name
        lock.unlock()
    }

    var currentScreen: String {
        lock.lock()
        defer { lock.unlock() }
        return screen
    }

    /// Fixed fields plus live fields (memory, heat) read at the moment of logging.
    func snapshot() -> [String: String] {
        return [
            "install_id": installID,
            "session_id": sessionID,
            "app_version": appVersion,
            "build": build,
            "ios": iosVersion,
            "screen": currentScreen,
            "mem_used_mb": String(MemoryProbe.memoryUsedMB()),
            "mem_left_mb": String(MemoryProbe.memoryLeftMB()),
            "thermal": DeviceState.thermalString(),
            "uptime_s": String(Int(ProcessInfo.processInfo.systemUptime))
        ]
    }
}

enum DeviceState {
    static func thermalString() -> String {
        #if canImport(Darwin)
        switch ProcessInfo.processInfo.thermalState {
        case .nominal: return "nominal"
        case .fair: return "fair"
        case .serious: return "serious"
        case .critical: return "critical"
        @unknown default: return "unknown"
        }
        #else
        return "n/a"
        #endif
    }
}
