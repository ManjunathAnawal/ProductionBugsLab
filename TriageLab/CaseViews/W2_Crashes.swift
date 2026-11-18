import SwiftUI
import Combine

// ---------- C04 ----------
struct C04View: View {
    private let service = PatientService()
    @State private var doctor = "-"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Tap each patient to see their doctor.")
            ForEach(service.patientNames()) { patient in
                Button(patient.name) {
                    doctor = service.doctorName(forPatient: patient.id)
                }
                .buttonStyle(.bordered)
            }
            Text("Doctor: \(doctor)")
        }
    }
}

// ---------- C05 ----------
struct C05View: View {
    private let pager = ReadingPager()
    @State private var page = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("There are 25 readings. Page through them.")
            ForEach(pager.page(page), id: \.self) { reading in
                Text(reading)
            }
            Button("Next page") {
                page += 1
            }
            .buttonStyle(.borderedProminent)
            Text("Page \(page + 1)")
        }
    }
}

// ---------- C06 ----------
struct C06View: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Open the result, tap Load, then go back quickly (within 3 seconds).")
            NavigationLink("Open lab result") {
                SlowResultScreen()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct SlowResultScreen: View {
    @State private var loader: SlowLoader?
    @State private var status = "idle"

    var body: some View {
        VStack(spacing: 12) {
            Text("Result: \(status)")
            Button("Load lab result (takes 3 s)") {
                let created = SlowLoader()
                created.onDone = {
                    status = "loaded"
                }
                loader = created
                created.load()
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Lab result")
    }
}

// ---------- C07 ----------
struct C07View: View {
    @State private var poorNetwork = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Turn on Poor network (the server answers after 5 s), then tap Sync.")
            Toggle("Poor network (tunnel, lift)", isOn: $poorNetwork)
            Button("Sync favorites") {
                let delay: Double = poorNetwork ? 5 : 1
                DispatchQueue.global().async {
                    SyncService().syncFavorites(simulatedNetworkDelay: delay)
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// ---------- C08 ----------
final class ScanViewModel: ObservableObject {
    @Published var status = "idle"

    func scan() {
        status = "scanning"
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1)
            self.status = "done"
        }
    }
}

struct C08View: View {
    @StateObject private var model = ScanViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Tap Scan. Watch the Xcode Issue Navigator and the console.")
            Text("Status: \(model.status)")
            Button("Scan") {
                model.scan()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// ---------- C09 ----------
struct C09View: View {
    @State private var result = "-"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Collect 20,000 readings from 20,000 sensors at once. Run it several times.")
            Button("Collect readings") {
                Task.detached {
                    let count = ReadingCollector.collect(count: 20000)
                    await MainActor.run {
                        result = "Expected 20000. Got \(count)."
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            Text(result)
        }
    }
}

// ---------- C10 ----------
struct C10View: View {
    @State private var model = BedsideModel()
    @State private var status = "idle"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Refresh from the bedside device.")
            Text("Status: \(status)")
            Button("Refresh from device") {
                BedsideRefresh.refresh(model: model) {
                    status = "updated"
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// ---------- C11 ----------
struct C11View: View {
    @State private var message = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("The server sends new settings. Tap the button. Then stop the app in Xcode and run it again.")
            Button("Download new config from server") {
                ConfigStore.downloadNewConfig()
                message = "Config saved. Now stop and run the app again."
            }
            .buttonStyle(.borderedProminent)
            Text(message)
            Instruction("To recover later: Edit Scheme > Run > Arguments > add  -resetLabConfig")
        }
    }
}
