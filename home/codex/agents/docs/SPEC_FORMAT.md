# Spec

## Goal

Describe the intended outcome in concrete terms.

## Target Contract

List only what must be true after implementation. Do not describe how to implement it.

- ...

Use code or pseudocode only when it makes the contract less ambiguous.

```pseudo
target:
  ...
```

## Non-Goals

List behavior, schemas, files, APIs, or workflows that must not change.

## Open Questions

List only questions that block the target contract, or `None`.

## Rules

- Write the smallest artifact that has only one reasonable interpretation.
- Define what must be true; leave implementation strategy to `plan.md`.
- Leave investigation details in `exploration.md`.
- Use exact names and data shapes instead of explanatory prose when possible.
- Use real code when exact syntax is part of the contract.
- Use pseudocode when it defines data shape or behavior more clearly than prose.
- Do not use both code and pseudocode for the same point.
- Avoid ambiguous words such as "properly", "as needed", "fast", "clean", "simple", "reasonable", or "appropriate" unless defined.
- If a detail answers "how will this be implemented?", move it to `plan.md`.
