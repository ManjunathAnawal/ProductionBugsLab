import Foundation

// =====================================================================================
// A tiny LIVE hang detector. A background thread asks the main thread "are you alive?"
// every 0.5 s. No answer for 2 s = it logs "main_thread_hang".
// Pauses in the background (the main thread is suspended then, that is not a hang).
// =====================================================================================
final class HangDetector: @unchecked Sendable {
    static let shared = HangDetector()

    private let thresholdSeconds: Double = 2.0
    private let lock = NSLock()
    private var running = false
    private var foreground = true

    func start() {
        lock.lock()
        if running {
            lock.unlock()
            return
        }
        running = true
        lock.unlock()
        let thread = Thread(block: { [weak self] in self?.loop() })
        thread.name = "TriageLab.HangDetector"
        thread.qualityOfService = .utility
        thread.start()
    }

    func setForeground(_ value: Bool) {
        lock.lock()
        foreground = value
        lock.unlock()
    }

    private var isForeground: Bool {
        lock.lock()
        defer { lock.unlock() }
        return foreground
    }

    private func loop() {
        while true {
            if isForeground {
                let semaphore = DispatchSemaphore(value: 0)
                let sent = Date()
                DispatchQueue.main.async { semaphore.signal() }
                if semaphore.wait(timeout: .now() + thresholdSeconds) == .timedOut {
                    Log.error(.hang, "main_thread_hang", ["blocked_at_least_s": String(thresholdSeconds), "screen": AppContext.shared.currentScreen])
                    semaphore.wait()
                    Log.error(.hang, "main_thread_recovered", ["total_blocked_ms": String(Int(Date().timeIntervalSince(sent) * 1000))])
                }
            }
            Thread.sleep(forTimeInterval: 0.5)
        }
    }
}
