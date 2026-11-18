import Foundation

// Case C11. App settings that the server can change.
struct LabConfig: Codable {
    var refreshSeconds: Int
    var theme: String

    static let defaults = LabConfig(refreshSeconds: 30, theme: "light")
}

enum ConfigStore {
    static var url: URL {
        let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("lab-config.json")
    }

    static func load() -> LabConfig {
        guard FileManager.default.fileExists(atPath: url.path) else { return .defaults }
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode(LabConfig.self, from: data)
    }

    static func downloadNewConfig() {
        let body = #"{"refreshSeconds":"fast","theme":"light"}"#
        try? Data(body.utf8).write(to: url, options: .atomic)
        Log.info(.lab, "config_downloaded", ["bytes": String(body.utf8.count)])
    }

    /// Used by the launch argument -resetLabConfig so you can recover and keep practicing.
    static func resetFile() {
        try? FileManager.default.removeItem(at: url)
    }
}
