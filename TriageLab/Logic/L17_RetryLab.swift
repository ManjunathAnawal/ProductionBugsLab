import Foundation

// Case C17. Many phones call the server while it is down.
final class OutageServer {
    private let lock = NSLock()
    private(set) var requests = 0

    func call() -> Int {
        lock.lock()
        requests += 1
        lock.unlock()
        return 503
    }
}

enum PhoneClient {
    static func fetchWithRetry(server: OutageServer) {
        for _ in 0..<10 {
            if server.call() == 200 { return }
        }
    }
}

enum RetryLab {
    static func simulate(phones: Int) -> Int {
        let server = OutageServer()
        DispatchQueue.concurrentPerform(iterations: phones) { _ in
            PhoneClient.fetchWithRetry(server: server)
        }
        Log.info(.network, "retry_lab", ["phones": String(phones), "server_requests": String(server.requests)])
        return server.requests
    }
}
