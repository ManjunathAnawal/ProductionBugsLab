import Foundation

// Case C13. Sorts the day's readings for the summary.
enum ReadingSorter {
    static func buildSummary() -> Int {
        var total = 0
        for round in 0..<8 {
            var values = (0..<1_000_000).map { _ in Int.random(in: 0...1_000_000) }
            values.sort()
            total += values[round]
        }
        return total
    }
}
