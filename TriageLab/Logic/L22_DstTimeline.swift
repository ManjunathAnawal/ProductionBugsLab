import Foundation

// Case C22. Vitals log from a New York hospital, saved as local time text.
enum DstTimeline {
    static let readings = ["2026-11-01 01:10", "2026-11-01 01:50", "2026-11-01 01:20"]

    static func minutes(from first: String, to second: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone(identifier: "America/New_York")
        guard let a = formatter.date(from: first), let b = formatter.date(from: second) else { return 0 }
        return Int(b.timeIntervalSince(a) / 60)
    }

    static func report() -> [String] {
        var lines: [String] = []
        for index in 1..<readings.count {
            let gap = minutes(from: readings[index - 1], to: readings[index])
            lines.append("\(readings[index - 1]) -> \(readings[index]): \(gap) min")
        }
        return lines
    }
}
