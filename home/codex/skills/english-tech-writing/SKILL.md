---
name: english-tech-writing
description: English technical prose and book-manuscript style guide. Use when writing, editing, or reviewing English technical chapters, articles, documentation, explanations, drafts, or rewrites, especially when the user wants rigorous argument structure, low reader load, concrete headings, non-LLM-ish phrasing, and concise prose.
---

# English Technical Writing Standards

When writing or revising English technical prose, follow these standards.
They target chapters, articles, explanations, and documentation where the reader must follow both technical facts and an argument.

## Formatting

- Put code, diffs, logs, command output, and configuration fragments in fenced code blocks.
- Put supplementary details that interrupt the main argument in footnotes, not in the paragraph body.
- Use bullet lists for definitions and classifications when a prose paragraph would hide the structure.
- Write definition lists as `**Term**: explanation`.
- When introducing a term that is defined immediately, mark the first mention with italics or bold.
  Use the term plainly after that.
- Do not put ordinary later mentions of a term in quotation marks.
  Reserve quotation marks for quoted text, names under discussion, or wording that must be inspected exactly.

## Paragraphs And Argument

Use paragraph writing as the default.
A paragraph is one step in the argument.
Readers must be able to follow the logic paragraph by paragraph.

- Put only one topic in a paragraph.
  Split long paragraphs that mix investigation, evidence, evaluation, and conclusion.
- Make the first sentence identify what the paragraph is about.
- Show the relationship to the previous paragraph near the start when the relationship matters: `therefore`, `however`, `for example`, `this matters because`.
- Move the argument in one direction.
  Do not state the conclusion, handle objections, and then restate the same conclusion.
  Handle objections and doubts first, then state the conclusion once.
- Do not interrupt the strongest part of an example with an apology for the example.
  If the example may look artificial, handle that concern at the start of the next section or paragraph.
- When rejecting a likely misreading, write the mistaken claim explicitly and then give the real reason.
  Prefer `This does not mean "X." It means Y because Z.`
- When writing `not A but B`, add the reason for rejecting A.
  A counterfactual often exposes the reason: `If A were the cause, changing A would have changed the result.`
- In concessions, acknowledge only the fact that must be acknowledged.
  Do not let the author's voice assert a causal story that will be corrected later.
- Do not reveal key numbers or decisive facts before the paragraph where they are meant to matter.
- Put forward references after a local argument has closed.
  Do not break an unfinished argument with `the next chapter explains this`.

## Rigor

Leave no easy objection in the logic.
After drafting, inspect the text from the reader's side.

- Do not turn uncertainty into certainty mechanically.
  Keep `may`, `might`, `likely`, `appears to`, and `suggests` when the sentence describes an unverified fact, a reader's possible doubt, a log-based inference, or a counterfactual.
- Remove weak modal language only when the text already proves the claim.
  Bad: changing `may keep retrying` to `keeps retrying` without evidence.
  Good: `The logs suggest that the client may keep retrying.`
- Do not group distinct things under `the same problem`.
  Separate different decisions, causes, failures, or abstractions before naming the shared pattern.
- Do not reduce an event with multiple causes to one cause.
  If an incident combines a missing contract and a hidden state transition, explain which tool addresses which part.
- Keep definitions and classifications stable across sections.
  Do not classify an action as `a human decision` in one section and `team consensus` in another unless the distinction is explained.
- When claiming causality, state the mechanism.
  Bad: `Splitting by process makes changes spread everywhere.`
  Good: `Each process shares the same data representation, so changing that representation affects every process boundary.`
- Do not promise detection, prevention, guarantees, or correctness without conditions.
  Say what must be true for the claim to hold.
- Check that each example supports the full scope of the claim.
  If the example only supports part of the claim, narrow the claim.
- Do not leave unresolved forward references.
  If the text says a later section handles a point, that later section must handle it.
- After `however`, `although`, `except`, or `but`, continue the argument.
  Do not end a paragraph with a dangling qualification.
- Define the central term of a section before using it as the basis for the section's argument.
- When naming a shared abstraction, first show that the cases reduce to the same underlying structure.

## Reader Load

Treat the reader's memory and attention as limited resources.

- Do not introduce filenames, function names, identifiers, timestamps, HTTP status codes, coverage values, or metric names unless they are used later.
  Use a general noun such as `the schema file`, `the billing helper`, or `the request log` when the exact name adds nothing.
- When an abstract phrase could refer to several things, identify the referent immediately in parentheses or a short appositive.
- When adding a new example, say what differs from the previous example and why the new one is needed.
- Do not pack chapter openings or section introductions with details that will not matter to the example or argument.
- In examples, remove decorative precision but keep necessary concrete facts.
  Decorative precision includes exact times, incidental status codes, and named files that never return.
- Do not make the reader remember a distinction before the text uses it.
  Introduce distinctions near the point where they start doing work.

## Voice And Terms

- Prefer active voice when the actor matters.
  Bad: `The cause was identified.`
  Good: `The reviewer traced the failure to the retry loop.`
