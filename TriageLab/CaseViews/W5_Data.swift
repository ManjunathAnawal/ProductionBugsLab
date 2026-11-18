import SwiftUI

// ---------- C21 ----------
struct C21View: View {
    @State private var note = "Patient stable. Review at 6 pm."
    @State private var loaded = "-"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Save a note. Then try Save and end app. Run again and tap Load note.")
            TextField("Note", text: $note)
                .textFieldStyle(.roundedBorder)
            Button("Save note") {
                NotesStore.save(note, crashHalfway: false)
            }
            .buttonStyle(.borderedProminent)
            Button("Save note, app ends mid-write", role: .destructive) {
                NotesStore.save(note, crashHalfway: true)
            }
            .buttonStyle(.bordered)
            Button("Load note") {
                loaded = NotesStore.load() ?? "No note found"
            }
            .buttonStyle(.bordered)
            Text("Loaded: \(loaded)")
        }
    }
}

// ---------- C22 ----------
struct C22View: View {
    @State private var lines: [String] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("A New York hospital saved three readings on 1 November 2026 (clocks went back that night).")
            Button("Show time between readings") {
                lines = DstTimeline.report()
            }
            .buttonStyle(.borderedProminent)
            ForEach(lines, id: \.self) { line in
                Text(line)
            }
        }
    }
}

// ---------- C23 ----------
struct C23View: View {
    @State private var distance = "-"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("A nurse walked about 100 metres in Bengaluru. The app recorded 6 GPS points.")
            Button("Calculate distance walked") {
                distance = String(format: "%.1f km", GpsTrack.totalKm())
            }
            .buttonStyle(.borderedProminent)
            Text("Distance walked: \(distance)")
        }
    }
}
