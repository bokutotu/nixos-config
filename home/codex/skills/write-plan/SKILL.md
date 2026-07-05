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
# Plan: <one semantic feature / bug fix / refactor>

## Plan unit

```text
kind:
  <feature | bug-fix | refactor>

change:
  <this plan implements exactly one semantic change>

done when:
  - <observable condition>
  - <observable condition>

not included:
  - <separate feature / bug fix / refactor>

```

## Code detail rule

```text
default:
  - write focused raw code excerpts only
  - do not use diff format
  - do not mix raw code, diff, and pseudocode by default
  - show target code shape, not patch shape or full-file shape
  - include only decision-bearing code: types, fields, function signatures, control-flow branches, state transitions, errors, and assertions
  - omit imports, unchanged surrounding code, mechanical plumbing, generated boilerplate, formatting-only details, and unrelated fields
  - do not output a complete file, module, component, handler, or test unless the whole unit is the smallest useful explanation

pseudocode exception:
  - if one code block would exceed 50 lines, use pseudocode for that block
  - if focused raw code still hides the decision behind generated or framework boilerplate, use pseudocode for that block
  - when using pseudocode, keep real names for modules, functions, types, fields, routes, and errors
  - pseudocode must preserve control flow, data ownership, validation, state transition, side effects, and error behavior

test rule:
  - put tests inside the same Change block as the code being tested
  - do not create a separate final Test section
  - write focused raw test code by default
  - if one test block would exceed 50 lines, use pseudocode for that test block
  - each test must call the target function, handler, command, repository, or component shown in the same Change block
  - include only the arrange data, target call, expected whole value, and expected state needed to prove the change
  - omit test imports, harness boilerplate, factory definitions, and unrelated setup
```

## Implementation sketch

Each `Change` block keeps code and tests together.
Do not split data model, logic, and tests into separate top-level sections.

### Change 1: <core behavior>

```<language>
-- focused implementation excerpt
<target type / request / response / state>

<target function signature>

<only branches / state transitions / errors that express the change>
```

```<test-language>
-- focused tests for Change 1
it "<success behavior>" do
  <arrange>

  result <- <target call>

  result `shouldBe` <whole expected value>
  <state after call> `shouldBe` <whole expected value>

it "<failure behavior>" do
  <arrange invalid input>

  <target call>
    `shouldThrow` <expected error>

  <state after failure> `shouldBe` <whole expected value>
```

### Change 2: <boundary behavior>

```<language>
-- focused implementation excerpt
<route / handler / component / command>

<request / response / props / event shape>

<only boundary behavior that expresses the change>
```

```<test-language>
-- focused tests for Change 2
it "<boundary success behavior>" do
  <arrange request / props / event>

  result <- <target boundary call>

  result `shouldBe` <whole expected response / rendered state>

it "<boundary error behavior>" do
  <arrange invalid request / props / event>

  result <- <target boundary call>

  result `shouldBe` <whole expected error response / rendered error state>
```

### Change 3: <persistence or external effect>

```<language>
-- focused implementation excerpt
<schema or query shape>

<repository / client function>

<only transaction / rollback / idempotency behavior that expresses the change>
```

```<test-language>
-- focused tests for Change 3
it "<persistence success behavior>" do
  <arrange stored data>

  result <- <target repository / client call>

  result `shouldBe` <whole expected value>
  <stored state> `shouldBe` <whole expected state>

it "<rollback or idempotency behavior>" do
  <arrange failure or duplicate input>

  result <- <target repository / client call>

  result `shouldBe` <whole expected value>
  <stored state> `shouldBe` <whole expected state>
```

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