- Do not add fictional persona labels that do no work, such as `a junior engineer` or `a busy architect`.
- Choose concrete subjects.
  Avoid broad nouns such as `AI`, `the tool`, `the system`, or `the platform` when a more precise actor is known.
- After introducing a technical term, keep using that term.
  Do not retreat to vague nouns such as `context`, `stuff`, `things`, or `the tool`.
- Use established technical terms.
  Do not swap in a near-synonym because it sounds more formal.
- Do not use technical-sounding words outside their technical role.
  If `pipeline`, `invariant`, `contract`, or `state` is not doing technical work, use a plainer word.

## Rhetoric

Rhetoric is allowed only where it earns its cost.
Most technical prose should state the claim directly.

- Do not use suspense phrases such as `something deeper is hiding here` unless the section is deliberately building tension.
- Do not overuse short standalone punchline paragraphs.
  Use them only at a genuine turning point.
- Use bold emphasis sparingly.
  Prefer sentence order and paragraph structure over typographic emphasis.
- Do not dramatize a transition when a factual sentence is enough.
- Do not inflate risk by listing consequences that the argument does not need.
- Do not announce importance with phrases such as `the key point is` or `what matters is`.
  State the point.
- Do not overuse symmetrical punchlines such as `It was not A. It was B.`
  Use that form only when the contrast is the argument.
- Do not use metaphors whose referent is not precise.
  Replace them with the plain action or relationship.

## Non-LLM-ish English

Avoid phrases that create the feeling of polished writing without adding a claim.
Many LLM-ish expressions are not wrong in isolation.
They become a problem when they replace evidence, mechanism, or concrete action.

- Delete empty framing phrases: `it is important to note`, `it is worth noting`, `in this section we will explore`, `this article delves into`, `in today's landscape`, `in the world of`.
- Delete fake synthesis phrases when no synthesis follows: `putting it all together`, `at the end of the day`, `when all is said and done`, `in conclusion`, `to summarize`.
- Replace vague praise with a claim: `robust`, `powerful`, `seamless`, `comprehensive`, `cutting-edge`, `game-changing`, `innovative`, `scalable`.
- Avoid decorative verbs that do not say what the text does: `delve into`, `explore`, `leverage`, `unlock`, `empower`, `streamline`, `revolutionize`, `illuminate`.
- Avoid prestige nouns and metaphors that blur the subject: `realm`, `landscape`, `tapestry`, `journey`, `ecosystem`, `paradigm`.
- Avoid filler intensifiers unless they change the claim: `very`, `extremely`, `significantly`, `remarkably`, `notably`.
- Keep uncertainty words only when they express real uncertainty.
  Remove `may`, `might`, `could`, and `arguably` when they merely soften a proven claim.
- Rewrite LLM-ish prose by naming the actor, action, object, and condition.
  Bad: `This section delves into how retries can unlock more robust payment flows.`
  Good: `Retries make payment flows safer only when the idempotency key prevents duplicate charges.`

## Redundancy

Leave as little waste as possible.

- State one claim once.
  Do not repeat it with different words in the next paragraph.
- If adjacent sections make the same point from slightly different angles, merge them.
- Do not summarize an example immediately after describing it.
  Add only the sentence that interprets the example.
- Combine parallel facts that play the same logical role.
  Signal that role at the start of the sentence.
- Omit intermediate reasoning that the reader can supply without risk.
- If several sentences can become one precise sentence, keep the precise sentence.
- Do not add bridge sentences that only say a transition is happening.
- Do not stage an imaginary dialogue with the reader.
  State the objection or question directly when it matters.
- Do not defend the author's position with phrases such as `this book does not deny that`.
  State the fact or limit directly.
- Do not introduce concepts, document names, or labels before the text needs them.
- Use strong, specific verbs when the evidence supports them.
  Keep weak verbs only for uncertainty, possibility, hypothesis, or deliberate softening.

## Headings

Headings must identify the specific question, object, or task of the section.
They are navigation, not decoration.

- Do not use generic headings: `Overview`, `Introduction`, `Deep dive`, `Putting it all together`, `Key takeaways`, `Discussion`, `Notes`, `Details`.
- Use a task phrase for procedural sections: `Create the ledger entry`, `Validate the migration`, `Recover from a stale lock`.
- Use a noun phrase or question for conceptual sections: `The invariant that prevents duplicate charges`, `Why retries duplicate payments`, `Where ownership can be lost`.
- Do not use a heading that gives away the section's conclusion as a slogan.
- Do not use headings that only describe the act of reading or returning: `Back to the example`, `Reading the code again`.
- Avoid heading punctuation that signals the heading is trying to carry two ideas.
  Split the section or choose the main idea.
- Keep heading levels hierarchical.
  Do not skip from `##` to `####`.
- Prefer sentence case.
  Use title case only when the surrounding publication requires it.

## Honesty To The Reader

- If an example may look artificial, acknowledge that risk and give a short reason why the situation is realistic.
- Ground that reason in common engineering experience, not authorial insistence.
  Prefer `This failure mode is common in retrying clients` over `This is a realistic example`.
- Do not write as if a fact was checked when it was only inferred.
- Do not hide a limitation behind smooth prose.
  State the condition under which the argument stops applying.
