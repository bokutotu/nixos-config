# Plan

## Target Result

Describe what will be true after implementation in concrete terms. A reviewer should be able to imagine the changed behavior.

## Current State

List the relevant current files, symbols, behavior, tests, and constraints.

## Work Items

### PLAN-001: <Short Action Title>

- Target files: `<path>`, `<path>`
- Before:
```pseudo
<current behavior, structure, or raw code if useful>
```
- After:
```pseudo
<target behavior, structure, or raw code if useful>
```
- Exact changes: <specific edits to make>
- Covers: `BR-001`, `VC-001`
- Dependencies: <previous plan item or none>
- Validation: <test/build/check>

Repeat for every work item.

## Execution Order

List the exact order the implementer should follow.

## Validation

List targeted tests, broader tests, builds, formatters, or manual checks. Map each verification check to a validation item.

## Refactor Scope

Classify each refactor:

- Required refactor: needed to satisfy the spec safely.
- Local cleanup: directly adjacent cleanup that simplifies touched code.
- Strategic refactor: useful later but out of scope unless approved.

## Architecture and Boundaries

State module boundaries, dependency direction, and any boundary service, port, facade, repository, adapter, or application-service entry point the implementation should use.

## Risks

List specific implementation risks and how the plan contains them.

## Not Doing

List explicitly excluded changes.

## Review Checklist

- Every behavior rule has a plan item.
- Every verification check has validation.
- Every file change has a reason.
- No unapproved strategic refactor is included.
- No known compatibility behavior is changed without approval.

## Rules

- Each work item must name target files.
- Each work item must show before and after pseudocode or raw code when useful.
- Each work item must map back to behavior rules and verification checks.
- The plan must be concrete enough for implementation review before code changes start.
