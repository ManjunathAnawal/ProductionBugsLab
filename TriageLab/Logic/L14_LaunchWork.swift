import Foundation

// Case C14. Start-up work.
enum LaunchWork {
    static let blockSeconds: Double = 10
    static let flagKey = "lab.slowLaunch"

    static var enabled: Bool {
        UserDefaults.standard.bool(forKey: flagKey)
    }

    static func runIfEnabled() {
        guard enabled else { return }
        Log.info(.lifecycle, "startup_config_fetch_begin")
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().asyncAfter(deadline: .now() + blockSeconds) {
            semaphore.signal()
        }
        semaphore.wait()
        Log.info(.lifecycle, "startup_config_fetch_end")
    }
}
