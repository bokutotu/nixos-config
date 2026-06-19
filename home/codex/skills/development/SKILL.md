---
name: development
description: Development lifecycle skill. Create a spec and plan, then implement.
---

## Flow

You must follow this flow.
Never skip phases.

1. Spec
2. Plan
3. Implementation

### Back to previous sections

When writing `plan.md`, if there are ambiguous things in the spec, you can go back to phase 1.
When starting implementation, if there are ambiguous things in the plan, you can go back to phase 2. If the spec is ambiguous, go back to phase 1.


## Spec creation

### Simplicity is most important

Keeping the project simple is the biggest goal.
You should choose the simplest solution.

### Flow

1. Read the user input in the working directory.
2. Gather information.
3. If there is ambiguity, ask the user (output Questions) and stop.
4. Once the ambiguity is resolved, output Spec

### Gather Information

The user's request must be about a project you can access.
Gather as much information as possible.

### Ambiguity Resolution

- Ask questions over multiple turns if needed to remove all ambiguity.
- First, ask high-level / abstract questions. As the conversation progresses, shift toward more specific questions.
- If there is an inconsistency during the conversation, point it out and return to high-level abstract questions.


### Question order example

Ask from abstract to concrete:

Problem / motivation -> Desired outcome -> Scope in/out -> User-visible or API contract -> Data model / flow -> Edge cases and validation

### Output

- The output spec must be simple and unambiguous.

### Problem Split

One commit or PR must do only one thing.
One thing means one of the following:
- One feature
- One objective
- One refactor
- One bug fix
The following do not define one thing:
- This spec will change many lines.
- This spec will change many components or modules.

### Format

Use the `english-tech-writing` skill.

#### Spec

```markdown
## Target
Describe what we will do.
(If there are many topics to handle, consider splitting the spec.)
## Features
### Feature n: <feature title>
**Term**
- <term>: description
- ...
**Current**
<explain the current format>
**Target**
<explain the target format>
**Out of Scope**
<If this is a discussion, summarize it.>
Explain the current status.
Use facts. If referring to code would be too large, use pseudocode.
If the code is small, use raw code.
In a spec, a sequence diagram or ER diagram is often the easiest to understand.
Since you cannot render them now, output ASCII art or HTML.
```

#### Questions

```
## Question n: title
### Description
<Briefly summarize the question.>
### Context
<explain the current behavior or other evidence>
### Problem
<what is ambiguous or what the problem is>
### Recommendation
<write the recommendation>
```

## Plan

**Keep It Simple Stupid**

- Implementation must be as simple as possible.
- If there is a simpler way but it requires changing the spec, you must ask the user to change the spec.

**SOLID**

You must check that this implementation never affects SOLID principles.

**Module Dependency Graph**

Never cycle.

Never
```
moduleA -> moduleA-A (using moduleA-B is not bad)
        -> moduleA-B

moduleB -> moduleB-A (using moduleA child)
```
If you want to use other module's funciton, this funciton should be splited to service and Need interface

**Expose as few modules, functions, and data types as possible**

Your task is to create an implementation plan for the spec.

**Prefer Feature based directory not layer base direcotry**

Never:
- utils
- usecase
- type
- components

This is never screaming. If check direcotry name or file name or naming and type signature, 
reader must be able to imagine what this module, file, function, data type doing.

Prefer:
- BidirectionalElaboration
- Surface
- CoreSyntax

**Naming**

Naming must be simple, short, uniquly.

Never:
- GetUserFilterdByLoggingInByEmail

Good
- GetEmailLoginUser

### Flow

1. Gather information if needed.
2. If the spec is ambiguous, go back to the Spec phase.
3. If something is unclear at the plan level, ask the user (output Questions) and stop.
4. Output the plan.

### Difference between Spec and Plan

- Spec is what we will do
- Plan is how to build this spec.
- If you are in this section, what we will do is configured. You only have to think about how to do it.

### Gather information

Understand why the codebase is shaped this way before planning changes.
Check the local coding rules, naming style, module boundaries, and design rules.

Design the simplest solution that still follows those rules.

Look for similar implementations.
If an existing implementation has the same purpose, plan to reuse or extend it instead of creating a parallel path.
If it has a different purpose, explain why the new implementation should stay separate.

### Format

#### Plan

```markdown
## Overview
Summarize how to build this spec in a few sentences.
If the spec is large, it is decomposed below into smaller features,
each independently implementable and reviewable.

## Approach
Describe the chosen design and why it is the simplest option that satisfies the spec.
If a simpler design exists but would require changing the spec, stop and ask the user.

## Features
List the small features that, together, implement the spec.
Order them so each builds only on earlier ones.
Each feature must do one thing (one feature / objective / refactor / bug fix).

### Feature n: <feature title>
**Goal**
What this single feature achieves, and which part of the spec it covers.

**Affected Modules**
- `<module>`: what changes and why

**Dependency Impact**
How module dependencies change. The graph must stay acyclic.
```
A -> B
+ B -> D
```
(Omit this block if the feature adds no edges.)

**Exposure**
What becomes public vs. internal. Expose as little as possible.
- Public: <name> — why it must be public
- Internal: <name> — kept private

**Sketch**
Show how, using the lightest form that removes ambiguity
(see "Code in Plan" below). Omit if the Goal is already unambiguous.

**Depends on**
Earlier features this one requires (e.g. "Feature 1"), or "none".

**Test**
- <case>: expected result

## Build Order
The order to implement the features, as a short list.
1. Feature 1
2. Feature 2
...
```

## Implementation

Your task is to implement the plan, one feature at a time, in Build Order.
Each feature is one commit (one thing). Do not start the next feature until the current one is done.
If the plan turns out to be ambiguous, stop and go back to the Plan phase (or the Spec phase if the spec is ambiguous).

### Naming

Decide a name from what the thing does, not how it is built.
A reader must be able to guess the behavior from the name, type signature, and location alone.

How to decide:
1. State in one short phrase what it does.
2. Drop words that the type signature or module path already tells the reader.
3. Keep it short and unique. If two names could be confused, make the difference explicit.

Never (restates the mechanism / over-qualified):
- `GetUserFilterdByLoggingInByEmail`
- `UserDataManagerHelper`

Good (states the result):
- `GetEmailLoginUser`
- `parseSurface`

Rules:
- Name by intent, never by layer (`util`, `manager`, `helper`, `data` are banned).
- Same concept, same word everywhere. Do not call it `user` here and `account` there.
- A type signature plus a good name should make a doc comment unnecessary.

### Test

Compare whole objects, not fields one by one.

Build the expected object in the test code, run the target, then assert the two objects are equal in a single comparison.
Do not read out individual fields and check them separately.

Bad (field-by-field):
```
result = parseSurface(input)
assert result.name == "x"
assert result.kind == Lam
assert result.body == ...
```

Good (one whole-object comparison):
```
expected = Term{ name = "x", kind = Lam, body = ... }
result   = parseSurface(input)
assert result == expected
```

Why:
- One comparison fails clearly and shows the whole diff, not a single field.
- When the shape changes, you fix the expected object in one place, not many asserts.
- The expected object documents what the result should look like.

Rules:
- Construct the expected value explicitly in the test; do not derive it from the code under test.
- One behavior per test. The name says what behavior it checks.
- If equality needs custom logic, define it on the type, not in the test.
