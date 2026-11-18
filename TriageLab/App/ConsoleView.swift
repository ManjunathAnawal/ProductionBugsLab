import SwiftUI

// Reads the black-box log from disk. Use the filter to follow one story.
struct ConsoleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var lines: [String] = []
    @State private var filter = ""
    @State private var exportURL: URL?

    private var shown: [String] {
        let wanted = filter.trimmingCharacters(in: .whitespaces).lowercased()
        if wanted.isEmpty { return lines }
        return lines.filter { $0.lowercased().contains(wanted) }
    }

    var body: some View {
        VStack(spacing: 8) {
            TextField("Filter (for example: hang, ble, network, ERR)", text: $filter)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(shown.enumerated()), id: \.offset) { _, line in
                        Text(line)
                            .font(.system(size: 10, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            HStack {
                Button("Refresh") {
                    reload()
                }
                Button("Clear log", role: .destructive) {
                    LogStore.shared.clear()
                    reload()
                }
                if let exportURL {
                    ShareLink("Send logs", item: exportURL)
                } else {
                    Button("Prepare export") {
                        exportURL = LogStore.shared.exportFileURL()
                    }
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle("Console")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .onAppear {
            reload()
        }
    }

    private func reload() {
        let raw = LogStore.shared.tail(lines: 300)
        lines = raw.split(separator: "\n").map { LogFormatter.pretty(String($0)) }
    }
}
