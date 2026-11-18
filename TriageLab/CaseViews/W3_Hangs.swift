import SwiftUI
import Combine

// ---------- C12 ----------
struct C12View: View {
    @State private var message = "-"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Tap Build report. The app may freeze for good. Then press Stop in Xcode.")
            Button("Build report") {
                message = ReportBuilder().buildReport()
            }
            .buttonStyle(.borderedProminent)
            Text(message)
        }
    }
}

// ---------- C13 ----------
struct C13View: View {
    @State private var message = "-"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Tap the button, then try to scroll or tap something else.")
            Button("Build daily summary") {
                let total = ReadingSorter.buildSummary()
                message = "Summary ready: \(total)"
            }
            .buttonStyle(.borderedProminent)
            Text(message)
        }
    }
}

// ---------- C14 ----------
struct C14View: View {
    @AppStorage(LaunchWork.flagKey) private var slowStart = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Turn this on. Stop the app. Run it again from Xcode and watch how long the first screen takes.")
            Toggle("Slow start-up", isOn: $slowStart)
            Instruction("To recover: Edit Scheme > Run > Arguments > add  -fixSlowLaunch")
            Instruction("On a real phone, run WITHOUT the debugger and change the delay to 25 seconds in LaunchWork.swift.")
        }
    }
}

// ---------- C15 ----------
struct C15View: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Scroll the list up and down quickly.")
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(0..<300, id: \.self) { index in
                        Text(RowCost.label(index))
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.15))
                    }
                }
            }
            .frame(height: 360)
        }
    }
}

// ---------- C16 ----------
struct RowItem: Identifiable {
    let id: UUID
    let title: String
}

struct RowExpander: View {
    let item: RowItem
    @State private var isOpen = false

    var body: some View {
        VStack(alignment: .leading) {
            Button(item.title) {
                isOpen.toggle()
            }
            if isOpen {
                Text("Details for \(item.title): heart rate 72, oxygen 98")
                    .font(.footnote)
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.15))
    }
}

struct C16View: View {
    @State private var tick = 0
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var rows: [RowItem] {
        (1...5).map { number in
            RowItem(id: UUID(), title: "Patient \(number)")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Instruction("Tap a patient to expand it. Watch what happens after one second.")
            Text("Clock tick: \(tick)")
            ForEach(rows) { row in
                RowExpander(item: row)
            }
        }
        .onReceive(timer) { _ in
            tick += 1
        }
    }
}
