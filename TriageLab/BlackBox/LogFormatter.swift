import Foundation

// Turns one JSON log line into one readable line.
// Example:  14:02:11.120 ERR [hang] main_thread_hang blocked_at_least_s=2.0 | scr=C12 used=88MB left=0MB
enum LogFormatter {
    private static let baseKeys: Set<String> = [
        "install_id", "session_id", "app_version", "build", "ios",
        "screen", "mem_used_mb", "mem_left_mb", "thermal", "uptime_s"
    ]

    static func pretty(_ line: String) -> String {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let entry = try? decoder.decode(LogEntry.self, from: Data(line.utf8)) else { return line }

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss.SSS"
        let time = timeFormatter.string(from: entry.ts)

        let level = entry.level == "error" ? "ERR" : "inf"
        let extras = entry.fields
            .filter { !baseKeys.contains($0.key) }
            .sorted { $0.key < $1.key }
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: " ")
        let screen = entry.fields["screen"] ?? "-"
        let used = entry.fields["mem_used_mb"] ?? "-"
        let left = entry.fields["mem_left_mb"] ?? "-"
        return "\(time) \(level) [\(entry.category)] \(entry.event) \(extras) | scr=\(screen) used=\(used)MB left=\(left)MB"
    }
}
