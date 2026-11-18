import SwiftUI
import UIKit

// Start-up order. Everything here is the "black box" from the guide.
@MainActor
enum AppBootstrap {
    static let launchUptime = ProcessInfo.processInfo.systemUptime
    private(set) static var lastRun = LastRunReport.firstLaunch
    private static var started = false
    private static var markedFirstScreen = false

    static func start() {
        guard !started else { return }
        started = true

        // Recovery switches for the crash loop and slow launch cases.
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains("-resetLabConfig") {
            ConfigStore.resetFile()
        }
        if arguments.contains("-fixSlowLaunch") {
            UserDefaults.standard.set(false, forKey: LaunchWork.flagKey)
        }

        // How did the last run end?
        lastRun = RunTracker.onLaunch(
            appVersion: AppContext.shared.appVersion,
            osVersion: AppContext.shared.iosVersion)
        Log.info(.lifecycle, "launch", [
            "last_run_end": lastRun.reason.rawValue,
            "last_screen": lastRun.lastScreen,
            "last_mem_left_mb": String(lastRun.lastMemoryLeftMB),
            "last_mem_used_mb": String(lastRun.lastMemoryUsedMB)
        ])
        if lastRun.reason == .unknownInForeground {
            Log.error(.lifecycle, "silent_end_suspected")
        }

        MetricsReceiver.shared.start()
        MemorySampler.shared.start()
        HangDetector.shared.start()
        registerObservers()

        // Case C14: work that runs BEFORE the first screen.
        LaunchWork.runIfEnabled()

        // Case C11: settings are read at launch.
        let config = ConfigStore.load()
        Log.info(.lifecycle, "config_loaded", ["refresh_s": String(config.refreshSeconds)])
    }

    static func handleScenePhase(_ phase: ScenePhase) {
        switch phase {
        case .active:
            RunTracker.onEnterForeground()
            HangDetector.shared.setForeground(true)
            Log.info(.lifecycle, "foreground")
        case .inactive:
            Log.info(.lifecycle, "inactive")
        case .background:
            RunTracker.onEnterBackground()
            HangDetector.shared.setForeground(false)
            Log.info(.lifecycle, "background")
        @unknown default:
            break
        }
    }

    static func markFirstScreen() {
        guard !markedFirstScreen else { return }
        markedFirstScreen = true
        let ms = Int((ProcessInfo.processInfo.systemUptime - launchUptime) * 1000)
        Log.info(.lifecycle, "time_to_first_screen", ["ms": String(ms)])
    }

    private static func registerObservers() {
        let center = NotificationCenter.default
        center.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: .main) { _ in
            Log.error(.memory, "memory_warning")
        }
        center.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { _ in
            RunTracker.onTerminate()
            Log.info(.lifecycle, "will_terminate")
        }
    }
}
