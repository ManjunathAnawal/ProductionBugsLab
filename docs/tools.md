# Tools used in this lab

| Tool | One-line use |
|---|---|
| Xcode gauges (CPU, Memory) | Quick view of a problem while the app runs |
| Pause button | See what every thread is doing right now (best for hangs) |
| Debug Memory Graph | Find leaked objects and who holds them |
| Breakpoints | Stop on a line, print values |
| Address Sanitizer | Find memory damage |
| Thread Sanitizer | Find data races |
| Main Thread Checker | Find UI work off the main thread |
| Instruments: Time Profiler | Which code uses the CPU |
| Instruments: Allocations / Leaks | What memory grows and what leaks |
| Instruments: Hangs / Hitches | Main thread blocked, dropped frames |
| Instruments: Energy Log | Battery impact |
| Xcode Organizer | Crash, hang, memory and termination data from real users |
| MetricKit | Your app receives daily metrics and diagnostics |
| `dwarfdump --uuid`, `atos` | Match and read symbols for a crash log |
| Accessibility Inspector | Audit labels, sizes, contrast |
| Network Link Conditioner | Test slow and lossy networks |
| Console / Logger | Read app logs |

## Apple sources

- WWDC21 "Triage your crashes with Xcode Organizer" (session 10203)
- WWDC20 "Triage test failures with XCTIssue" (session 10687)
- Apple docs: MetricKit, Instruments, Diagnosing issues using crash reports
