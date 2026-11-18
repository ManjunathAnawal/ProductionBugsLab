import SwiftUI

enum Ward: String, CaseIterable, Identifiable {
    case memory = "Ward 1: Memory and silent kills"
    case crashes = "Ward 2: Crashes"
    case hangs = "Ward 3: Hangs, launch, speed"
    case network = "Ward 4: Network"
    case data = "Ward 5: Data, time, location"
    case concurrency = "Ward 6: Threads and queues"
    case bluetooth = "Ward 7: Bluetooth (fake band)"
    case ui = "Ward 8: Accessibility and language"
    case release = "Ward 9: Release and tools (real phone)"

    var id: String { rawValue }
}

enum Severity: String {
    case critical = "Critical"
    case high = "High"
    case medium = "Medium"
    case low = "Low"

    var color: Color {
        switch self {
        case .critical: return .red
        case .high: return .orange
        case .medium: return .yellow
        case .low: return .gray
        }
    }
}

struct CaseInfo: Identifiable {
    let id: String
    let ward: Ward
    let title: String
    let severity: Severity
    let report: String
    let tools: [String]
    let hints: [String]
    let guideRef: String
}

struct CaseEntry: Identifiable {
    let info: CaseInfo
    let makeView: () -> AnyView

    var id: String { info.id }
}

/// Remembers which cases you marked as solved.
enum ProgressStore {
    static func isSolved(_ id: String) -> Bool {
        UserDefaults.standard.bool(forKey: "solved.\(id)")
    }

    static func setSolved(_ id: String, _ value: Bool) {
        UserDefaults.standard.set(value, forKey: "solved.\(id)")
    }

    static var solvedCount: Int {
        CaseCatalog.all.filter { isSolved($0.info.id) }.count
    }
}
