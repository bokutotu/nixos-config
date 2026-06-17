# Task Capsule Format

## Purpose

Use this format as the subagent input expectation for parent-to-subagent handoff messages.

## Required Structure

```md
# Task Capsule

## Goal

## Phase

## Subagent reasoning effort

## Current artifact paths

## Task directory

## Input artifact paths

## Output artifact path

## Inputs

## Relevant files or search targets

## Raw user feedback path

## Constraints

## Required output

## Stop conditions
```

## Rules

- Treat the task capsule as a control-plane handoff, not as authoritative prior-phase content.
- Read required artifact paths from disk instead of relying on capsule summaries.
- Use the output artifact path exactly as provided.
