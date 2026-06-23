---
name: find-root-cause
description: Diagnose a bug before proposing a fix. Use when Codex must reproduce or trace a failing path, identify the concrete root cause, separate evidence from guesses, or explain why a bug happens before implementation.
---

# Find Root Cause

## Phase contract

Identify why the observed bug happens.
Do not implement a fix in this phase.

A root cause is the earliest project-controlled condition that explains the symptom and predicts the failing path.
If the cause cannot be proven, state what is known and what evidence is missing.

## Work sequence

1. Capture the symptom, expected behavior, actual behavior, and environment.
2. Reproduce the bug when that is practical and safe.
3. If reproduction is not practical, trace from the strongest available evidence.
4. Follow the failing path through code, data, configuration, and runtime boundaries.
5. Identify the first bad state, input, assumption, or dependency edge controlled by the project.
6. Validate the cause with the smallest useful command, test, log, or code trace.
7. Output the finding and stop.

Ask questions when the bug report lacks the minimum information needed to trace the failure.
Do not guess silently.

## Diagnosis rules

Trace from symptom to cause.
Do not start from a preferred fix.

Do not call a workaround the root cause.
Do not call workload size, flakiness, or user error the root cause unless the evidence shows the exact mechanism.

Separate facts from inferences.
Use uncertainty words when the evidence is incomplete.

Rule out plausible alternatives when doing so changes the conclusion.
If an alternative would produce the same symptom, explain why the evidence points elsewhere or say that the cause is not proven.

## Root cause output

```markdown
## Symptom

State the expected behavior, actual behavior, and entry point.

## Root Cause

State the concrete cause and the mechanism that turns it into the symptom.

## Failing Path

1. First relevant call, event, or state.
2. Next step.
3. Step where the bad state causes the symptom.

## Evidence

- fact or command result: what it proves

## Ruled Out

- alternative cause: why it does not explain the observed behavior

## Questions Or Blockers

List only the missing information that prevents a confident conclusion.
```

## Unproven cause output

Use this shape when the evidence does not prove a root cause:

```markdown
## Current Finding

State what the evidence shows.

## Missing Evidence

State what is still needed.

## Next Probe

Name the smallest next check that would distinguish the likely causes.
```
