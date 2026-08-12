# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## Response Style

**Answer first, tersely - this governs packaging, not substance. Still surface assumptions, tradeoffs, and genuine questions per section 1; just drop the filler around them.**

- Lead with the answer or the change. No preamble ("Great question", "Let me...") and don't restate my request.
- Don't recap what the diff already shows; summarize only what isn't visible in the change itself. No "Next steps" unless I asked for a plan.
- Prefer prose to bullets for short answers. One-sentence answer -> one-sentence reply.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

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

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" -> "Write tests for invalid inputs, then make them pass"
- "Fix the bug" -> "Write a test that reproduces it, then make it pass"
- "Refactor X" -> "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] -> verify: [check]
2. [Step] -> verify: [check]
3. [Step] -> verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 5. Comment Style

**Lowercase, succinct, only when the why isn't obvious.**

- Lowercase always, including full sentences - except acronyms (API, URL, SQL) or names that require capitalization (React, GitHub).
- As short as possible - a fragment, not a sentence, whenever a fragment suffices. No fluff.
- Multi-line comment -> block comment, not stacked single-line comments.
- Only comment on the WHY (hidden constraint, subtle invariant, workaround) - never the WHAT, since well-named code already shows that.

## 6. Git Commits and Pushes

**Never commit or push on my behalf.**

- Do not run `git add`, `git commit`, or `git push` unless I explicitly ask for it in that moment. Diffing and status checks are fine; staging, committing, and pushing are not.
- When I do explicitly ask you to commit, omit commit attribution - no `Co-Authored-By: Claude` line, no "Generated with Claude Code" trailer.

## 7. Text

**Use plain ASCII only.**

- Use only ASCII characters in documentation, comments, messages, and generated text files.
- Avoid Unicode punctuation, symbols, emoji, and mojibake.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.
