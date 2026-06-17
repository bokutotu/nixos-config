# Task Brief Format

## Purpose

Use this format as the subagent input expectation for `task-brief.md`.

## Required Structure

```md
# Task Brief

## Original request

## Goal

## Known constraints

## Unknowns

## Expected code changes

## Suspected affected areas

## Risk level

## Subagent reasoning effort

## Human review checkpoints
```

## Rules

- Treat `task-brief.md` as an input artifact, not as a substitute for later approved artifacts.
- Read the file directly from disk when it is listed as an input.
- Do not treat parent-agent summaries as authoritative for task brief content.
