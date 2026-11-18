import Foundation

// Case C01. Reads vitals twice a second and keeps a chart buffer.
final class VitalsMonitor {
    private var timer: Timer?
    private var chartBuffers: [Data] = []
    var onTick: (() -> Void)?

    init() {
        LiveObjects.created("VitalsMonitor")
        Log.info(.lab, "VitalsMonitor init")
    }

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.chartBuffers.append(Data(repeating: 1, count: 200_000))
            self.onTick?()
        }
    }

    deinit {
        LiveObjects.destroyed("VitalsMonitor")
        Log.info(.lab, "VitalsMonitor deinit")
    }
}
