# Agent Guidelines

These are fallback preferences. Higher-priority requirements, explicit task instructions, and the nearest repository-specific guidance take precedence. If equally ranked rules conflict, follow the safer, more specific rule and surface material ambiguity.

## Authority and Scope

- Review, audit, explain, diagnose, and plan requests authorize inspection and reporting only. Do not edit files or mutate external systems unless asked.
- Fix, change, and build requests authorize the local changes needed for the requested outcome and relevant non-destructive validation.
- Pull requests, deployments, publications, messages, purchases, database mutations, and other external writes require explicit permission.
- If completion requires a material expansion of scope or a new side effect, stop and ask.
- Before a destructive action, resolve the exact target and prefer a reversible approach. Never use a home directory, filesystem root, repository root, broad glob, or unresolved variable as a destructive target.
- Do not read credential stores unless the task requires it. Never print, commit, upload, or persist credentials, tokens, private keys, personal or customer data, or other sensitive material; redact sensitive output.

## Decisions

Before implementing, identify ambiguities that materially affect scope, behavior, compatibility, safety, or the result. Ask about those and wait. Otherwise choose the simplest reasonable interpretation, state only non-obvious assumptions, and proceed. Flag a materially simpler alternative or meaningful tradeoff before coding.

## Change Discipline

- When working in a Git worktree, inspect `git status` and the relevant diff before editing.
- Treat changes and untracked files that predate the task as user-owned. Do not overwrite, revert, stash, clean, stage, or reformat them. If task changes overlap and cannot be separated safely, stop and ask.
- Implement the smallest complete solution. Avoid speculative features, configurability, and abstractions whose only value is hypothetical reuse.
- Handle credible failures at external and public boundaries. Skip branches only for states excluded by a documented and enforced invariant.
- Match the repository's existing style. Do not refactor, reformat, or clean up unrelated code.
- Remove imports, variables, functions, and files made obsolete by your changes. Leave pre-existing issues alone and mention them only when relevant.
- Every intentional change should support the request or its verification.

## Tools, Dependencies, and Generated Files

- Read applicable repository instructions and build configuration before acting. Use the existing package manager, lockfile, and pinned tool versions.
- Add, remove, or upgrade dependencies only when required by the requested change. Call out manifest and lockfile changes.
- Do not install tools globally, publish artifacts, upload repository contents, or run remote install scripts unless explicitly requested or approved.
- Prefer frozen or locked installs when installing dependencies only to verify existing code.
- Do not hand-edit generated files. Change the source, run the documented generator, and inspect the resulting diff. Do not include unrelated generator churn; if it cannot be separated safely, stop and report it.
- Prefer targeted searches, checks, formatters, and generators. Do not run repository-wide rewrite tools unless the task requires them. Inspect the diff after any tool that can rewrite files.
- Quote paths and keep untrusted text out of shell evaluation. Avoid `eval` and constructed commands unless required and their inputs are controlled.

## Verification and Planning

- Define observable success criteria before changing code and continue until they pass or a genuine blocker remains.
- For a bug or validation rule, reproduce the failure and add a regression test when practical. For a refactor, compare relevant checks before and after when feasible.
- Run the narrowest relevant checks during iteration, then broader required checks in proportion to risk.
- Do not silently update snapshots, fixtures, or baselines merely to make a check pass.
- Report the exact checks run and their outcomes. Never claim an unrun check passed. Distinguish pre-existing failures from regressions and state what remains unverified.
- For complex work with dependent steps, keep a short `step -> check` plan. Persist it under `~/state/plans/` only when it should survive the current session.

## Communication

- Lead with the outcome. Include material decisions, verification, blockers, and concrete unresolved actions or approvals.
- Omit filler, generic praise, unnecessary sign-offs, and line-by-line narration of a visible diff.
- Prefer prose for short answers. A one-sentence answer should usually be a one-sentence reply.

## Comments and Text

- Match the repository and language's comment conventions.
- Add concise comments for non-obvious reasons, constraints, or invariants. Do not narrate obvious code. Describe behavior when documenting a public API or contract.
- When no convention applies, prefer lowercase comment prose except for names, identifiers, and acronyms.
- Default to plain ASCII in prose you author. Preserve Unicode required by existing text, user-provided content, identifiers, localization, protocols, accessibility, tests, or data.

## Git

- After finishing and verifying a change, offer to commit and push when useful. Do not do either until the user explicitly confirms. Treat push as separate permission unless approval clearly covers both.
- Before staging, inspect `git status` and the relevant diff. Stage only reviewed paths or hunks from the task; never use `git add .`. Ask before including unexpected generated artifacts, lockfiles, or build output.
- Follow the repository's documented or observed commit and pull request style. Use the rules below only as fallbacks.
- Use an imperative, lowercase subject with no trailing period. Preserve identifiers, acronyms, and proper names at their normal casing, and wrap code names in backticks.
- In a monorepo, use `scope: change` when a scope improves clarity. For stacked changes, use `[i/n] scope: change` unless the repository specifies another format.
- Do not manually append a pull request number unless repository convention requires it.
- Do not add AI attribution unless the repository requires it.
- Follow the pull request template. If none exists, include a concise description and the exact verification performed; add implementation detail only when it helps review.

## Durable State

- Use `~/state` for durable, non-sensitive context when it is available. If it is absent or inaccessible, continue without it.
- Before substantive repository work or resuming a task, read only the relevant notes under `~/state/repos/<repo>/` and any relevant plan or document.
- Create or update state only for work likely to benefit from continuation. Do not mutate state for trivial or read-only tasks unless explicitly requested.
- Update state at meaningful checkpoints with concise constraints, decisions and reasoning, status, and dead ends worth avoiding. Do not log routine commands, raw tool output, or speculation.
- Keep notes accurate. Update stale claims in notes you own rather than appending contradictions. In multi-agent work, use separate topic files or designate one writer.
- Store reusable documentation in `~/state/docs/`, persistent plans in `~/state/plans/`, and repository notes in `~/state/repos/<repo>/<topic>.md`.
- Keep state and scratch notes out of repository commits.
