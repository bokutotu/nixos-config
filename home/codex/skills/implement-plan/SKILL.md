---
name: implement-plan
description: Implement an approved plan safely. Use when Codex has a spec and implementation plan, must edit files in build order, keep each feature commit-sized, run focused validation, or stop when the plan is ambiguous.
---

# Implement Plan

## Phase contract

Implement the approved plan.
Do not invent a new spec or plan during implementation.

If the plan is ambiguous, return to `write-plan`.
If the target contract is ambiguous, return to `write-spec`.

Treat each planned feature as a commit-sized unit.
Do not commit changes unless the user explicitly asks.

## Work sequence

1. Read the spec and plan.
2. Confirm the build order.
3. Implement one feature at a time.
4. Do not start the next feature until the current feature is complete.
5. Run the narrowest useful validation for the changed code.
6. Report changed files, validation, and any remaining blockers.

Modify only what the approved plan requires.
Do not fix unrelated bugs or rewrite unrelated code.

## Naming

Decide a name from what the thing does, not how it is built.
A reader must be able to guess the behavior from the name, type signature, and location alone.

How to decide:

1. State in one short phrase what it does.
2. Drop words that the type signature or module path already tells the reader.
3. Keep it short and unique. If two names could be confused, make the difference explicit.

Never use names that restate the mechanism or add vague roles:

- `GetUserFilteredByLoginEmail`
- `UserDataManagerHelper`

Prefer names that state the result:

- `GetEmailLoginUser`
- `parseSurface`

Rules:

- Name by intent, never by layer. Avoid `util`, `manager`, `helper`, and `data`.
- Use the same word for the same concept everywhere.
- A type signature plus a good name should make a doc comment unnecessary.

## Tests

Compare whole values, not fields one by one.

Build the expected object in the test code, run the target, then assert that the two objects are equal in one comparison.

Bad:

```text
result = parseSurface(input)
assert result.name == "x"
assert result.kind == Lam
assert result.body == ...
```

Good:

```text
expected = Term{ name = "x", kind = Lam, body = ... }
result   = parseSurface(input)
assert result == expected
```

Rules:

- Construct the expected value explicitly in the test.
- Do not derive the expected value from the code under test.
- Test one behavior per test.
- Let the test name state the behavior.
- If equality needs custom logic, define it on the type, not in the test.
