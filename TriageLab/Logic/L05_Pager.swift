import Foundation

// Case C05. Shows readings 10 at a time.
final class ReadingPager {
    private let readings = (1...25).map { "Reading \($0)" }
    private let pageSize = 10

    func page(_ number: Int) -> [String] {
        let start = number * pageSize
        let end = start + pageSize
        return Array(readings[start..<end])
    }
}
