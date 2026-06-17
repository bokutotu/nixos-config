---
name: development
description: Orchestrate non-trivial software development work through intake, exploration, compact reviewable spec, compact reviewable plan or split proposal, architecture review, implementation, code review, and revision. Use for coding tasks, refactors, bug fixes, feature work, test design, or architecture-sensitive changes. The parent agent must keep the main context as an orchestrator, use the dev_* subagents for phase work, treat subagent artifact files as the source of truth, output spec.md and plan.md from those files for user review before implementation, and route user feedback or human-decision answers back to the owning subagent.
---

# Development Skill

Use this skill to keep development work explicit, reviewable, compact, and delegated.

The parent agent is an orchestrator. After intake, phase-specific rules belong to subagents, not the parent.

## Parent Responsibilities

- Create the initial task brief.
- Create the task artifact directory.
- Pass artifact paths and raw user feedback file paths to subagents.
- Present the full `spec.md` and `plan.md` file contents to the user for review every time.
- Enforce gates before implementation.
- Route revision requests to the subagent that owns the artifact.
- Record any user-specified subagent reasoning effort and apply it when spawning matching subagents.
- Summarize final results.

The parent must not do substantial exploration, specification, planning, architecture review, implementation, or code review itself.

## File-Based Handoff Protocol

Subagent artifact files are the source of truth. Parent-agent messages and subagent chat responses are only a control plane.

The parent message to a subagent may contain:

- Phase name.
- Task directory path.
- Input artifact paths.
- Output artifact path.
- Raw user feedback file path, when relevant.
- Stop conditions.

The parent message to a subagent must not be treated as authoritative for prior phase content. The parent must not summarize prior artifacts for the next subagent. The parent must pass file paths instead.

Required file rules:

- The parent creates one task artifact directory before exploration.
- The parent writes the original request and known constraints to `task-brief.md`.
- The parent writes raw user feedback to files such as `feedback/spec-review-001.md`.
- Each subagent reads required input artifacts directly from disk.
- Each subagent writes its owned artifact directly to the requested output path before returning any non-`BLOCKED` verdict.
- If a subagent cannot read required input files or write its output file, it must return `BLOCKED`.
- The parent must not synthesize, rewrite, repair, or merge a subagent-owned artifact from its own judgment.
- `spec.md` and `plan.md` must be shown to the user from the files, not from parent summaries or path-only references.
- When asking for spec or plan review, the parent outputs the full current file contents before asking for approval.

## Required Flow

**YOU MUST FOLLOW THIS FLOW. NEVER SKIP**
**YOU MUST ALWAYS SPAWN SUBAGENTS FOR EACH FLOW**

1. **Intake**: Parent creates a task artifact directory and writes `task-brief.md`.
2. **Exploration**: `dev_explorer` reads `task-brief.md` and writes `exploration.md`.
3. **Spec**: `dev_specifier` reads `task-brief.md` and `exploration.md`, then writes `spec.md`.
4. **Spec review**: Parent reads `spec.md` from disk, outputs the full file contents, and waits for user review.
5. **Plan**: `dev_planner` reads the approved `spec.md` and `exploration.md`, then writes `plan.md` as an implementation plan or split proposal.
6. **Plan review**: Parent reads `plan.md` from disk, outputs the full file contents, and waits for user review. If the planner returns `SPLIT_REQUIRED`, do not implement; ask the user which split task to run next.
7. **Architecture review**: `dev_architect` reads the approved artifacts and writes `architecture-review.md`.
8. **Implementation**: `dev_implementer` reads the approved artifacts, changes code, and writes `implementation-notes.md`.
9. **Review**: `dev_reviewer` reads the approved artifacts and implementation notes, then writes `review.md`.
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
- Do not replace them with path-only references.
- Do not ask the user for review until their full file contents have been output.
- Do not implement before the user has reviewed them.
## User Feedback Routing

When the user replies during an active development workflow:

- Forward spec feedback to `dev_specifier`.
- Forward plan feedback to `dev_planner`.
- Forward design feedback to `dev_architect`.
- Forward implementation feedback to `dev_implementer`.
- Forward review feedback to `dev_reviewer` or to the subagent named by the review finding.

The parent must pass the user's raw message file path, current artifact paths, and the phase goal to the subagent. The parent must not rewrite the artifact from its own judgment.

The parent must write the user's raw message to a feedback file and pass the feedback file path to the owning subagent. The owning subagent must read the feedback file and rewrite its owned artifact file when a revision is needed.

Keep the same phase open until the owning subagent returns an accepted result. If the runtime cannot keep a subagent process open, start the same subagent again with the latest artifact and state that it is continuing the same phase.

## Human Decision Routing

When a subagent returns `HUMAN_DECISION_REQUIRED`, the parent asks the user and then sends the user's answer back to the same subagent.

The parent must not answer on behalf of the user when the decision affects behavior, compatibility, data, security, architecture, or domain language.

The parent forwards the subagent-provided question blocks to the user without rewriting, summarizing, answering, or changing their order.

The parent writes the user's raw answer to a feedback file and sends that feedback file path back to the same subagent.

## Task Capsule Handoff

Pass subagents compact context with these parent-owned fields:

- Goal
- Phase
- Subagent reasoning effort
- Current artifact paths
- Task directory
- Input artifact paths
- Output artifact path
- Inputs
- Relevant files or search targets
- Raw user feedback path
- Constraints
- Required output
- Stop conditions

## Task Brief Intake

The parent creates `task-brief.md` before delegation with these parent-owned fields:

- Original request
- Goal
- Known constraints
- Unknowns
- Expected code changes
- Suspected affected areas
- Risk level
- Subagent reasoning effort
- Human review checkpoints

## Final Response

At completion, report:

- Spec reviewed.
- Plan reviewed.
- Code implemented.
- Tests or validation run.
- Review result.
- Remaining risks or follow-ups.
