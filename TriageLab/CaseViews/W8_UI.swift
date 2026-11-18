import SwiftUI

// ---------- C28 ----------
struct C28View: View {
    @State private var size: DynamicTypeSize = .large

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Instruction("Run Accessibility Inspector > Audit on this card. Try VoiceOver. Change the text size below.")
            Picker("Text size", selection: $size) {
                Text("Normal").tag(DynamicTypeSize.large)
                Text("Big").tag(DynamicTypeSize.xxxLarge)
                Text("Accessibility").tag(DynamicTypeSize.accessibility3)
            }
            .pickerStyle(.segmented)
            doseCard
                .dynamicTypeSize(size)
        }
    }

    private var doseCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Heparin dose")
                    .font(.headline)
                Spacer()
                Circle()
                    .fill(Color.red)
                    .frame(width: 14, height: 14)
            }
            Text("Give 5000 units every 8 hours. Check the lab values before the next dose.")
                .frame(height: 40)
            HStack(spacing: 24) {
                Button {
                } label: {
                    Color.blue
                        .frame(width: 28, height: 28)
                }
                Button {
                } label: {
                    Color.green
                        .frame(width: 28, height: 28)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.15))
    }
}

// ---------- C29 ----------
struct C29View: View {
    @State private var count = 1
    @State private var rightToLeft = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Instruction("Switch to right-to-left. Read the screen like an Arabic user would.")
            Toggle("Right-to-left layout", isOn: $rightToLeft)
            Stepper("Readings: \(count)", value: $count, in: 1...5)
            content
                .environment(\.layoutDirection, rightToLeft ? .rightToLeft : .leftToRight)
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("vitals.title")
                .font(.headline)
            Text("\(count) readings today")
            HStack {
                Image(systemName: "chevron.left")
                Text("Back to patient list")
            }
            Text("Date: \(formattedDate)")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.15))
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: Date())
    }
}
