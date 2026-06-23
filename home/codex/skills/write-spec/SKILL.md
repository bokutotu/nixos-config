---
name: write-spec
description: Create a small unambiguous project-change spec before planning or implementation. Use when Codex must turn a user request into a contract for a feature, objective, refactor, or bug fix, ask blocking questions, split mixed work, or write spec.md.
---

# Write Spec

## Phase contract

Write the `what` for a project change.
Do not decide how to build it.

Use `english-tech-writing` when writing English prose.
Keep the spec small, concrete, and unambiguous.

## Work sequence

1. Read the user request in the working directory.
2. Gather enough project context to understand the current behavior and boundary.
3. If ambiguity remains, output questions and stop.
4. If the request combines independent changes, ask the user to split or choose the first unit.
5. Output the spec after the ambiguity is resolved.

The user's request must be about a project or artifact Codex can inspect.
If the needed project context is unavailable, ask for the missing artifact instead of guessing.

## Ambiguity questions

Ask questions over multiple turns if needed.
Start with high-level questions, then move toward concrete details.
If the conversation becomes inconsistent, point out the inconsistency and return to the higher-level decision.

Ask in this order when the request does not already answer the point:

Problem or motivation -> Desired outcome -> Scope in or out -> User-visible or API contract -> Data model or flow -> Edge cases and validation

## Split rule

One spec covers one thing:

- One feature
- One objective
- One refactor
- One bug fix

Line count, number of files, and number of components do not define one thing.
A bundle that mixes a bug fix, refactor, and feature must be split or clarified.

## Spec output

Write only the contract.
Do not include implementation strategy, migration ordering, build steps, or test commands.
Those belong to `write-plan`.

Use code, pseudocode, ASCII art, or HTML only when it removes ambiguity.
Choose one representation for a point instead of showing the same point twice.

```markdown
## Target

Describe the change in one unambiguous paragraph.
If there are multiple independent topics, stop and ask for a split.

## Features

### Feature n: Feature title

**Terms**
- term: meaning

**Current Contract**

Describe the current behavior or contract using facts from the project.

**Target Contract**

Describe the target behavior or contract.

**Out Of Scope**

List decisions or behaviors that this spec does not change.
```

## Question output

```markdown
## Question n: Title

### Description

Briefly summarize the question.

### Context

Explain the current behavior or evidence.

### Problem

Explain what is ambiguous.

### Recommendation

State the recommended answer when there is enough evidence to recommend one.
```
