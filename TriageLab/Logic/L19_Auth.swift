import Foundation

// Case C19. Login session. The server rotates the refresh token on every use.
final class AuthServer {
    private let lock = NSLock()
    private var validRefresh = "r1"
    private var latestAccess = "a1"
    private var counter = 1

    func api(access: String) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return access == latestAccess
    }

    func refresh(_ token: String) -> (access: String, refresh: String)? {
        Thread.sleep(forTimeInterval: 0.2)
        lock.lock()
        defer { lock.unlock() }
        guard token == validRefresh else { return nil }
        counter += 1
        validRefresh = "r\(counter)"
        latestAccess = "a\(counter)"
        return (access: latestAccess, refresh: validRefresh)
    }
}

final class AuthClient {
    private let lock = NSLock()
    private let server = AuthServer()
    private var access = "a0"
    private var refresh = "r1"
    private(set) var loggedOut = false

    func call(_ id: Int) -> Bool {
        lock.lock()
        let currentAccess = access
        let currentRefresh = refresh
        lock.unlock()
        if server.api(access: currentAccess) { return true }
        Log.info(.network, "got_401", ["call": String(id)])
        guard let tokens = server.refresh(currentRefresh) else {
            lock.lock()
            loggedOut = true
            lock.unlock()
            Log.error(.network, "refresh_failed_logged_out", ["call": String(id)])
            return false
        }
        lock.lock()
        access = tokens.access
        refresh = tokens.refresh
        lock.unlock()
        Log.info(.network, "refresh_ok", ["call": String(id)])
        return true
    }
}

enum AuthLab {
    /// Five screens ask for data at the same moment (five real threads).
    static func fiveParallelCalls() -> (ok: Int, failed: Int, loggedOut: Bool) {
        let client = AuthClient()
        let lock = NSLock()
        let group = DispatchGroup()
        var ok = 0
        var failed = 0
        for index in 0..<5 {
            group.enter()
            let thread = Thread {
                let success = client.call(index)
                lock.lock()
                if success {
                    ok += 1
                } else {
                    failed += 1
                }
                lock.unlock()
                group.leave()
            }
            thread.start()
        }
        group.wait()
        return (ok: ok, failed: failed, loggedOut: client.loggedOut)
    }
}
