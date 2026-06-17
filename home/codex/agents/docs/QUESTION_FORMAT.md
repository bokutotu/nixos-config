# Question Format

## Purpose

Use this format when a subagent returns `HUMAN_DECISION_REQUIRED`.

## Required Structure

Ask each decision as a separate block:

````md
## Question N: <Short Title>

### Description

<The exact decision needed. Include options only when they clarify the decision.>

If pseudocode or raw code helps explain the choice, include it here:

```pseudo
current: ...
target: ...
```

### Context

- Why: <why this question is being asked now>
- Effect: <what changes depending on the answer>
- Evidence: `<file/path>` or `<artifact/path>`
- Recommendation: <optional recommendation with reason, or `None`>
````

## Rules

- Use concrete, answerable questions only.
- Ask separate questions as separate blocks.
- Include options only when they clarify the decision.
- Keep evidence tied to artifact paths, file paths, commands, or observed behavior.
