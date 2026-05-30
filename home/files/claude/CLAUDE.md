## Ambiguity Resolution

- Inspect relevant context first (files, code, docs, config, tests, git state) to try to resolve ambiguity. Inspecting is allowed and is not authorization to plan, edit, test, or otherwise act.
- If any ambiguity remains after inspecting, STOP and ask clarifying questions before planning, editing, testing, choosing a fallback, or inferring preferences.
- No assumption is too small to clarify if it affects scope, behavior, target files, dependency/library choice, data format, error handling, ordering, validation, or ownership of generated files.
- A request to draft a plan or TODO list does not waive this. If planning would require assumptions, ask first.
- Keep asking follow-ups until we share a complete, explicit understanding of what will be done.

## Change Authorization

- Never modify code unless I explicitly and unambiguously authorize changes — this is absolute and applies even to trivial or obvious one-line fixes.
- Requests for opinions, explanations, inspections, diffs, or plans are NOT authorization to edit.
- When changes are needed, present a brief reviewable plan (what changes, which files/areas, scope decisions, validation approach) and wait for explicit approval before editing.
- If authorization is unclear, ask before touching anything.

## Plan doc style

- Present every implementation plan with these three sections:
  - **What files will be changed** — each file or area touched.
  - **What the change will be** — the change, described per file.
  - **What test cases will be written** — the tests to add or run to validate the change.

## Design (KISS)

- Optimize for the simplest correct final design, not the smallest diff.
- Prefer rewrites over incremental patches when they yield a simpler result. Don't preserve existing structure or abstractions unless they're still the simplest solution.
- No speculative fallbacks, compatibility layers, indirection, extensibility hooks, or future-proofing unless explicitly required.
- Decide the target shape first, then implement only what is necessary to reach it.
- Fix problems at the root cause, not with surface-level patches.
- Do not fix unrelated bugs or broken tests; mention them in the final message instead.

## Code Style

- No inline comments unless I explicitly request them.
- No one-letter variable names unless I explicitly request them.
- Never add copyright or license headers unless I request them.

## Tests

- Assert whole values rather than field-by-field when practical.
- Keep tests necessary and sufficient; avoid trivial tests.
- Tests must fail on unexpected output — do not swallow or handle errors inside test code.
- Unit tests exercise only the target function with explicit inputs.
- Don't add tests to a codebase that has none, and don't introduce a formatter or test framework that isn't already configured.
- Start validation narrow (the code you changed), then broaden as confidence grows.

## Communication

- Don't tailor opinions to please me. Give neutral, evidence-based views, including disagreement when warranted.
- State uncertainty clearly instead of forcing confidence or agreement.
