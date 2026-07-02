# CLAUDE.md

How to collaborate with me and write code that fits: scope work before building, keep it simple, and change only what's needed. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't hide confusion. Surface tradeoffs. Default to acting on stated assumptions.**

**Interview mode** triggers when any of these hold:
- The task spans multiple files or systems.
- The goal is stated as an outcome ("build X", "redesign Y") rather than a specific change ("rename this", "fix this error").
- A wrong guess would waste significant work or be hard to reverse.

In interview mode, question me before writing any code — one question at a time, using `AskUserQuestion`. Don't summarize, plan, or move forward until we've reached clarity together:
- Let my answers spawn the next question — if an answer raises something new, pull on that thread.
- Surface what I forgot to mention and guide me toward what I don't know I don't know.
- Challenge vague language. Make me define fuzzy terms.
- Explore edge cases, failure modes, and second-order consequences.
- Ask about unstated constraints: timeline, scope, dependencies, technical limits, who/what it affects.
- Push back on my assumptions — including whether this is even the right problem to solve.
- Only once you've run out of unknowns do you propose a plan (see Goal-Driven Execution).

Otherwise, proceed on stated assumptions.

Before implementing:
- State your assumptions explicitly, then proceed. Ask only when a wrong guess is expensive or hard to reverse.
- If multiple interpretations exist, name them - then pick the most likely and say which you chose.
- If a simpler approach exists, say so. Push back when warranted.
- If something is genuinely blocking, stop and name what's confusing. Don't turn into a clarification machine.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- Start with the simplest thing that works. Add complexity only when a concrete need forces it, not up front.
- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Readable Code

**Names carry the meaning. Comment only what names can't. Optimize for the reviewer.**

- Aim to make changes easy to review: keep diffs focused, group related edits, and don't mix refactors with behavior changes in the same pass.
- Name variables and functions for what they are/do, not their type or a shorthand. A reader should understand intent without a comment.
- Follow the idioms of the language and the surrounding file. Idiomatic beats clever.
- Comment only what isn't obvious from the code: the *why*, a non-obvious constraint, a workaround, a gotcha.
- Don't comment what the code already says. No restating the line above, no section-header noise, no dead-code comments.
- File/class header comments only where they earn their place: complex files, non-obvious responsibilities, or tricky invariants. Skip them on small or self-explanatory files.

## 4. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 5. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals. Prefer a test when the code is testable; otherwise pick a concrete observable check:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"
- Config/dotfiles change → "Reload the config and confirm the expected behavior (e.g. keybinding fires, prompt renders)"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 6. Ruby Practices

Sections 2–4 apply to all code; these are the Ruby-specific specifics.

- Keep classes small and single-responsibility. When a class does several unrelated things, split the independent pieces into their own classes or modules — a class name should describe one job.
- Prefer short methods that do one thing. If a method needs a comment to explain its sections, those sections probably want to be their own methods.
- Reach for enumerable methods (`map`, `select`, `each_with_object`, etc.) over manual loops, guard clauses over nested conditionals, and `&.`, `||=`, and keyword arguments where they read naturally.
- Favor plain objects and composition over inheritance and metaprogramming.

---

**Before finishing, sanity-check against these:** every changed line traces to the request, the interview happened before coding when the task warranted it, the solution is the simplest that works, and no code was touched that didn't need to be.
