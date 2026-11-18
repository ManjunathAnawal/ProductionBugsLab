import Foundation

// A simple leak check that needs NO Xcode tool.
// Call LiveObjects.created("Name") in init and LiveObjects.destroyed("Name") in deinit.
// If the count keeps going up when you leave a screen, objects are leaking.
struct LiveCount: Identifiable {
    let name: String
    let count: Int

    var id: String { name }
}

enum LiveObjects {
    private static let lock = NSLock()
    private static var counts: [String: Int] = [:]

    static func created(_ name: String) {
        lock.lock()
        counts[name, default: 0] += 1
        lock.unlock()
    }

    static func destroyed(_ name: String) {
        lock.lock()
        counts[name, default: 0] -= 1
        lock.unlock()
    }

    static func snapshot() -> [LiveCount] {
        lock.lock()
        defer { lock.unlock() }
        return counts
            .map { LiveCount(name: $0.key, count: $0.value) }
            .sorted { $0.name < $1.name }
    }
}
