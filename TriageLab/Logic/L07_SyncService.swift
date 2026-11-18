import Foundation

// Case C07. Syncs favorite patients to the cloud.
final class SyncService {
    func syncFavorites(simulatedNetworkDelay: Double) {
        Log.info(.lab, "sync_start", ["network_delay_s": String(simulatedNetworkDelay)])
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().asyncAfter(deadline: .now() + simulatedNetworkDelay) {
            Log.info(.lab, "sync_upload_done")
            group.leave()
        }
        let result = group.wait(timeout: .now() + 3)
        if result == .timedOut {
            fatalError("Sync took too long")
        }
        Log.info(.lab, "sync_ok")
    }
}
