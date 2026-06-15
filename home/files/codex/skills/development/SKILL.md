---
name: development
description: Orchestrate non-trivial software development work through intake, exploration, reviewable spec, reviewable plan, architecture review, implementation, code review, and revision. Use for coding tasks, refactors, bug fixes, feature work, test design, or architecture-sensitive changes. The parent agent must keep the main context as an orchestrator, use the dev_* subagents for phase work, always present spec.md and plan.md for user review before implementation, and route user feedback or human-decision answers back to the owning subagent.
---

# Development Skill

Use this skill to keep development work explicit, reviewable, and delegated.

The parent agent is an orchestrator. After intake, phase-specific rules belong to subagents, not the parent.

## Parent Responsibilities

- Create the initial task brief.
- Start the correct `dev_*` subagent for each phase.
- Pass compact context and raw user feedback to subagents.
- Present `spec.md` and `plan.md` to the user for review every time.
- Enforce gates before implementation.
- Route revision requests to the subagent that owns the artifact.
- Summarize final results.

The parent must not do substantial exploration, specification, planning, architecture review, implementation, or code review itself.

## Required Flow

1. **Intake**: Parent writes a task brief.
2. **Exploration**: `dev_explorer` maps relevant files, symbols, tests, and risks.
3. **Spec**: `dev_specifier` writes `spec.md`.
4. **Spec review**: Parent outputs `spec.md` and waits for user review.
5. **Plan**: `dev_planner` writes `plan.md` from the approved spec.
6. **Plan review**: Parent outputs `plan.md` and waits for user review.
7. **Architecture review**: `dev_architect` reviews the approved plan.
8. **Implementation**: `dev_implementer` changes code from the approved spec and plan.
9. **Review**: `dev_reviewer` reviews the diff against the request, spec, plan, and tests.
10. **Revision loop**: Parent routes each revision to the owning subagent until complete.

Move backward when a later phase invalidates an earlier artifact:

- Spec issue: return to `dev_specifier`.
- Plan or file strategy issue: return to `dev_planner`.
- Design issue: return to `dev_architect`.
- Code or test issue: return to `dev_implementer`.
- Review issue: return to the subagent named by the reviewer.

## Required Artifacts

For every non-trivial task, maintain these reviewable artifacts:

- `task-brief.md`
- `exploration.md`
- `spec.md`
- `plan.md`
- `architecture-review.md`
- `implementation-notes.md`
- `review.md`

If the repository should not keep workflow documents, use a temporary task directory and summarize the final artifact paths.

`spec.md` and `plan.md` are hard gates:

- Do not skip them.
- Do not replace them with a short summary.
- Do not implement before the user has reviewed them.
- If an artifact is too long for one response, split it across messages before asking for review.

## User Feedback Routing

When the user replies during an active development workflow:

- Forward spec feedback to `dev_specifier`.
- Forward plan feedback to `dev_planner`.
- Forward design feedback to `dev_architect`.
- Forward implementation feedback to `dev_implementer`.
- Forward review feedback to `dev_reviewer` or to the subagent named by the review finding.

The parent must pass the user's raw message, the current artifact, and the phase goal to the subagent. The parent must not rewrite the artifact from its own judgment.

Keep the same phase open until the owning subagent returns an accepted result. If the runtime cannot keep a subagent process open, start the same subagent again with the latest artifact and state that it is continuing the same phase.

## Human Decision Routing

When a subagent returns `HUMAN_DECISION_REQUIRED`, the parent asks the user and then sends the user's answer back to the same subagent.

The parent must not answer on behalf of the user when the decision affects behavior, compatibility, data, security, architecture, or domain language.

Each question must have its own context:

```md
## Question N: <short title>

Context:
<facts that make this question necessary>

Why this matters:
<what changes depending on the answer>

Decision needed:
<the exact choice the user must make>

Recommendation:
<subagent recommendation, if any>
```

## Task Capsule

Pass subagents compact context in this shape:

```md
# Task Capsule

## Goal

## Phase

## Current artifact

## Inputs

## Relevant files or search targets

## User feedback

## Constraints

## Required output

## Stop conditions
```

## Agent Result

Require subagents to return this shape:

```md
# Agent Result

## Verdict

## Artifact

## Summary

## Evidence

## Decisions

## Open questions

## Next recommendation
```

Allowed verdicts depend on the subagent.

## Intake Brief

The parent creates the task brief before delegation:

```md
# Task Brief

## Original request

## Goal

## Known constraints

## Unknowns

## Expected code changes

## Suspected affected areas

## Risk level

## Human review checkpoints
```

## Final Response

At completion, report:

- Spec reviewed.
- Plan reviewed.
- Code implemented.
- Tests or validation run.
- Review result.
- Remaining risks or follow-ups.
