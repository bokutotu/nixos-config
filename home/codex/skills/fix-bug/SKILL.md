---
name: fix-bug
description: Bug-fix lifecycle orchestration. Use when Codex must fix a bug by first finding the root cause, then creating a fix spec, planning the implementation, and applying the approved plan.
---

# Fix Bug

## Child skills

This parent skill only orchestrates bug-fix work.
The child skills own phase behavior, formats, and stopping rules.

Before each phase, load and follow the named child skill.
If a file path is needed, read it from `$CODEX_HOME/skills/<skill>/SKILL.md`, or from `~/.codex/skills/<skill>/SKILL.md` when `CODEX_HOME` is unset.

- Root cause: `find-root-cause`
- Spec: `write-spec`
- Plan: `write-plan`
- Implementation: `implement-plan`

Do not duplicate child-skill rules here.
If a phase rule needs to change, update the child skill.

## Lifecycle

**NEVER SKIP PHASES**
**YOU SOMETIME DON'T FOLLOW THIS FLOW. FUCK YOU. YOU MUST EVERY TIME OUTPUT ROOT CAUSE, SPEC AND PLAN**

1. Use `find-root-cause` to explain why the bug happens.
2. If the root cause is not proven, stop with the missing evidence or questions.
3. Use `write-spec` to define the behavioral fix contract.
4. Use `write-plan` to decide how to build the approved fix.
5. Use `implement-plan` to apply the approved plan.

The root-cause finding is input to the spec.
The spec should state the target behavior, not copy the full investigation log.

## Returning to earlier phases

Move backward when a later phase exposes missing information.

- While writing the spec, return to `find-root-cause` if the cause is not proven.
- While planning, return to `write-spec` if the fix contract is ambiguous.
- While implementing, return to `write-plan` if the plan is ambiguous.
- While implementing, return to `write-spec` if the target behavior is ambiguous.

When returning to an earlier phase, explain the concrete ambiguity and stop for user input.

## Output

**YOU MUST USE SUBSKILL FORMAT**
