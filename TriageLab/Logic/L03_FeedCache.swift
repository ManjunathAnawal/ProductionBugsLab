import Foundation

// Case C03. Caches the live vitals feed so the screen opens fast.
final class FeedCache {
    static let shared = FeedCache()
    private let lock = NSLock()
    private var store: [String: Data] = [:]

    func save(_ data: Data, for key: String) {
        lock.lock()
        store[key] = data
        lock.unlock()
    }
}

enum FeedService {
    static func refresh() {
        let key = "feed-\(Date().timeIntervalSince1970)"
        FeedCache.shared.save(Data(repeating: 7, count: 3_000_000), for: key)
        Log.info(.lab, "feed_refreshed")
    }
}
