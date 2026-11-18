import Foundation
#if canImport(os)
import os
#endif

// =====================================================================================
// THE BLACK BOX LOG.
//  - Every line has an ID card (AppContext.snapshot()).
//  - Written to DISK in a small ring buffer, so it survives a crash or a memory kill.
//  - Also sent to os.Logger, so you can read it in Xcode's console and the Mac Console app.
//  - Written on a background queue. Never on the main thread.
// Use it in your investigation: Log.info(.lab, "my_event", ["key": "value"]).
// =====================================================================================
enum LogCategory: String {
    case lifecycle, lab, network, memory, hang, ble, data, metrics, background, error
}

enum LogLevel: String {
    case info, error
}

struct LogEntry: Codable {
    let ts: Date
    let level: String
    let category: String
    let event: String
    let fields: [String: String]
}

enum Log {
    static func info(_ category: LogCategory, _ event: String, _ extra: [String: String] = [:]) {
        emit(.info, category, event, extra)
    }

    static func error(_ category: LogCategory, _ event: String, _ extra: [String: String] = [:]) {
        emit(.error, category, event, extra)
    }

    private static func emit(_ level: LogLevel, _ category: LogCategory, _ event: String, _ extra: [String: String]) {
        let extraText = extra.sorted { $0.key < $1.key }.map { "\($0.key)=\($0.value)" }.joined(separator: " ")
        #if canImport(os)
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "TriageLab", category: category.rawValue)
        switch level {
        case .info: logger.info("\(event, privacy: .public) \(extraText, privacy: .public)")
        case .error: logger.error("\(event, privacy: .public) \(extraText, privacy: .public)")
        }
        #else
        print("[\(category.rawValue)] \(event) \(extraText)")
        #endif

        var fields = AppContext.shared.snapshot()
        for (key, value) in extra { fields[key] = value }
        LogStore.shared.append(LogEntry(ts: Date(), level: level.rawValue, category: category.rawValue, event: event, fields: fields))
    }
}

final class LogStore: @unchecked Sendable {
    static let shared = LogStore()

    private let queue = DispatchQueue(label: "triagelab.logstore", qos: .utility)
    private let maxBytes = 256 * 1024
    private let currentURL: URL
    private let previousURL: URL
    private let encoder: JSONEncoder

    private init() {
        let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let dir = base.appendingPathComponent("BlackBox", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        currentURL = dir.appendingPathComponent("log.current.jsonl")
        previousURL = dir.appendingPathComponent("log.previous.jsonl")
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        e.outputFormatting = [.sortedKeys]
        encoder = e
    }

    func append(_ entry: LogEntry) {
        queue.async { [self] in
            guard var data = try? encoder.encode(entry) else { return }
            data.append(0x0A)
            rotateIfNeeded(adding: data.count)
            if !FileManager.default.fileExists(atPath: currentURL.path) {
                _ = FileManager.default.createFile(atPath: currentURL.path, contents: nil)
            }
            guard let handle = try? FileHandle(forWritingTo: currentURL) else { return }
            defer { try? handle.close() }
            _ = try? handle.seekToEnd()
            try? handle.write(contentsOf: data)
        }
    }

    /// Wait until queued lines are on disk (use before a deliberate crash).
    func flush() { queue.sync { } }

    func tail(lines: Int) -> String {
        queue.sync {
            let all = readAllLines()
            return all.suffix(lines).joined(separator: "\n")
        }
    }

    func exportFileURL() -> URL? {
        queue.sync {
            let text = readAllLines().joined(separator: "\n")
            let url = FileManager.default.temporaryDirectory.appendingPathComponent("triagelab-logs.txt")
            do {
                try text.write(to: url, atomically: true, encoding: .utf8)
                return url
            } catch {
                return nil
            }
        }
    }

    func clear() {
        queue.sync {
            try? FileManager.default.removeItem(at: currentURL)
            try? FileManager.default.removeItem(at: previousURL)
        }
    }

    private func readAllLines() -> [String] {
        var lines: [String] = []
        for url in [previousURL, currentURL] {
            if let text = try? String(contentsOf: url, encoding: .utf8) {
                lines.append(contentsOf: text.split(separator: "\n").map(String.init))
            }
        }
        return lines
    }

    private func rotateIfNeeded(adding bytes: Int) {
        let size = (try? FileManager.default.attributesOfItem(atPath: currentURL.path)[.size] as? Int) ?? 0
        guard size + bytes > maxBytes else { return }
        try? FileManager.default.removeItem(at: previousURL)
        try? FileManager.default.moveItem(at: currentURL, to: previousURL)
    }
}

/// MetricKit files wait here (a real app would upload them).
enum Outbox {
    static var directory: URL {
        let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let dir = base.appendingPathComponent("BlackBox/outbox", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    static func save(kind: String, data: Data) {
        let name = "\(kind)-\(Int(Date().timeIntervalSince1970)).json"
        try? data.write(to: directory.appendingPathComponent(name), options: .atomic)
    }

    static func files() -> [String] {
        ((try? FileManager.default.contentsOfDirectory(atPath: directory.path)) ?? []).sorted()
    }
}
