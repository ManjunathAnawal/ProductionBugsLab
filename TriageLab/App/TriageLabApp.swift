import SwiftUI

@main
struct TriageLabApp: App {
    @Environment(\.scenePhase) private var scenePhase

    init() {
        MainActor.assumeIsolated {
            AppBootstrap.start()
        }
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .onChange(of: scenePhase) { _, newPhase in
                    AppBootstrap.handleScenePhase(newPhase)
                }
        }
    }
}
