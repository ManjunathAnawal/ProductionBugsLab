import SwiftUI

// Generated from the guide data. One entry per case. The bug lives in the case's own files.
enum CaseCatalog {
    static let all: [CaseEntry] = [
        CaseEntry(
            info: CaseInfo(
                id: "C01",
                ward: .memory,
                title: "Memory climbs on the vitals screen",
                severity: .high,
                report: "Nurses say the app gets slower and warmer each time they check vitals. Memory keeps climbing.",
                tools: ["Xcode Memory gauge", "Debug Memory Graph button", "Instruments: Allocations or Leaks", "Black Box > Live objects (works without any tool)", "Console log (init / deinit lines)"],
                hints: ["Use the Memory gauge, then press the Debug Memory Graph button (three connected circles) in the debug bar.", "In the memory graph filter for VitalsMonitor. Count them. In the Console search the log for 'VitalsMonitor'.", "Something keeps each monitor alive after you leave the screen. Look at the timer and what its closure captures."],
                guideRef: "docs/cases/C01.md"
            ),
            makeView: { AnyView(C01View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C02",
                ward: .memory,
                title: "App closes on the photo gallery",
                severity: .critical,
                report: "Nurses on older iPhones say the app closes by itself when they open the scan gallery. Our crash tool shows nothing.",
                tools: ["Xcode Memory gauge", "Instruments: Allocations + VM Tracker", "Black Box: last-run report", "Xcode Organizer > Terminations (real apps)"],
                hints: ["There is no crash report. Think: who else can close an app? Check the Black Box screen after the app closes.", "Look at how many photos are held in memory at once and how big each one is (4032 x 3024 pixels, 4 bytes per pixel).", "Every photo is decoded at full size and all are kept in an array. 24 photos is more than 1 GB."],
                guideRef: "docs/cases/C02.md"
            ),
            makeView: { AnyView(C02View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C03",
                ward: .memory,
                title: "Memory grows all day on the live feed",
                severity: .high,
                report: "Charge nurses keep the live feed open all shift. After a few hours the app closes.",
                tools: ["Xcode Memory gauge", "Instruments: Allocations (Mark Generation)", "VM Tracker"],
                hints: ["The curve looks like a staircase. Something grows with every refresh and never shrinks.", "In Allocations press Mark Generation, tap Refresh 5 times, press it again. See what survived.", "Look at how FeedCache stores items and what key it uses."],
                guideRef: "docs/cases/C03.md"
            ),
            makeView: { AnyView(C03View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C04",
                ward: .crashes,
                title: "Crash opening one patient",
                severity: .high,
                report: "Crash when a nurse opens patient C. Das. Other patients are fine.",
                tools: ["Xcode debugger stop + Debug Navigator stack", "Exception breakpoint", "Console"],
                hints: ["Run from Xcode. It stops on a line. Read the stack in the Debug Navigator.", "Compare the data of patient 3 with patients 1 and 2 (PatientService has the JSON).", "A field is missing for one patient and the code uses `!`."],
                guideRef: "docs/cases/C04.md"
            ),
            makeView: { AnyView(C04View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C05",
                ward: .crashes,
                title: "Crash on the third page",
                severity: .medium,
                report: "Crash when a nurse taps Next page for the third time.",
                tools: ["Xcode stack trace", "Breakpoint on `page(_:)`", "Console"],
                hints: ["Read the crashed line and the error message.", "Print `start` and `end` for each page. There are 25 readings.", "Page 3 asks for items 20 to 29. The list stops at 24."],
                guideRef: "docs/cases/C05.md"
            ),
            makeView: { AnyView(C05View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C06",
                ward: .crashes,
                title: "Crash after going back quickly",
                severity: .high,
                report: "Crash a few seconds after a nurse opens the lab result and goes back.",
                tools: ["Xcode stack trace", "Console message", "Log (slow_load_start / slow_load_done)"],
                hints: ["Read the error message in the console. It names the problem.", "Which object is gone when the closure runs? Look at the capture list.", "`[unowned self]` plus a delayed closure plus a screen that closed."],
                guideRef: "docs/cases/C06.md"
            ),
            makeView: { AnyView(C06View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C07",
                ward: .crashes,
                title: "Crash when syncing in a lift",
                severity: .high,
                report: "Nurses report a crash when syncing favorites in lifts and tunnels.",
                tools: ["Xcode stack trace (which thread?)", "Console log", "Network Link Conditioner (idea)"],
                hints: ["Check which thread crashed. Read the message.", "How long does the code wait? How long can a poor network take?", "The code treats a slow network as a bug."],
                guideRef: "docs/cases/C07.md"
            ),
            makeView: { AnyView(C07View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C08",
                ward: .crashes,
                title: "Purple warning: publishing from background",
                severity: .low,
                report: "Developers see a purple warning in Xcode. Sometimes the screen does not update.",
                tools: ["Xcode Issue Navigator (Runtime Issues)", "Main Thread Checker (Edit Scheme > Run > Diagnostics)", "Console"],
                hints: ["Open the Issue Navigator. Look for a purple item.", "Which thread changes `status`?", "`@Published` must change on the main thread."],
                guideRef: "docs/cases/C08.md"
            ),
            makeView: { AnyView(C08View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C09",
                ward: .crashes,
                title: "Wrong count, sometimes a crash",
                severity: .high,
                report: "The reading count is sometimes lower than expected. Rarely the app crashes with a malloc error.",
                tools: ["Thread Sanitizer (Edit Scheme > Run > Diagnostics)", "Console"],
                hints: ["Turn on Thread Sanitizer and run again.", "How many threads add to the same array?", "An array is not safe for many writers."],
                guideRef: "docs/cases/C09.md"
            ),
            makeView: { AnyView(C09View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C10",
                ward: .crashes,
                title: "Crash: incorrect actor executor",
                severity: .high,
                report: "Crash after refreshing from the bedside device. Message mentions an actor executor.",
                tools: ["Xcode stack trace", "Console message"],
                hints: ["Read the message. It says which executor was expected.", "Which thread runs the callback of the old device API?", "`MainActor.assumeIsolated` does not move you to the main thread. It only checks."],
                guideRef: "docs/cases/C10.md"
            ),
            makeView: { AnyView(C10View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C11",
                ward: .crashes,
                title: "Crash at every launch after a download",
                severity: .critical,
                report: "After tapping 'Download new config', the app crashes at every launch. Reinstall fixes it.",
                tools: ["Xcode stack trace at launch", "Console", "Window > Devices and Simulators > Download Container"],
                hints: ["The crash is before any screen. Read the stack and the message.", "What does the app read at launch? Find the file. Download the container and open it.", "The settings file has a wrong value type and the code uses `try!`."],
                guideRef: "docs/cases/C11.md"
            ),
            makeView: { AnyView(C11View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C12",
                ward: .hangs,
                title: "App freezes forever",
                severity: .critical,
                report: "The app freezes completely when building the daily report. No crash.",
                tools: ["Xcode Pause + Debug Navigator main thread stack", "Console (main_thread_hang)", "Instruments: Hangs"],
                hints: ["Pause the app and read what the main thread is doing.", "Is the CPU high or low? A frozen app with low CPU is waiting.", "The main thread waits for a result. The worker needs the main thread to deliver it."],
                guideRef: "docs/cases/C12.md"
            ),
            makeView: { AnyView(C12View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C13",
                ward: .hangs,
                title: "Freeze for a few seconds, CPU high",
                severity: .medium,
                report: "The app freezes for several seconds when building the summary. The phone gets warm.",
                tools: ["Xcode CPU gauge", "Instruments: Time Profiler", "Console (main_thread_hang)"],
                hints: ["Is the CPU high or low? Compare with the previous case.", "Profile with Time Profiler (Product > Profile). Look at the heaviest function.", "A lot of sorting runs on the main thread."],
                guideRef: "docs/cases/C13.md"
            ),
            makeView: { AnyView(C13View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C14",
                ward: .hangs,
                title: "First screen takes 10 seconds",
                severity: .critical,
                report: "After enabling Slow start-up, the first screen takes more than 10 seconds. On real phones iOS closes the app at launch.",
                tools: ["Console (startup_config_fetch_begin / end, time_to_first_screen)", "Xcode Pause during launch", "Instruments: App Launch"],
                hints: ["Read the launch lines in the Console. Where is the time lost?", "Pause during the freeze. What is the main thread doing?", "Something waits for a 'server' before the first screen."],
                guideRef: "docs/cases/C14.md"
            ),
            makeView: { AnyView(C14View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C15",
                ward: .hangs,
                title: "List stutters while scrolling",
                severity: .medium,
                report: "The vitals list stutters when scrolling fast.",
                tools: ["Xcode CPU gauge", "Instruments: Time Profiler / Animation Hitches"],
                hints: ["Check the CPU gauge while scrolling.", "Profile it. What function is called for every row?", "Each row does a lot of work while the view is drawn."],
                guideRef: "docs/cases/C15.md"
            ),
            makeView: { AnyView(C15View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C16",
                ward: .hangs,
                title: "Expanded rows close by themselves",
                severity: .medium,
                report: "Rows that a nurse expands close again after one second.",
                tools: ["`let _ = Self._printChanges()` in body", "Instruments: SwiftUI", "Breakpoint in the `rows` property"],
                hints: ["The clock tick changes every second. What does that re-run?", "Print the ids of the rows on each tick.", "The row ids are random on every render."],
                guideRef: "docs/cases/C16.md"
            ),
            makeView: { AnyView(C16View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C17",
                ward: .network,
                title: "Outage: server flooded by retries",
                severity: .critical,
                report: "During a server outage, the backend received 10 times more requests than normal.",
                tools: ["Console (retry_lab)", "Code reading: PhoneClient", "Network instrument (idea)"],
                hints: ["Compare phones to requests. What is the ratio?", "Read what a phone does after an error.", "Retries are instant, unlimited by wait time, and cover every error."],
                guideRef: "docs/cases/C17.md"
            ),
            makeView: { AnyView(C17View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C18",
                ward: .network,
                title: "Patient got two refill orders",
                severity: .critical,
                report: "A patient received two refills after one nervous double tap.",
                tools: ["Console (order_submit, order_created)", "Breakpoint in submit"],
                hints: ["Count `order_submit` and `order_created` lines.", "Is anything stopping the second tap?", "The server cannot tell a retry from a new order."],
                guideRef: "docs/cases/C18.md"
            ),
            makeView: { AnyView(C18View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C19",
                ward: .network,
                title: "Users logged out at random",
                severity: .high,
                report: "Users are logged out randomly after the app wakes up.",
                tools: ["Console (got_401, refresh_ok, refresh_failed_logged_out)", "Timeline reading"],
                hints: ["Filter the Console for `refresh`. Count the lines.", "How many refresh calls happen for 5 failed requests?", "The server rotates the refresh token on every use."],
                guideRef: "docs/cases/C19.md"
            ),
            makeView: { AnyView(C19View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C20",
                ward: .network,
                title: "Dashboard shows heart rate 0 after update",
                severity: .high,
                report: "After the app update some users see heart rate 0 on the dashboard.",
                tools: ["Breakpoint in loadHeartRate", "po / print of the decode error", "Search code for `try?`"],
                hints: ["No crash and no log. Where can an error disappear?", "Step through `loadHeartRate` with a breakpoint.", "The old file uses another field name and errors are swallowed."],
                guideRef: "docs/cases/C20.md"
            ),
            makeView: { AnyView(C20View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C21",
                ward: .data,
                title: "Nurse note vanishes after app ends",
                severity: .high,
                report: "A nurse's note disappeared after the app ended during a save.",
                tools: ["Console (note_save_start without note_save_end)", "Devices and Simulators > Download Container", "Breakpoint in load()"],
                hints: ["Compare `note_save_start` and `note_save_end` in the log.", "Download the container and open Documents/note.json.", "The file was written in two parts, not in one safe step."],
                guideRef: "docs/cases/C21.md"
            ),
            makeView: { AnyView(C21View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C22",
                ward: .data,
                title: "Negative minutes around the clock change",
                severity: .medium,
                report: "A New York hospital sees '-30 min' between readings on 1 November.",
                tools: ["Print the parsed dates", "Reasoning about time zones", "Playground / breakpoint"],
                hints: ["Print the real dates (with time zone) for each text.", "On 1 November 2026 the clocks in New York go back one hour at 2:00.", "Local time text without an offset is ambiguous."],
                guideRef: "docs/cases/C22.md"
            ),
            makeView: { AnyView(C22View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C23",
                ward: .data,
                title: "Walk distance shows thousands of km",
                severity: .medium,
                report: "A nurse walked about 100 metres. The app says thousands of kilometres.",
                tools: ["Print each GPS fix", "Breakpoint in totalKm", "Reasoning: Fresh, Accurate, Frugal"],
                hints: ["Print each fix: accuracy and age.", "Which point is far away from the others?", "Old, weak and invalid points are used."],
                guideRef: "docs/cases/C23.md"
            ),
            makeView: { AnyView(C23View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C24",
                ward: .concurrency,
                title: "Balance went negative",
                severity: .high,
                report: "After two quick purchases the balance is negative.",
                tools: ["Breakpoint inside buy()", "Console (wallet_lab)", "Reading: where is the await?"],
                hints: ["Both purchases returned true. Why?", "Look for an `await` between the check and the change.", "Actors are reentrant at every await."],
                guideRef: "docs/cases/C24.md"
            ),
            makeView: { AnyView(C24View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C25",
                ward: .concurrency,
                title: "Uploads stop at scan 3",
                severity: .high,
                report: "Uploads stop at scan 3. Scans 4 and 5 never upload.",
                tools: ["Xcode Pause + Debug Navigator", "Console (upload_failed, upload_ok)", "Breakpoint in UploadOperation.main"],
                hints: ["Read the order of lines in the console.", "The queue runs one operation at a time. What makes an operation 'done'?", "The failure path returns without finishing."],
                guideRef: "docs/cases/C25.md"
            ),
            makeView: { AnyView(C25View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C26",
                ward: .bluetooth,
                title: "Band found but never connects",
                severity: .high,
                report: "The heart band is found but never connects. No error is shown.",
                tools: ["Console filter: ble", "Breakpoint in didConnect (never hit)", "Debug Memory Graph (is the peripheral alive?)"],
                hints: ["Filter the Console for `ble`. What step is missing?", "Who keeps a strong reference to the peripheral?", "Core Bluetooth keeps peripherals weakly. The app must keep them."],
                guideRef: "docs/cases/C26.md"
            ),
            makeView: { AnyView(C26View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C27",
                ward: .bluetooth,
                title: "Heart rate frozen but 'Connected'",
                severity: .critical,
                report: "The heart rate on screen froze at one number while the status still says Connected.",
                tools: ["Console filter: ble", "Breakpoint in didConnect", "Reading: what resets on disconnect?"],
                hints: ["Find `ble_link_lost` and what follows it.", "After reconnect, do notifications come back? Look for `ble_subscribe`.", "Subscriptions reset when the link drops. The app subscribes only once."],
                guideRef: "docs/cases/C27.md"
            ),
            makeView: { AnyView(C27View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C28",
                ward: .ui,
                title: "Accessibility audit fails",
                severity: .medium,
                report: "A hospital accessibility audit failed on the dose card.",
                tools: ["Accessibility Inspector > Audit", "VoiceOver", "Dynamic Type size picker in the case"],
                hints: ["Run the Audit and read every warning.", "Increase the text size. What gets cut off?", "Unlabeled buttons, a fixed height, status shown only by color, small touch targets."],
                guideRef: "docs/cases/C28.md"
            ),
            makeView: { AnyView(C28View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C29",
                ward: .ui,
                title: "Wrong arrows and raw keys in Arabic",
                severity: .low,
                report: "Arabic and Hebrew testers say arrows point the wrong way and some text looks like a code.",
                tools: ["Edit Scheme > Run > Options > App Language: Right to Left Pseudolanguage and Double-Length Pseudolanguage", "Xcode Previews"],
                hints: ["Switch the layout direction and compare.", "Which symbol does not flip? Which text is not translated?", "Hard-coded left arrow, missing string key, no plural rule, fixed date format."],
                guideRef: "docs/cases/C29.md"
            ),
            makeView: { AnyView(C29View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C30",
                ward: .release,
                title: "Crash log with only hex addresses",
                severity: .medium,
                report: "A TestFlight crash shows only hex addresses. Nobody can read it.",
                tools: ["Window > Devices and Simulators > View Device Logs", "dwarfdump --uuid", "atos", "Xcode Organizer > Crashes"],
                hints: ["Find the 'Binary Images' section in the log. Note the UUID of your app.", "Run `dwarfdump --uuid TriageLab.app.dSYM`. Do the UUIDs match? A different build has a different UUID.", "Use `atos -o <dSYM binary> -arch arm64 -l <load address> <crash address>` to turn an address into a function name."],
                guideRef: "docs/cases/C30.md"
            ),
            makeView: { AnyView(C30View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C31",
                ward: .release,
                title: "Silent kill on an iPhone 11",
                severity: .critical,
                report: "Nurses say the app closes while scanning on an iPhone 11. The crash dashboard is empty.",
                tools: ["Black Box: last-run report", "Console (silent_end_suspected)", "Xcode Organizer > Terminations", "Debug > Simulate MetricKit Payloads"],
                hints: ["There is no crash report. Open Black Box after the app returns.", "Read the last memory used and memory left values.", "iOS closes apps that go over their memory limit."],
                guideRef: "docs/cases/C31.md"
            ),
            makeView: { AnyView(C31View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C32",
                ward: .release,
                title: "Nightly sync is 'scheduled' but never runs",
                severity: .medium,
                report: "The log says the nightly sync was scheduled. It never runs.",
                tools: ["Console", "Info.plist (BGTaskSchedulerPermittedIdentifiers)", "Breakpoint on the submit line", "Debug: simulate a background task launch"],
                hints: ["Remove the `try?` from the submit line and print the error.", "Compare the identifier in code with the one in Info.plist.", "The identifiers differ by a few letters. The error was hidden."],
                guideRef: "docs/cases/C32.md"
            ),
            makeView: { AnyView(C32View()) }
        ),
        CaseEntry(
            info: CaseInfo(
                id: "C33",
                ward: .release,
                title: "Battery drain and a warm phone",
                severity: .high,
                report: "After using fall detection the battery drains fast and the phone gets warm.",
                tools: ["Xcode CPU, Disk and Energy gauges", "Instruments: Time Profiler, File Activity, Energy Log", "Console"],
                hints: ["Look at the CPU and Disk gauges after you leave the screen. Do they go down?", "Profile it. What runs 100 times a second?", "A fast timer writes to a file every time and nothing stops it."],
                guideRef: "docs/cases/C33.md"
            ),
            makeView: { AnyView(C33View()) }
        ),
    ]
}
