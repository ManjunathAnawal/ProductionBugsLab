import Foundation
#if canImport(MetricKit)
import MetricKit

// =====================================================================================
// APPLE METRICKIT. Daily numbers (launch, hang, memory, HOW THE APP EXITED) arrive about once
// a day. Crash diagnostics arrive on the NEXT LAUNCH (iOS 15+). Real device only.
// Try it: run on a device, then Xcode menu  Debug > Simulate MetricKit Payloads.
// Files land in Outbox. Open the "Black Box" screen to see them.
// =====================================================================================
final class MetricsReceiver: NSObject, MXMetricManagerSubscriber {
    static let shared = MetricsReceiver()

    func start() {
        MXMetricManager.shared.add(self)
        Log.info(.metrics, "metrickit_subscribed")
    }

    func didReceive(_ payloads: [MXMetricPayload]) {
        for payload in payloads {
            let json = payload.jsonRepresentation()
            Outbox.save(kind: "metrics", data: json)
            Log.info(.metrics, "metric_payload_received", ["bytes": String(json.count)])
        }
    }

    func didReceive(_ payloads: [MXDiagnosticPayload]) {
        for payload in payloads {
            let json = payload.jsonRepresentation()
            Outbox.save(kind: "diagnostics", data: json)
            Log.error(.metrics, "diagnostic_payload_received", ["bytes": String(json.count)])
        }
    }
}
#else
final class MetricsReceiver {
    static let shared = MetricsReceiver()
    func start() {}
}
#endif
