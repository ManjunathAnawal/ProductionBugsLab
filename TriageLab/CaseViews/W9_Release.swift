import SwiftUI
#if canImport(BackgroundTasks)
import BackgroundTasks
#endif

// ---------- C30 ----------
struct C30View: View {
    @State private var showConfirm = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Process lab. Follow the steps in the guide: build a Release archive, crash on a device, then read the crash log.")
            Button("Crash for symbolication practice", role: .destructive) {
                showConfirm = true
            }
            .buttonStyle(.bordered)
        }
        .confirmationDialog("This closes the app on purpose.", isPresented: $showConfirm, titleVisibility: .visible) {
            Button("Crash now", role: .destructive) {
                Log.error(.lab, "symbolication_practice_crash")
                LogStore.shared.flush()
                _ = SymbolPractice.startReport([])
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

// ---------- C31 ----------
struct C31View: View {
    @State private var ballast = MemoryBallast.shared.totalMB

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Use a real iPhone. Allocate memory in steps until iOS closes the app. Then reopen it and open the Black Box screen.")
            HStack {
                Button("Allocate 50 MB") {
                    MemoryBallast.shared.allocate50MB()
                    ballast = MemoryBallast.shared.totalMB
                    MemorySampler.shared.sample()
                }
                .buttonStyle(.borderedProminent)
                Button("Release all") {
                    MemoryBallast.shared.releaseAll()
                    ballast = 0
                }
                .buttonStyle(.bordered)
            }
            Text("Held by this lab: \(ballast) MB")
            MemoryMeter()
        }
    }
}

// ---------- C32 ----------
struct C32View: View {
    @State private var message = "-"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Use a real iPhone. Schedule the nightly sync. The log says it was scheduled. Then find out why it never runs.")
            Button("Schedule nightly sync") {
                NightlySync.schedule()
                message = "Scheduled (see the log)."
            }
            .buttonStyle(.borderedProminent)
            Text(message)
        }
    }
}

enum NightlySync {
    static let identifier = (Bundle.main.bundleIdentifier ?? "com.example.TriageLab") + ".nightly"

    static func schedule() {
        #if canImport(BackgroundTasks)
        let request = BGAppRefreshTaskRequest(identifier: identifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        try? BGTaskScheduler.shared.submit(request)
        #endif
        Log.info(.background, "nightly_sync_scheduled")
    }
}

// ---------- C33 ----------
struct C33View: View {
    @State private var running = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Start fall detection. Leave this screen. Watch the CPU and Disk gauges in Xcode for one minute.")
            Button("Start fall-detection sensor") {
                SensorPoller.shared.start()
                running = true
            }
            .buttonStyle(.borderedProminent)
            Text(running ? "Sensor is running" : "Sensor stopped")
        }
    }
}
