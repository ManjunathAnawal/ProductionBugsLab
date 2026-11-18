import SwiftUI

// Small helper views used by many cases.
struct MemoryMeter: View {
    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { _ in
            let left = MemoryProbe.memoryLeftMB()
            VStack(alignment: .leading, spacing: 2) {
                Text("Memory used: \(MemoryProbe.memoryUsedMB()) MB")
                Text(left > 0 ? "Memory left: \(left) MB" : "Memory left: n/a on Simulator")
            }
            .font(.footnote.monospacedDigit())
        }
    }
}

struct Instruction: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.callout)
            .foregroundStyle(.secondary)
    }
}
