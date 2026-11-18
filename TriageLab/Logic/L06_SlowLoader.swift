import Foundation

// Case C06. Loads the lab result. It takes 3 seconds.
final class SlowLoader {
    private(set) var result = "idle"
    var onDone: (() -> Void)?

    func load() {
        Log.info(.lab, "slow_load_start")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [unowned self] in
            self.result = "loaded"
            Log.info(.lab, "slow_load_done")
            self.onDone?()
        }
    }
}
