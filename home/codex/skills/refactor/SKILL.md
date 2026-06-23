---
name: refactor
description: Refactor lifecycle orchestration. Use when Codex must make behavior-preserving design changes by planning module and dependency changes, then implementing the approved plan.
---

# Refactor

## Child skills

This parent skill only orchestrates refactoring.
The child skills own phase behavior, formats, and stopping rules.

Before each phase, load and follow the named child skill.
If a file path is needed, read it from `$CODEX_HOME/skills/<skill>/SKILL.md`, or from `~/.codex/skills/<skill>/SKILL.md` when `CODEX_HOME` is unset.

- Plan: `write-plan`
- Implementation: `implement-plan`

Do not duplicate child-skill rules here.
If a phase rule needs to change, update the child skill.

## Refactor contract

A refactor changes structure, names, boundaries, or dependencies without changing external behavior.
If the request includes a behavior change, split the behavior change from the refactor or use `development`.
If the work discovers a bug that needs a fix, stop and ask whether to switch to `fix-bug`.

## Lifecycle

**NEVER SKIP PHASES**
**YOU SOMETIME DON'T FOLLOW THIS FLOW. FUCK YOU. YOU MUST EVERY TIME OUTPUT PLAN**

1. Use `write-plan` to decide the preserved behavior, structural target, file changes, module boundaries, dependency impact, build order, and validation.
2. Use `implement-plan` to apply the approved plan.

Each phase must produce a complete artifact or stop with questions.
Do not continue from an ambiguous artifact.

## Guardrails

Preserve public behavior.
Use validation that can detect accidental behavior change.
Keep each refactor unit small enough to review independently.

## Output

**YOU MUST USE SUBSKILL FORMAT**
