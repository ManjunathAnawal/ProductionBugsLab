import Foundation

// Case C09. Collects readings from many sensors at once.
final class ReadingBuffer {
    var values: [Int] = []

    func add(_ value: Int) {
        values.append(value)
    }
}

enum ReadingCollector {
    static func collect(count: Int) -> Int {
        let buffer = ReadingBuffer()
        DispatchQueue.concurrentPerform(iterations: count) { index in
            buffer.add(index)
        }
        return buffer.values.count
    }
}
