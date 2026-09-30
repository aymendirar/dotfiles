---
name: preflight-engineering-review
description: Run a multi-subagent engineering and polish review only when the user explicitly invokes `$preflight-engineering-review`. Inspect the intended Git diff, fix major findings, and continue with any Git write authorized by the invocation without requiring follow-up approval. Never activate for an ordinary commit, push, or pull-request request.
---

# Preflight Engineering Review

Use this workflow only when the user explicitly invokes `$preflight-engineering-review`. Do not activate it merely because the user asks to commit, push, publish, or update a PR.

Pause any Git write named in the explicit invocation until this review completes. The invocation authorizes the review, the smallest safe fixes for major findings, and any Git write it explicitly requests. Do not require follow-up approval after the review or after an authorized fix. If the invocation requests only a review, fix major findings and report the result without performing a Git write.

## Establish the review scope

1. Read the applicable repository instructions and inspect `git status`, the current branch, its upstream, and the relevant staged, unstaged, untracked, and commit-range diffs.
2. Determine exactly what would be committed or pushed. If the requested write's contents are materially ambiguous, resolve that ambiguity before reviewing.
3. Record the reviewed state, including `HEAD`, the intended base or upstream, status, and the full intended diff. A material change after review invalidates the result.
4. Tell the user that the preflight review is running before the requested write.

Do not stage, commit, push, create or update a PR, or mutate remote state during this phase.

## Run independent reviews

Launch at least three read-only subagents in parallel. Give each reviewer the repository path, applicable instructions, reviewed base and head, and raw diff scope. Do not give them another reviewer's conclusions. Adapt the roles to the change when useful, while covering these concerns:

- correctness and regressions: behavior, edge cases, API or data-contract compatibility, concurrency, and failure handling;
- verification and maintainability: missing tests, test quality, readability, repository conventions, and unnecessary complexity. This reviewer also runs the self-contained polish pass below;
- security and operations: trust boundaries, authorization, secrets or privacy, dependency and supply-chain risk, performance, observability, rollout, and reversibility.

Use Google's [What to look for in a code review](https://google.github.io/eng-practices/review/reviewer/looking-for.html) as the shared review standard. Start with the change's design, intended behavior, user impact, and fit within the system before reviewing line-level details. Review every human-written changed line and enough surrounding code to understand it. Check that tests can fail for relevant defects and names communicate purpose. Confirm that comments explain non-obvious reasons and documentation matches changed behavior. Apply repository conventions. Exercise user-facing behavior when practical. Reason explicitly about races and deadlocks when the change adds concurrency. Treat a personal style preference as non-blocking unless a repository rule supports it.

Require each reviewer to inspect evidence directly and return only actionable findings. Each finding must include severity, file and line when available, concrete impact, evidence or reproduction, and the smallest practical fix. A reviewer with no findings must say so explicitly.

For the polish pass, read each changed source, test, and documentation file in full. Run three checks:

1. Find production code that can reuse an existing helper or lose copied branches, redundant guards or work, needless wrappers, or speculative flexibility without changing behavior.
2. Inspect only newly added tests for assertions that cannot catch a plausible regression, implementation mirrors, and repeated cases that can share a table without losing coverage. Protect pre-existing regression tests.
3. Find narration, obsolete history, and filler in comments or changed technical prose. Preserve public contracts, non-obvious rationale, and the author's meaning.

Report only concrete behavior-preserving improvements with a focused check. Keep correctness findings separate and say when a polish check has no findings.

If subagent delegation is unavailable or a reviewer fails before producing a result, report that the preflight is incomplete and do not perform the write. Do not silently replace an independent review with another primary-agent pass.

The primary agent must also inspect the complete diff and run the narrowest useful non-destructive checks. Do not silently update snapshots, fixtures, or baselines. Ask for any permission required by the environment rather than skipping an important check.

## Consolidate and remediate

Wait for every reviewer. Verify their claims against the code, deduplicate overlapping findings, and discard unsupported speculation. Rank retained findings as:

- P0: unsafe to ship; immediate severe impact;
- P1: likely correctness, security, data-loss, or major operational failure;
- P2: meaningful defect, regression risk, or missing coverage;
- P3: worthwhile low-risk improvement.

Use engineering judgment to decide the gate without asking the user to approve the report. Automatically fix each P0 or P1 finding when a clear, scoped, and safe fix is available. Prefer the smallest practical fix and do not change unrelated behavior. P2 or P3 findings do not automatically block the write or require a fix.

Treat polish findings as P3 unless they reveal a substantive defect. Report them without blocking the write. If the invocation explicitly asks for polish fixes, apply only clear, scoped, behavior-preserving changes, then run focused checks and repeat review of the affected code.

After fixing a major finding, validate the fix and run a focused repeat review of the affected concerns. Continue until no P0 or P1 finding remains or a genuine blocker requires the user. Do not require another user response solely because an authorized fix changed the diff.

Block a requested write only when the review is incomplete, the reviewed state remains unsafe, or a fix requires a product decision, material scope expansion, or authority not granted by the invocation. Explain the blocker and the decision or authorization needed.

Prepare one concise final report with:

1. the reviewed scope and checks run;
2. consolidated findings in priority order, with locations and fixes;
3. disagreements, uncertainty, and reviewers that found nothing;
4. the disposition of each retained finding and the recommended path forward;
5. `Gate status: passed.` or `Gate status: blocked: <reason>.`

## Perform the authorized write

If the gate passes, recheck that the reviewed state is unchanged, run any final required validation, and perform only the Git write explicitly authorized by the invocation. A commit request does not authorize a push, and a push request does not authorize committing unrelated changes.

If the reviewed state changes for another reason, explain that the review is stale and rerun it before writing. Never claim the gate passed merely because subagents completed.
