import Foundation

// Case C10. Old device API with a callback. New code uses @MainActor.
@MainActor
final class BedsideModel {
    private(set) var status = "idle"

    func markUpdated() {
        status = "updated"
    }
}

enum LegacyDeviceApi {
    static func fetch(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.5)
            completion()
        }
    }
}

enum BedsideRefresh {
    @MainActor
    static func refresh(model: BedsideModel, onDone: @escaping @MainActor () -> Void) {
        LegacyDeviceApi.fetch {
            MainActor.assumeIsolated {
                model.markUpdated()
                onDone()
            }
        }
    }
}
