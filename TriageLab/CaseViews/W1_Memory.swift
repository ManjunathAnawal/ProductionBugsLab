import SwiftUI

// ---------- C01 ----------
struct C01View: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Open the monitor, go back, open it again. Do it 5 times.")
            NavigationLink("Open vitals monitor") {
                VitalsMonitorScreen()
            }
            .buttonStyle(.borderedProminent)
            MemoryMeter()
        }
    }
}

struct VitalsMonitorScreen: View {
    @State private var monitor: VitalsMonitor?
    @State private var ticks = 0

    var body: some View {
        VStack(spacing: 12) {
            Text("Watching vitals...")
            Text("Ticks: \(ticks)")
            MemoryMeter()
        }
        .navigationTitle("Vitals monitor")
        .onAppear {
            if monitor == nil {
                let created = VitalsMonitor()
                created.onTick = {
                    ticks += 1
                }
                created.start()
                monitor = created
            }
        }
    }
}

// ---------- C02 ----------
struct C02View: View {
    @State private var count = 8
    @State private var photos: [DecodedPhoto] = []
    @State private var isLoading = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Pick a number of photos. Load them. Watch the memory numbers. On a real iPhone, try 24.")
            Stepper("Photos: \(count)", value: $count, in: 1...24)
            HStack {
                Button("Load photos") {
                    isLoading = true
                    let wanted = count
                    Task.detached {
                        let loaded = PhotoLoader.loadAll(count: wanted)
                        await MainActor.run {
                            photos = loaded
                            isLoading = false
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)
                Button("Clear") {
                    photos = []
                }
                .buttonStyle(.bordered)
            }
            Text(isLoading ? "Loading..." : "Photos in memory: \(photos.count)")
            MemoryMeter()
        }
    }
}

// ---------- C03 ----------
struct C03View: View {
    @State private var refreshes = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Tap Refresh many times, like a nurse would all day. Watch the memory numbers.")
            Button("Refresh live feed") {
                FeedService.refresh()
                refreshes += 1
            }
            .buttonStyle(.borderedProminent)
            Text("Refreshed \(refreshes) times")
            MemoryMeter()
        }
    }
}
