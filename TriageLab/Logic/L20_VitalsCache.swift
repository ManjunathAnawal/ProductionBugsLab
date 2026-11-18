import Foundation

// Case C20. Saved vitals for the dashboard. The app was updated last week.
struct VitalsV2: Codable {
    let heartRate: Int
}

enum VitalsCache {
    static var url: URL {
        let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("vitals-cache.json")
    }

    /// Pretends this file was written by the OLD app version.
    static func installOldVersionFile() {
        try? Data(#"{"bpm":72}"#.utf8).write(to: url, options: .atomic)
    }

    static func loadHeartRate() -> Int {
        guard let data = try? Data(contentsOf: url) else { return 0 }
        let vitals = try? JSONDecoder().decode(VitalsV2.self, from: data)
        return vitals?.heartRate ?? 0
    }
}
