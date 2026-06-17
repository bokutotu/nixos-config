# Agent Result Format

## Purpose

Use this format for the subagent chat response after the owned artifact has been written.

## Required Structure

```md
# Agent Result

## Verdict

## Artifact paths

## Files read

## Files written

## Summary

## Evidence

## Decisions

## Open questions

## Next recommendation
```

## Rules

- List the owned artifact path under `Artifact paths`.
- Include every input artifact path, feedback file path, source file path, and diff input read when relevant to the phase.
- Include the owned artifact path and every changed source or test file path under `Files written`.
- Allowed verdict values are phase-specific and must come from the owning subagent instructions.
- This document must not define one global allowed-verdict list.
