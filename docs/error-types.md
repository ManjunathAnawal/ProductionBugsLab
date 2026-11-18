# Error types: what you see and what to think

Real production bugs fall into a few families. Learn the family first. The tool follows.

| Family | What you see | First thought | Tools |
|---|---|---|---|
| **Memory and silent kills** | App closes by itself. No crash report. | Think: iOS closed it (memory). Check last-run log, Memory gauge, Memory Graph. | Memory gauge, Allocations, VM Tracker, Debug Memory Graph, last-run log |
| **Crashes** | Crash report or Xcode stops on a line. | Read the exception type and the top frames. Same line every time = logic bug. Random lines = memory damage or data race. | Stack trace, breakpoints, Sanitizers, Main Thread Checker |
| **Hangs, launch, speed** | Frozen UI, slow start, stutter. | High CPU in the stack = busy. Low CPU = waiting (lock, network, disk). | Pause button, Time Profiler, Hangs and Hitches instruments |
| **Network** | Errors in some places, floods of requests, duplicates. | Look at request IDs, status codes, retry counts, timing. | Console log, Network instrument, Link Conditioner |
| **Data, time, location** | Wrong numbers, lost data, odd times. | Silent wrong data: look for try?, bad units, time zones, stale input. | Console log, breakpoints, file inspection |
| **Threads and queues** | Stuck queue, wrong state across await. | Find who never finishes, and what changed across an await. | Thread Sanitizer, Debug navigator, logs |
| **Bluetooth** | Found but never connects; connected but no data. | Walk the chain: scan, discover, connect, services, notify, data. Find the missing step. | Console log filter, breakpoints in delegate methods |
| **Accessibility and language** | Audit fails, wrong layout in Arabic. | Test with VoiceOver, big text, pseudolanguages. | Accessibility Inspector, scheme language options |
| **Release and tools** | Hex stacks, silent kills, jobs that never run, battery. | Real device and release builds. Check symbols, last-run log, schedulers, energy. | dwarfdump, atos, Organizer, Energy Log, MetricKit |

## Cases per family

**Ward 1: Memory and silent kills**: [C01](cases/C01.md), [C02](cases/C02.md), [C03](cases/C03.md)

**Ward 2: Crashes**: [C04](cases/C04.md), [C05](cases/C05.md), [C06](cases/C06.md), [C07](cases/C07.md), [C08](cases/C08.md), [C09](cases/C09.md), [C10](cases/C10.md), [C11](cases/C11.md)

**Ward 3: Hangs, launch, speed**: [C12](cases/C12.md), [C13](cases/C13.md), [C14](cases/C14.md), [C15](cases/C15.md), [C16](cases/C16.md)

**Ward 4: Network**: [C17](cases/C17.md), [C18](cases/C18.md), [C19](cases/C19.md), [C20](cases/C20.md)

**Ward 5: Data, time, location**: [C21](cases/C21.md), [C22](cases/C22.md), [C23](cases/C23.md)

**Ward 6: Threads and queues**: [C24](cases/C24.md), [C25](cases/C25.md)

**Ward 7: Bluetooth (fake band)**: [C26](cases/C26.md), [C27](cases/C27.md)

**Ward 8: Accessibility and language**: [C28](cases/C28.md), [C29](cases/C29.md)

**Ward 9: Release and tools (real phone)**: [C30](cases/C30.md), [C31](cases/C31.md), [C32](cases/C32.md), [C33](cases/C33.md)
