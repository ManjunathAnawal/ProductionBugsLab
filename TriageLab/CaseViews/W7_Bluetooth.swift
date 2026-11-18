import SwiftUI

// ---------- C26 ----------
struct C26View: View {
    @State private var client: BandClientA?
    @State private var status = "Not started"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("This uses a fake Bluetooth world. No hardware is needed.")
            Button("Connect to heart band") {
                let created = BandClientA()
                created.onStatus = { text in
                    status = text
                }
                client = created
                created.start()
            }
            .buttonStyle(.borderedProminent)
            Text("Status: \(status)")
        }
    }
}

// ---------- C27 ----------
struct C27View: View {
    @State private var client: BandClientB?
    @State private var status = "Not started"
    @State private var heartRate = "-"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Connect and watch for 20 seconds. The fake band drops the link after 6 seconds.")
            Button("Connect to heart band") {
                let created = BandClientB()
                created.onStatus = { text in
                    status = text
                }
                created.onHeartRate = { bpm in
                    heartRate = String(bpm)
                }
                client = created
                created.start()
            }
            .buttonStyle(.borderedProminent)
            Text("Status: \(status)")
            Text("Heart rate: \(heartRate) bpm")
                .font(.title2.bold())
        }
    }
}
