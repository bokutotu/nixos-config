# Spec

## Goal

Describe the outcome in concrete user-visible terms.

## Non-Goals

List behavior or scope that will not change.

## Definitions

Define domain terms used by the spec.

## Current Behavior

Describe relevant existing behavior with evidence. Use pseudocode when it makes the current behavior easier to understand.

## Target Behavior

Describe required behavior after the change. Use pseudocode when it makes the target behavior easier to understand.

## Behavior Rules

| ID | Rule | Source or Evidence |
|---|---|---|
| BR-001 | <behavior rule> | <user request, file, symbol, or observation> |

## Verification Checks

| ID | Behavior Rule | Scenario | Expected Result | Validation |
|---|---|---|---|---|
| VC-001 | BR-001 | <observable scenario> | <observable result> | <test, command, manual check, or reason no automated test applies> |

## Error Behavior

Describe exact errors, fallbacks, and edge-case behavior.

## Compatibility

State what existing behavior, public API, data shape, CLI, config, or serialized format must remain compatible.

## State and Data

Describe state transitions, data model expectations, migrations, or say none.

## Open Questions

List only questions that block the spec.

## Rules

- Every behavior rule must have a stable `BR-###` ID.
- Every verification check must have a stable `VC-###` ID and be observable.
- Domain terms must be defined.
- Non-goals must be explicit.
- Current behavior and target behavior must be separated.
- Error behavior and compatibility expectations must be explicit.
- Avoid ambiguous words such as "properly", "as needed", "fast", "clean", "simple", "reasonable", or "appropriate" unless defined.
