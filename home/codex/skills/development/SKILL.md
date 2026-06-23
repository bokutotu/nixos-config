---
name: development
description: Development lifecycle orchestration. Use when Codex must take a project change from user request through spec, plan, and implementation by delegating phase rules to write-spec, write-plan, and implement-plan.
---

# Development

## Child skills

This parent skill only orchestrates the lifecycle.
The child skills own phase behavior, formats, and stopping rules.

Before each phase, load and follow the named child skill.
If a file path is needed, read it from `$CODEX_HOME/skills/<skill>/SKILL.md`, or from `~/.codex/skills/<skill>/SKILL.md` when `CODEX_HOME` is unset.

- Spec: `write-spec`
- Plan: `write-plan`
- Implementation: `implement-plan`

Do not duplicate child-skill rules here.
If a phase rule needs to change, update the child skill.

## Lifecycle

**NEVER SKIP PHASES**
**YOU SOMETIME DON'T FOLLOW THIS FLOW. FUCK YOU. YOU MUST EVERY TIME OUTPUT SPEC AND PLAN**

1. Use `write-spec` to define what will change.
2. Use `write-plan` to decide how to build the approved spec.
3. Use `implement-plan` to apply the approved plan.

Each phase must produce a complete artifact or stop with questions.
Do not continue from an ambiguous artifact.

## Returning to earlier phases

Move backward when a later phase exposes missing information.

- While planning, return to `write-spec` if the spec is ambiguous.
- While implementing, return to `write-plan` if the plan is ambiguous.
- While implementing, return to `write-spec` if the target contract is ambiguous.

When returning to an earlier phase, explain the concrete ambiguity and stop for user input.

## Output

**YOU MUST USE SUBSKILL FORMAT**
