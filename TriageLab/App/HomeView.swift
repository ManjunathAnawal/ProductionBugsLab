import SwiftUI

struct HomeView: View {
    @State private var tick = 0
    @State private var showConsole = false
    @State private var showBlackBox = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    LastRunBanner()
                    Text("Solved \(ProgressStore.solvedCount) of \(CaseCatalog.all.count)")
                        .font(.headline)
                    Text("Pick a case. Read the field report. Investigate with Xcode. Use hints only when stuck.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                ForEach(Ward.allCases) { ward in
                    Section(ward.rawValue) {
                        ForEach(CaseCatalog.all.filter { $0.info.ward == ward }) { entry in
                            NavigationLink(value: entry.info.id) {
                                CaseRow(info: entry.info, refresh: tick)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Triage Lab")
            .navigationDestination(for: String.self) { caseID in
                if let entry = CaseCatalog.all.first(where: { $0.info.id == caseID }) {
                    CaseScreen(entry: entry) {
                        tick += 1
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Black Box") {
                        showBlackBox = true
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Console") {
                        showConsole = true
                    }
                }
            }
            .sheet(isPresented: $showConsole) {
                NavigationStack {
                    ConsoleView()
                }
            }
            .sheet(isPresented: $showBlackBox) {
                NavigationStack {
                    BlackBoxView()
                }
            }
            .onAppear {
                AppContext.shared.setScreen("Home")
                AppBootstrap.markFirstScreen()
            }
        }
    }
}

struct CaseRow: View {
    let info: CaseInfo
    let refresh: Int

    var body: some View {
        HStack {
            Text(info.id)
                .font(.caption.monospaced().bold())
                .padding(4)
                .background(info.severity.color.opacity(0.35))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            Text(info.title)
            Spacer()
            if ProgressStore.isSolved(info.id) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        }
    }
}

struct LastRunBanner: View {
    var body: some View {
        let report = AppBootstrap.lastRun
        VStack(alignment: .leading, spacing: 4) {
            Text("Last run ended: \(report.reason.rawValue)")
                .font(.subheadline.bold())
            Text(report.explanation)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
