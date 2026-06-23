---
name: write-plan
description: Write an implementation plan for an approved spec. Use when Codex has a clear spec.md or explicit target contract and must choose file-level changes, module boundaries, dependency effects, build order, and validation without editing code.
---

# Write Plan

## Phase contract

Write the `how` for an approved spec.
Do not edit code in this phase.

The spec says what will change.
The plan says how to build that change.
If the spec is ambiguous, return to `write-spec`.

## Work sequence

1. Read the accepted spec.
2. Gather project context only as needed to plan the change.
3. Check local rules, naming style, module boundaries, and design rules.
4. Look for similar implementations and decide whether to reuse, extend, or stay separate.
5. If a plan-level decision is unclear, output questions and stop.
6. Output the plan.

Understand why the codebase is shaped the current way before planning changes.
Choose the simplest solution that satisfies the spec.
If a simpler solution requires changing the spec, stop and ask the user to change the spec.

## Design rules

Keep the implementation as simple as possible.
Do not add fallbacks, compatibility layers, indirection, or extension points unless the spec requires them.

Check that the plan preserves SOLID principles.
Keep the module dependency graph acyclic.

Allowed:

```text
FeatureA -> FeatureA/InternalParser
```

Forbidden:

```text
FeatureB -> FeatureA/InternalParser
```

Preferred:

```text
FeatureA -> SharedParser
FeatureB -> SharedParser
```

Dependency rules:

- A feature may depend on its own internal modules.
- A feature must not depend on another feature's internal modules.
- Shared behavior must move to a small dedicated module or an explicit interface.
- The dependency graph must remain acyclic.

Expose as few modules, functions, and data types as possible.

Prefer feature-based directories over layer-based directories.
Avoid catch-all names such as `utils`, `usecase`, `type`, and `components`.
A reader must be able to infer a module, file, function, or data type's purpose from its name and location.

Name things simply and uniquely.
Prefer `GetEmailLoginUser` over `GetUserFilteredByLoginEmail`.

## Plan output

````markdown
## Build Target

Summarize how the plan implements the spec in a few sentences.

## Approach

Describe the chosen design and why it is the simplest option that satisfies the spec.
If a simpler design exists but would require changing the spec, stop and ask the user.

## Features

List the small features that implement the spec.
Order them so each feature builds only on earlier features.
Each feature must do one thing: one feature, objective, refactor, or bug fix.

### Feature n: Feature title

**Goal**

State what this single feature achieves and which part of the spec it covers.

**Files And Modules**
- `path or module`: what changes and why

**Dependency Impact**

Show dependency changes if the feature adds or removes module edges.
Omit this block if the feature adds no edges.

```text
A -> B
+ B -> D
```

**Exposure**

State what becomes public and what stays internal.
Expose as little as possible.

- Public: name — why it must be public
- Internal: name — why it stays private

**Sketch**

Show code or pseudocode only when the goal is still ambiguous without it.

**Depends On**

List earlier features this one requires, or write `none`.

**Validation**
- case: expected result

## Build Order

1. Feature 1
2. Feature 2
````

## Question output

```markdown
## Question n: Title

### Description

Briefly summarize the question.

### Context

Explain the current code or plan evidence.

### Problem

Explain what is ambiguous.

### Recommendation

State the recommended answer when there is enough evidence to recommend one.
```
