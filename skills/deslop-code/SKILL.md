---
name: deslop-code
description: Review a Git change set for behavior-preserving simplifications, weak new tests, and low-value comments or technical prose. Use when asked to deslop or polish code, or when a preflight review delegates this focused pass. Do not use for a general correctness or security review.
---

# Deslop code

Find concrete ways to make the requested change easier to read and maintain. A clean result is valid. Do not invent findings to fill a category or prefer fewer lines at the cost of a clearer design.

Use [SlopCodeBench](https://www.scbench.ai/) as the design lens. Judge whether the change can absorb the next plausible requirement without accumulating dead branches, duplicated paths, wrappers, or broad rewrites. Its metrics are prompts for inspection, not targets. More lines, complexity, nesting, churn, clones, single-use functions, or trivial wrappers matter only when the changed code provides evidence that they make extension harder.

Use [Qlty](https://qlty.sh/) as an optional source of static evidence. If the repository already has `.qlty/qlty.toml` and `qlty` is on `PATH`, run read-only checks against the review scope:

- Run `qlty check --no-fix` for lint findings. Pass explicit paths when the review scope is narrower than the branch diff.
- Run `qlty smells` on changed production code for duplication, complexity, and deep nesting. Pass explicit paths for a narrow review.
- Run `qlty metrics --functions <paths>` only when function-level size or complexity would help test a specific suspicion.

Do not install Qlty, run `qlty init`, change its configuration, or apply Qlty fixes unless the user asks. Qlty may install missing plugins and runtimes before analysis. Obtain any required approval before allowing those downloads. Treat Qlty output as a lead. Confirm each reported issue in the code before including it as a finding. If Qlty is unavailable or unconfigured, continue the manual review and state that the optional checks did not run.

## Scope

- If another review delegates this pass, use its exact change set and return findings to that reviewer. Do not rediscover the branch base or edit files.
- Otherwise, use the diff or paths the user names. If none are named, inspect Git status and the current branch to identify the working change. Ask for a base only when the intended comparison remains ambiguous.
- Read each included changed file in full. Inspect direct callers, existing helpers, and nearby tests when needed to prove a suggestion. Keep proposals tied to the change under review.
- Exclude generated output after confirming that it is generated. Change its source if an approved fix requires it.

## Review passes

Run these passes in order. Report `no findings` for a pass when nothing warrants a change.

1. **Production code:** Look for behavior already provided by the repository, standard library, or an installed dependency. Check for copied branches, redundant guards or work, catch-all error handling, needless wrappers, and flexibility without a current use. Prefer keeping one cohesive operation together over extracting helpers only to shorten a function. A proposal must preserve the observable contract, including errors and boundary behavior.
2. **New tests:** Review tests added by this change. For each, ask which plausible bug it would catch. Flag tautologies, tests that mock away the behavior under test, implementation mirrors, and repeated cases that can share a table while retaining distinct coverage. Protect pre-existing regression tests. Do not weaken assertions or delete a meaningful case to reduce test count.
3. **Comments and technical prose:** Remove comments that narrate the code, obsolete history, and filler in changed documentation. Keep public contracts, non-obvious reasons, safety constraints, and useful examples. Preserve the author's voice and exact meaning. Do not turn a comment suggestion into a code change.

Keep functional changes separate from polish. If a likely bug appears, identify it as a correctness finding with its impact and evidence. Do not present a behavior change as simplification.

## Findings and fixes

For each finding, give the file and line, the smallest proposed edit, why it improves the current code, the behavior or coverage it preserves, and one focused check. If the evidence is uncertain or the alternative is only a style preference, omit the finding. Report the passes that found nothing.

When delegated, remain read-only. In a standalone request, propose changes unless the user asks you to apply them. If asked to apply them, make only the supported edits, run focused checks, and inspect the resulting diff. Do not commit, push, or modify a pull request without a separate explicit request.
