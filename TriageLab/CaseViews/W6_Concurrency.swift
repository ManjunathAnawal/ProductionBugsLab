import SwiftUI

// ---------- C24 ----------
struct C24View: View {
    @State private var result = "-"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Balance is 100. Each test costs 80. Two nurses tap Buy at the same time.")
            Button("Buy two tests at once") {
                Task {
                    let outcome = await WalletLab.buyTwoAtOnce()
                    result = "Results: \(outcome.results). Balance: \(outcome.balance)"
                }
            }
            .buttonStyle(.borderedProminent)
            Text(result)
        }
    }
}

// ---------- C25 ----------
struct C25View: View {
    @State private var queue: OperationQueue?
    @State private var lines: [String] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Instruction("Upload 5 scans one after another. Wait 10 seconds.")
            Button("Upload 5 scans") {
                lines = []
                queue = UploadLab.start { index, success in
                    DispatchQueue.main.async {
                        lines.append("Scan \(index): \(success ? "uploaded" : "failed")")
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            ForEach(lines, id: \.self) { line in
                Text(line)
            }
        }
    }
}
