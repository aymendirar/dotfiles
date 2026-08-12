# Agent Guidelines

These are fallback preferences. Higher-priority requirements, explicit task instructions, and the nearest repository-specific guidance take precedence. If equally ranked rules conflict, follow the safer, more specific rule and surface material ambiguity.

## Authority and Scope

- Review, audit, explain, diagnose, and plan requests authorize inspection and reporting only. Do not edit files or mutate external systems unless asked.
- Fix, change, and build requests authorize the local changes needed for the requested outcome and relevant non-destructive validation.
- Pull requests, deployments, publications, messages, purchases, database mutations, and other external writes require explicit permission.
- If completion requires a material expansion of scope or a new side effect, stop and ask.
- Before a destructive action, resolve the exact target and prefer a reversible approach. Never use a home directory, filesystem root, repository root, broad glob, or unresolved variable as a destructive target.
- Do not inspect credential stores unless the task requires it. Never expose, commit, or upload credentials, tokens, private keys, or other secrets. Persist them only to an approved credential or secret store when required by the task. Handle personal, customer, and other sensitive data only as required by the task; minimize it, keep it out of logs and unrelated commits, uploads, or durable state, and redact incidental output.

## Decisions

Before implementing, identify ambiguities that materially affect scope, behavior, compatibility, safety, or the result. Ask about those and wait. Otherwise choose the simplest reasonable interpretation, state only non-obvious assumptions, and proceed. Flag a materially simpler alternative or meaningful tradeoff before coding.

## Problem Solving

- Be solution-oriented. When identifying a problem, pair it with the strongest practical path forward that fits the current authority and scope.
- Lead with a recommendation. When multiple viable approaches exist, compare material tradeoffs such as correctness, safety, reversibility, compatibility, complexity, maintenance cost, and time, then recommend one. Do not present an unranked menu of options.
- Keep analysis proportional. Include alternatives only when they would materially change the outcome, and explain what new information would change the recommendation.
- If action is blocked or not authorized, still provide the best safe workaround or next step and make the required decision, permission, or external change explicit.

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
- For complex work with dependent steps, keep a short `step -> check` plan. Persist it under `~/state/repos/<repo>/plans/` only when it should survive the current session.

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
- When constructing a commit command in a POSIX shell, prevent backticks from being evaluated. In a double-quoted message, escape them: ``git commit -m "add \`name\` support"``.
- In a monorepo, use `scope: change` when a scope improves clarity. For stacked changes, use `[i/n] scope: change` unless the repository specifies another format.
- Do not manually append a pull request number unless repository convention requires it.
- Do not add AI attribution unless the repository requires it.
- Follow the pull request template. If none exists, include a concise description and the exact verification performed; add implementation detail only when it helps review.

## Durable State

- Use the context-specific private repository at `~/state` for durable, non-sensitive context only when a task needs it. Substantive repository work, resumed work, or a warranted durable update needs state; trivial work does not.
- Select the state repository before reading or writing it. Use `adirar-figma/state` for Figma, work-owned, or explicitly work tasks, including repositories under `~/figma/`. Use `aymendirar/state` for personal project tasks. If the context is ambiguous and state is needed, ask rather than mixing contexts.
- Prefer SSH for state repository remotes when it is configured and reachable. Dotfiles setup provisions `~/state`: the devcontainer installer selects `adirar-figma/state` over authenticated HTTPS because Coder SSH egress may be blocked, while the local update and VPS installers select `aymendirar/state` over SSH. `STATE_REPO` may override the transport. Agents must not clone, initialize, repoint, move, replace, or repair `~/state`. If it is absent or inaccessible, continue without state and report missing context only when materially relevant.
- Before using `~/state`, verify that it is the root of a Git worktree and that `origin` exactly matches the selected context's HTTPS or SSH URL. If it belongs to the other context or otherwise conflicts, do not use or synchronize it; continue without state and report the mismatch only when materially relevant.
- Never merge, copy, push, or otherwise synchronize state between `adirar-figma/state` and `aymendirar/state`. Their shared history is only the split point; keep subsequent work and personal context separate.
- Before substantive repository work or resuming a task, read only the relevant files under `~/state/repos/<repo>/`.
- When state is needed, an agent may refresh an existing checkout, including during read-only tasks. Inspect status first and pull with `--ff-only` only when it is a clean Git worktree with a configured upstream and required platform approval is available. Otherwise use the local notes, report possible staleness when material, and continue. Do not pull periodically when no task needs state.
- Create or update state only for work likely to benefit from continuation. Do not mutate state for trivial or read-only tasks unless explicitly requested.
- Update state at meaningful checkpoints with concise constraints, decisions and reasoning, status, and dead ends worth avoiding. Do not log routine commands, raw tool output, or speculation.
- Delegate each state repository update to a dedicated background subagent when subagents are available. Give it the exact checkpoint context, continue the primary work in parallel, and collect its result before the final response. If subagents are unavailable, the primary agent becomes the designated state writer.
- Keep notes accurate. Update stale claims in notes you own rather than appending contradictions. In multi-agent work, use separate topic files. The designated state writer performs all `~/state` file and Git operations; other agents must not edit, stage, or commit there.
- Store all durable state under `~/state/repos/<repo>/`, organized only as needed:
  - `notes/` for resumable task state and checkpoints
  - `docs/` for reusable documentation and runbooks
  - `plans/` for implementation, test, and rollout plans
  - `projects/` for multi-task or multi-PR initiatives
  - `incidents/` for SEV investigations and follow-up evidence
  - `decisions/` for durable decisions and their rationale
  - `skills/` for private, reusable agent skill definitions, as `skills/<name>/SKILL.md`
- Name every durable state file `YYYYMMDDHHMMSS_topic.ext`, using its creation time in local 24-hour time. Preserve that prefix when editing or moving the file. Repository-control files such as `.gitignore` are exempt, as is `skills/`, whose directories are named for the skill.
- Skills under `~/state/repos/<repo>/skills/` are private tooling rather than durable context. Dotfiles setup links each one into every installed agent's skills directory, so a skill added there is available in the next session on that machine. Those directories also hold skills the agents ship themselves, so a new skill needs a name that does not collide with an existing one. Prefer an existing skill over hand-rolling a workflow it already covers. Create or modify one only when asked; the same commit and push rules apply.
- When `~/state` is a Git worktree with the expected upstream, the designated writer must commit and push every completed, non-sensitive state update without separate user confirmation. Do this immediately after verifying the write. This exception waives only the confirmation requirement above; it does not bypass platform approvals or Git safeguards. Inspect status plus staged and unstaged diffs, stage only the exact reviewed paths or hunks written for the task, and verify the complete staged diff. If unrelated work is staged or a touched file has concurrent edits, leave the update local and report it.
- Use a specific imperative subject for every state update: `<repo>: <summary>`.
- Attempt one push. If it fails, preserve the local commit and report the reason. Do not rebase, merge, resolve conflicts, retry, or force-push without explicit permission. A `~/state` Git failure must not block the primary task.
- Keep state and scratch notes out of project repository commits.
