import Foundation

// =====================================================================================
// "HOW DID THE LAST RUN END?"  iOS gives NO crash report when it kills your app for memory.
// So on every launch we read what we saved last time and work out the reason.
//
//   unknown_in_foreground = was in the foreground, no clean exit. Memory kill, watchdog,
//                           force-quit, or a Swift crash that no tool caught.
// =====================================================================================
enum LastRunEnd: String {
    case firstLaunch = "first_launch"
    case cleanExit = "clean_exit"
    case appOrOSUpdated = "app_or_os_updated"
    case reboot = "reboot"
    case killedInBackground = "killed_in_background"
    case unknownInForeground = "unknown_in_foreground"
}

struct LastRunReport {
    let reason: LastRunEnd
    let lastScreen: String
    let lastMemoryLeftMB: Int
    let lastMemoryUsedMB: Int

    static let firstLaunch = LastRunReport(reason: .firstLaunch, lastScreen: "-", lastMemoryLeftMB: 0, lastMemoryUsedMB: 0)

    var explanation: String {
        switch reason {
        case .firstLaunch: return "First launch. Nothing to compare."
        case .cleanExit: return "Closed normally."
        case .appOrOSUpdated: return "App or iOS was updated. Ignore."
        case .reboot: return "The phone restarted. Ignore."
        case .killedInBackground: return "iOS closed it in the background. Normal."
        case .unknownInForeground: return "Was in the FOREGROUND and just ended. Memory kill? Watchdog? Crash? Force-quit?"
        }
    }
}

enum RunTracker {
    private static let d = UserDefaults.standard

    private enum K {
        static let cleanExit = "run.cleanExit"
        static let appVersion = "run.appVersion"
        static let osVersion = "run.osVersion"
        static let lastState = "run.lastState"
        static let screen = "run.screen"
        static let memLeft = "run.memLeft"
        static let memUsed = "run.memUsed"
        static let uptime = "run.uptime"
    }

    /// Call once at every launch.
    static func onLaunch(appVersion: String, osVersion: String) -> LastRunReport {
        let hadPreviousRun = d.object(forKey: K.appVersion) != nil
        let reason: LastRunEnd
        if !hadPreviousRun {
            reason = .firstLaunch
        } else if d.bool(forKey: K.cleanExit) {
            reason = .cleanExit
        } else if d.string(forKey: K.appVersion) != appVersion || d.string(forKey: K.osVersion) != osVersion {
            reason = .appOrOSUpdated
        } else if ProcessInfo.processInfo.systemUptime < d.double(forKey: K.uptime) {
            reason = .reboot                       // uptime went DOWN, so the phone restarted
        } else if d.string(forKey: K.lastState) == "background" {
            reason = .killedInBackground
        } else {
            reason = .unknownInForeground
        }
        let report = LastRunReport(
            reason: reason,
            lastScreen: d.string(forKey: K.screen) ?? "-",
            lastMemoryLeftMB: d.integer(forKey: K.memLeft),
            lastMemoryUsedMB: d.integer(forKey: K.memUsed))
        d.set(false, forKey: K.cleanExit)
        d.set(appVersion, forKey: K.appVersion)
        d.set(osVersion, forKey: K.osVersion)
        d.set("foreground", forKey: K.lastState)
        return report
    }

    /// Called every few seconds. The LAST values before a silent kill tell you why.
    static func heartbeat(screen: String, memoryLeftMB: Int, memoryUsedMB: Int) {
        d.set(screen, forKey: K.screen)
        d.set(memoryLeftMB, forKey: K.memLeft)
        d.set(memoryUsedMB, forKey: K.memUsed)
        d.set(ProcessInfo.processInfo.systemUptime, forKey: K.uptime)
    }

    static func onEnterBackground() { d.set("background", forKey: K.lastState) }
    static func onEnterForeground() { d.set("foreground", forKey: K.lastState) }
    static func onTerminate() { d.set(true, forKey: K.cleanExit) }
}
