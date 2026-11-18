# Getting started

## You need

- A Mac with Xcode 16 or newer.
- An iPhone Simulator. A real iPhone is needed for cases C02, C14, C30, C31, C32 and anything about memory left.

## Steps

1. Clone: `git clone https://github.com/ManjunathAnawal/ProductionBugsLab.git`
2. Open `TriageLab.xcodeproj`.
3. Pick a simulator and press Run.
4. Tap a case. Read the field report. Trigger the bug. Investigate.
5. Open the case page in `docs/cases/` when you are stuck. Use hints first.

## How to practise

1. Read only the field report.
2. Trigger the bug in the app.
3. Pick a tool from the tool list. Look for the signal.
4. Write down your guess before you open a hint.
5. Prove it: say what you would see if the guess is right.
6. Open the answer and compare.

Ask yourself each time: What do I see? Which tool? How do I PROVE it?

## Recovery switches

| Problem | Fix |
|---|---|
| C11 crashes at every launch | Edit Scheme > Run > Arguments > add `-resetLabConfig` |
| C14 first screen takes 10 seconds | Edit Scheme > Run > Arguments > add `-fixSlowLaunch` |

## Tool did not work?

- **Memory Graph or Leaks fails:** run on a simulator, turn off Sanitizers for that run, make sure C11 and C14 are not active, and try a clean build.
- **"Process is no longer running":** the app crashed or was closed. Check the Black Box screen for the last-run report. For C11 use the recovery switch.
- **No crash log:** that is the point of the silent-kill cases. Read the last-run report.

## Safety

The bugs are intentional. Do not copy this code into a production app.
