import SwiftUI

// The frame around every case: report, hints, the real bug to trigger, and tools.
struct CaseScreen: View {
    let entry: CaseEntry
    let onChange: () -> Void

    @State private var hintsShown = 0
    @State private var solved = false
    @State private var showConsole = false
    @State private var showBlackBox = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                card("Field report  (\(entry.info.severity.rawValue))") {
                    Text(entry.info.report)
                }
                card("Trigger the problem") {
                    entry.makeView()
                }
                card("Your tools") {
                    Text("Open the Console (top right) to read the black-box log. Use the Black Box screen for last-run and memory.")
                        .font(.footnote)
                    if hintsShown >= 1 {
                        ForEach(entry.info.tools, id: \.self) { tool in
                            Label(tool, systemImage: "wrench.and.screwdriver")
                                .font(.callout)
                        }
                    } else {
                        Text("Tool names are hidden. Tap Hint 1 to reveal them.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                card("Hints") {
                    ForEach(0..<min(hintsShown, entry.info.hints.count), id: \.self) { index in
                        Text("Hint \(index + 1): \(entry.info.hints[index])")
                            .font(.callout)
                    }
                    if hintsShown < entry.info.hints.count {
                        Button("Show Hint \(hintsShown + 1)") {
                            hintsShown += 1
                        }
                        .buttonStyle(.bordered)
                    }
                }
                card("Finished?") {
                    Toggle("I found the root cause", isOn: $solved)
                    Text("Check your answer in the repo docs: \(entry.info.guideRef)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("\(entry.info.id) \(entry.info.title)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Console") {
                    showConsole = true
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Black Box") {
                    showBlackBox = true
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
            AppContext.shared.setScreen(entry.info.id)
            Log.info(.lab, "case_opened", ["case": entry.info.id])
            solved = ProgressStore.isSolved(entry.info.id)
        }
        .onChange(of: solved) { _, newValue in
            ProgressStore.setSolved(entry.info.id, newValue)
            onChange()
        }
    }

    private func card<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
