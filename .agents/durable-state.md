# Durable State Runbook

Use this runbook only when the global agent guidelines direct you to use `~/state`.

## Validate and Read State

- Do not clone, initialize, repoint, move, replace, or repair `~/state`.
- At session start, verify that `~/state` is the root of a Git worktree. If it is not, continue without state and report that only when materially relevant.
- When the checkout is valid, capture the session start time and read the current contents of every regular durable-context file under `~/state/repos/` whose filesystem modification time is in the inclusive interval from 168 hours before session start through session start. Read matching files from oldest to newest so the most recent context is loaded last. This rolling window spans repositories and applies even to trivial or read-only requests. Exclude Git metadata, repository-control files, and everything under `skills/`.
- Before substantive repository work or resuming a task, read any additional relevant files under `~/state/repos/<repo>/` that fall outside the rolling window.
- Use the existing local checkout for the rolling-window seed; seeding alone does not justify a refresh. Refresh only when the current task needs fresher state. Inspect status first, then pull with `--ff-only` only when the worktree is clean, an upstream is configured, and required platform approval is available. Otherwise use the local notes and report possible staleness when material.

## Write State

- Create or update state only when the work is likely to benefit from continuation. Do not mutate it for trivial or read-only tasks unless explicitly requested.
- Record concise constraints, decisions and reasoning, current status, and dead ends worth avoiding at meaningful checkpoints. Do not record routine commands, raw tool output, speculation, secrets, or sensitive data.
- Delegate each update to a dedicated background subagent when available. Give it the exact checkpoint context, continue the primary work in parallel, and collect its result before the final response. If no subagent is available, the primary agent is the designated state writer.
- The designated writer owns all `~/state` file and Git operations. Other agents must not edit, stage, or commit there.
- Keep notes accurate by updating stale claims instead of appending contradictions. Use separate topic files for concurrent multi-agent work.
- Keep state and scratch notes out of project repository commits.

## Layout and Naming

Store durable state under `~/state/repos/<repo>/` and add directories only as needed:

- `notes/` for resumable task state and checkpoints
- `docs/` for reusable documentation and runbooks
- `plans/` for implementation, test, and rollout plans
- `projects/` for multi-task or multi-PR initiatives
- `incidents/` for SEV investigations and follow-up evidence
- `decisions/` for durable decisions and their rationale
- `skills/` for private reusable agent skills, stored as `skills/<name>/SKILL.md`

Name durable state files `YYYYMMDDHHMMSS_topic.ext` using their creation time in local 24-hour time. Preserve the timestamp prefix when editing or moving a file. Repository-control files such as `.gitignore` and the named directories under `skills/` are exempt.

Skills under `~/state/repos/<repo>/skills/` are private tooling rather than durable context. Dotfiles setup links them into each installed agent's skills directory for the next session. Avoid names that collide with agent-provided skills, prefer an existing skill when one already covers the workflow, and create or modify a skill only when asked.

## Commit and Push State

- When `~/state` has a configured upstream, the designated writer must commit and push each completed non-sensitive state update immediately after verification and without separate user confirmation. This exception applies only to state updates and does not bypass platform approvals or Git safeguards.
- Inspect status plus staged and unstaged diffs. Stage only the exact reviewed paths or hunks written for the task, then verify the complete staged diff. If unrelated work is staged or a touched file has concurrent edits, leave the update local and report it.
- Use a specific imperative commit subject: `<repo>: <summary>`.
- Attempt one push. If it fails, preserve the local commit and report the reason. Do not rebase, merge, resolve conflicts, retry, or force-push without explicit permission. A state Git failure must not block the primary task.
