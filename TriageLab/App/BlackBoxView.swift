import SwiftUI

// The black box in one screen: last run, live numbers, MetricKit files.
struct BlackBoxView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section("How did the LAST run end?") {
                let report = AppBootstrap.lastRun
                Text(report.reason.rawValue)
                    .font(.headline)
                Text(report.explanation)
                    .font(.subheadline)
                Text("Last screen: \(report.lastScreen)")
                Text("Last memory used: \(report.lastMemoryUsedMB) MB. Last memory left: \(report.lastMemoryLeftMB) MB")
                    .font(.caption)
            }
            Section("Live numbers") {
                MemoryMeter()
                Text("Heat: \(DeviceState.thermalString())")
                    .font(.footnote)
                Text("Session: \(AppContext.shared.sessionID). Version: \(AppContext.shared.appVersion) (\(AppContext.shared.build)). iOS: \(AppContext.shared.iosVersion)")
                    .font(.footnote)
            }
            Section("Live objects (leak check, no Xcode tool needed)") {
                let live = LiveObjects.snapshot()
                if live.isEmpty {
                    Text("No tracked objects yet.")
                        .font(.footnote)
                } else {
                    ForEach(live) { item in
                        Text("\(item.name): \(item.count) alive")
                            .font(.callout.monospacedDigit())
                    }
                }
                Text("Leave a screen, then reopen this screen. A count that keeps growing means a leak.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Section("MetricKit files (real phone)") {
                let files = Outbox.files()
                if files.isEmpty {
                    Text("None yet. Run on a phone, then Xcode menu: Debug > Simulate MetricKit Payloads.")
                        .font(.footnote)
                } else {
                    ForEach(files, id: \.self) { name in
                        Text(name)
                            .font(.caption.monospaced())
                    }
                }
            }
        }
        .navigationTitle("Black Box")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .onAppear {
            AppContext.shared.setScreen("BlackBox")
        }
    }
}
