# ProductionBugsLab

[![Build](https://github.com/ManjunathAnawal/ProductionBugsLab/actions/workflows/build.yml/badge.svg)](https://github.com/ManjunathAnawal/ProductionBugsLab/actions/workflows/build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)
![Swift](https://img.shields.io/badge/Swift-SwiftUI-orange)

**33 production-style bugs in one iOS app. Learn to read the signals and find the root cause.**

Most iOS developers write features. Few get to debug field issues. This lab gives you the experience: a user report, a signal (or no signal), and a bug to hunt with Apple's own tools.

> **Warning:** the bugs are intentional. Do not copy this code into a production app.

## Who is this for?

- iOS developers with little production-issue experience
- Developers preparing for support, triage or on-call work
- Anyone who wants to learn Xcode, Instruments, Sanitizers, MetricKit and crash-report reading by doing

## How it works

1. Open a case in the app. Read the **field report**.
2. Trigger the bug.
3. Investigate with a tool. Use hints one at a time.
4. **Prove** the root cause. Then open the answer.

## Start in 3 minutes

```bash
git clone https://github.com/ManjunathAnawal/ProductionBugsLab.git
cd ProductionBugsLab
open TriageLab.xcodeproj
```

Pick an iPhone Simulator and press Run. Needs Xcode 16 or newer. Full steps: [docs/getting-started.md](docs/getting-started.md).

**No Mac handy?** Read the [practice guide online](https://manjunathanawal.github.io/ProductionBugsLab/) or browse [all cases](docs/cases.md).

## The method in one line

`TRIAGE`: **T**ell, **R**eal?, **I**solate, **A**ct, **G**uess, **E**liminate. Details: [docs/triage-method.md](docs/triage-method.md).

## Types of problems (families)

| Family | What you see | Cases |
|---|---|---|
| Memory and silent kills | App closes, no crash report | C01-C03 |
| Crashes | Crash report, or Xcode stops on a line | C04-C11 |
| Hangs, launch, speed | Frozen, slow, stutter | C12-C16 |
| Network | Retry floods, duplicates, random logouts | C17-C20 |
| Data, time, location | Wrong numbers, lost data | C21-C23 |
| Threads and queues | Wrong state, stuck queue | C24-C25 |
| Bluetooth (fake band) | Never connects, frozen data | C26-C27 |
| Accessibility and language | Audit fails, wrong layout in Arabic | C28-C29 |
| Release and tools (real phone) | Hex stacks, silent kills, jobs that never run, battery | C30-C33 |

What to think for each family: [docs/error-types.md](docs/error-types.md). Tools used: [docs/tools.md](docs/tools.md).

## All cases

| ID | Case | Family | Severity |
|---|---|---|---|
| [C01](docs/cases/C01.md) | Memory climbs on the vitals screen | Memory and silent kills | High |
| [C02](docs/cases/C02.md) | App closes on the photo gallery | Memory and silent kills | Critical |
| [C03](docs/cases/C03.md) | Memory grows all day on the live feed | Memory and silent kills | High |
| [C04](docs/cases/C04.md) | Crash opening one patient | Crashes | High |
| [C05](docs/cases/C05.md) | Crash on the third page | Crashes | Medium |
| [C06](docs/cases/C06.md) | Crash after going back quickly | Crashes | High |
| [C07](docs/cases/C07.md) | Crash when syncing in a lift | Crashes | High |
| [C08](docs/cases/C08.md) | Purple warning: publishing from background | Crashes | Low |
| [C09](docs/cases/C09.md) | Wrong count, sometimes a crash | Crashes | High |
| [C10](docs/cases/C10.md) | Crash: incorrect actor executor | Crashes | High |
| [C11](docs/cases/C11.md) | Crash at every launch after a download | Crashes | Critical |
| [C12](docs/cases/C12.md) | App freezes forever | Hangs, launch, speed | Critical |
| [C13](docs/cases/C13.md) | Freeze for a few seconds, CPU high | Hangs, launch, speed | Medium |
| [C14](docs/cases/C14.md) | First screen takes 10 seconds | Hangs, launch, speed | Critical |
| [C15](docs/cases/C15.md) | List stutters while scrolling | Hangs, launch, speed | Medium |
| [C16](docs/cases/C16.md) | Expanded rows close by themselves | Hangs, launch, speed | Medium |
| [C17](docs/cases/C17.md) | Outage: server flooded by retries | Network | Critical |
| [C18](docs/cases/C18.md) | Patient got two refill orders | Network | Critical |
| [C19](docs/cases/C19.md) | Users logged out at random | Network | High |
| [C20](docs/cases/C20.md) | Dashboard shows heart rate 0 after update | Network | High |
| [C21](docs/cases/C21.md) | Nurse note vanishes after app ends | Data, time, location | High |
| [C22](docs/cases/C22.md) | Negative minutes around the clock change | Data, time, location | Medium |
| [C23](docs/cases/C23.md) | Walk distance shows thousands of km | Data, time, location | Medium |
| [C24](docs/cases/C24.md) | Balance went negative | Threads and queues | High |
| [C25](docs/cases/C25.md) | Uploads stop at scan 3 | Threads and queues | High |
| [C26](docs/cases/C26.md) | Band found but never connects | Bluetooth (fake band) | High |
| [C27](docs/cases/C27.md) | Heart rate frozen but 'Connected' | Bluetooth (fake band) | Critical |
| [C28](docs/cases/C28.md) | Accessibility audit fails | Accessibility and language | Medium |
| [C29](docs/cases/C29.md) | Wrong arrows and raw keys in Arabic | Accessibility and language | Low |
| [C30](docs/cases/C30.md) | Crash log with only hex addresses | Release and tools (real phone) | Medium |
| [C31](docs/cases/C31.md) | Silent kill on an iPhone 11 | Release and tools (real phone) | Critical |
| [C32](docs/cases/C32.md) | Nightly sync is 'scheduled' but never runs | Release and tools (real phone) | Medium |
| [C33](docs/cases/C33.md) | Battery drain and a warm phone | Release and tools (real phone) | High |

## What is in the repo

| Path | What it holds |
|---|---|
| `TriageLab/Logic` | The bugs (plain Swift, one file per case) |
| `TriageLab/CaseViews` | Screens that trigger the bugs |
| `TriageLab/BlackBox` | The tools you investigate with: log, last-run report, memory numbers, hang detector, MetricKit receiver |
| `TriageLab/App` | App shell: Home, Console, Black Box |
| `docs/cases` | One page per case with hints and hidden answers |
| `docs/guide/index.html` | Interactive practice guide (open in a browser) |

## Real phone needed

C02, C14, C30, C31, C32 and anything about memory-left numbers behave best on a real iPhone. Set your Team in Signing and Capabilities.

## Recovery switches

| Problem | Fix |
|---|---|
| C11 crashes at every launch | Edit Scheme > Run > Arguments > add `-resetLabConfig` |
| C14 first screen takes 10 seconds | Edit Scheme > Run > Arguments > add `-fixSlowLaunch` |

## Known limits

- CI builds the project on every push. If the build fails for you (different Xcode version, say), please open an issue with the error.
- The data race in C09 shows best under Thread Sanitizer.
- The Bluetooth cases use a fake band. No hardware needed.
- This is a learning tool. It is not medical software.

## Contributing

New cases are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) and [docs/case-template.md](docs/case-template.md).

## Credits and sources

Built around Apple's public tools and talks, for example WWDC21 "Triage your crashes with Xcode Organizer" and WWDC20 "Triage test failures with XCTIssue". All case text is original.

## License

[MIT](LICENSE) (c) 2026 Manjunath Anawal
