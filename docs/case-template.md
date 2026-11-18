# Case template

Copy this to add a new case. Keep sentences short. Keep the bug small and real.

```markdown
# Cxx: Short title

**Family:** (Memory / Crashes / Hangs / Network / Data / Threads / Bluetooth / Accessibility / Release)
**Severity:** Critical | High | Medium | Low

## Field report
> What a user or support person says. No technical words.

## 1. Reproduce
Numbered steps in the app.

## 2. Tools to try
- Tool names

## 3. Where the bug lives
- `TriageLab/Logic/Lxx_Name.swift`

## Hints (one at a time)
Three hints. First is a nudge, last is nearly the answer.

## Answer
<details>
### Root cause
### How to prove it
What you should see if the guess is right.
### Fix
Small code block.
### Prevent it next time
</details>
```

## Rules for a good case

1. It must be a bug that really happens in production.
2. It must run on the simulator, or say it needs a real phone.
3. The signal must be findable with an Apple tool or the Black Box.
4. The answer must say how to PROVE the cause, not only the fix.
5. No personal data. No company names.
