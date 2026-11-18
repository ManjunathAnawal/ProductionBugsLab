# The triage method

Two memory tricks. Use them on every case.

## TRIAGE (the steps)

| Letter | Step | Question |
|---|---|---|
| **T** | Tell | What exactly did the user see? Since when? Who? |
| **R** | Real? | Is the data correct? Is the metric correct? |
| **I** | Isolate | Slice by version, OS, phone, screen, region, flag. |
| **A** | Act | Stop the damage first: flag off, pause rollout, server fix. |
| **G** | Guess | Make one clear hypothesis. Then reproduce it. |
| **E** | Eliminate | Fix, add a test, prove it against the old version. |

## Stop the damage (in order)

1. Turn the feature flag off.
2. Pause the phased rollout.
3. Apply a server-side fix.
4. Show an update prompt.
5. Ask for an expedited review.

iOS has no rollback, so plan these before you ship.

## Six slicing filters

**Version, OS, Phone, Page, Place, Flag.** The group where the problem is high and the control group is low shows you where to look.

## BLACK BOX: build these in before you ship

| Letter | Build | Why |
|---|---|---|
| **B** | Breadcrumbs + crash tool | Know the last steps before a crash |
| **L** | Logs with an ID card (who, what, where, health) | Slice any problem |
| **A** | Apple MetricKit | Daily numbers and diagnostics from real users |
| **C** | Code symbols (dSYM) | Readable stacks |
| **K** | Know the last run | Detect silent kills on next launch |
| **B** | Bytes left (memory) | See memory pressure before the kill |
| **O** | On/off flags | Stop damage without a release |
| **X** | eXit old versions | Update prompts and forced updates |

You can only diagnose what you recorded. Build the camera before the accident.

## Safe logging

- No personal data or patient data in logs.
- Random install IDs, codes and counts instead.
- Keep a size limit and an age limit.
