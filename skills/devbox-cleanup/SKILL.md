---
name: devbox-cleanup
description: Audit and reclaim storage on Linux development boxes, including Coder devcontainers and their outer VMs. Use for a full devbox disk, storage-related connection failures, or requests to clean home and system volumes. Preserve source worktrees, Git history, databases, current tools, and active jobs.
---

# Devbox cleanup

Restore working space on the requested machine. Clean both volumes when requested. An audit request authorizes inspection only. A cleanup request authorizes the specified disposable data. Reuse authorization already given in the conversation, and ask only before adding a category or side effect outside that scope. Creating this skill does not authorize running it on a live box.

## Identify and audit

1. Resolve the exact machine from the request or current connection. For Coder, distinguish the devcontainer from the outer VM. Confirm `hostname`, `id`, `df -hT`, and `df -i`. Home commonly has a separate filesystem from `/tmp` and Docker storage. Record the SSH aliases and physical path mapping rather than assuming a hostname or username.
2. Record the Docker engine ID, container IDs/names/states, and volume IDs. Use structured `docker inspect` results but retain only identity, state, and mounts. Never print full process arguments, container environments, authentication headers, or credential files.
3. Locate the main repository and run `git worktree list --porcelain` and `git count-objects -vH`. Find the common Git directory with `git rev-parse --path-format=absolute --git-common-dir`.
4. Measure likely large consumers first: Bazel output bases, shared download cache, Git temporary files, package stores, inactive worktree dependencies, Docker, and `/tmp` build outputs. Use `du -x -B1` on explicit directories. Bound scans to about 30 seconds and stream completed directory summaries. Avoid an exhaustive home traversal or piping a long scan into a buffering sort. If permission errors occur, report the measurement as incomplete or retry that exact directory with read-only `sudo`.
5. Use `docker system df` for images and build cache. Docker's storage lives on the daemon host, which may be the outer VM. Inspect Docker logs and filesystem usage there if the container cannot see them. Treat Docker reclaimable figures and hard-linked cache sizes as estimates, not additive promises.

Present the target paths, estimated recovery per filesystem, protected data, and any reinstall cost. For an aggressive request, include ignored dependencies in inactive worktrees and obsolete download/browser caches. Source checkouts and their local changes stay in place.

## Delete explicit targets

[scripts/guarded_cleanup.py](scripts/guarded_cleanup.py) checks one target at a time. It defaults to inspection and only deletes with `--apply`. Run it on the Linux box, with sufficient privileges to inspect processes, using the actual user's home and main repository. `--docker-id` binds the guard to the engine recorded during the audit. Keep the script's JSON results as ephemeral run evidence, outside repository changes.

```bash
python3 scripts/guarded_cleanup.py --kind bazel-output \
  --home /home/ubuntu --repo /home/ubuntu/figma/figma \
  --docker-id ENGINE_ID /home/ubuntu/.cache/bazel/_bazel_ubuntu/REVIEWED_BASE
```

After the target is reviewed and authorized, rerun the same command with `--apply`. Use `sudo -n python3` for read-only generated directories and full process visibility. Never recursively change permissions on shared or hard-linked files. Resolve script paths relative to this skill. If streaming the script over SSH, quote the remote arguments and send code on stdin rather than interpolating user text into shell evaluation.

The helper supports:

- `git-temp`: only aged `tmp_pack_*`, `tmp_idx_*`, `tmp_rev_*`, and `tmp_obj_*` files in the repository's common object store. It refuses open files and active Git packing. Delete these first when Git reports abandoned temporary files as garbage. Keep real packs, refs, reflogs, loose objects, and stashes. Do not run `git prune --expire=now` or history cleanup.
- `bazel-output`: a reviewed output base with `execroot`, directly under the user's `_bazel_*` directory or below `/tmp`. Keep installation directories, shared repository caches, the main checkout's output links, live server PID files, and anything referenced by processes or container mounts. Inspect named bases as well as hash-named bases. For an aggregate `/tmp/build-cache`, review its individual output bases instead of deleting the parent with source or reports beside it.
- `worktree-deps`: the root `node_modules` directory of an inactive registered secondary worktree. It must be ignored, contain no tracked files, and be separate from the main checkout. Preserve the source directory and `.git` entry. After deleting all eligible dependency directories, run `pnpm store prune` once so now-unreferenced store entries can be removed.

The guard refuses symlinks, mount boundaries, inaccessible activity checks, live references, changed targets, and unexpected layouts. Do not bypass a refusal. Resolve the cause or keep that target and report it. A vanished target is already complete. Re-audit after a crash or lost SSH connection instead of repeating a broad deletion. Before closing a stuck SSH client, prove its remote worker ended and identify only that cleanup connection.

## Native cache cleanup

Choose these commands for audited caches within the authorized scope. Confirm their configured paths and tool versions first. Do not change global tool configuration or install a missing CLI just to clear a small cache.

- **Docker:** use `docker builder prune --all --force` for unused build cache. Use `docker image prune --all --force` for unused images only after checking for active builds, deployments, or service rollouts that may need an image before a container references it. Postpone image pruning during such work. Never use `docker system prune`, container pruning, or volume pruning. Preserve stopped containers too, since their writable layers may hold database state.
- **Go:** inspect `go env GOCACHE`, check for active builds using that cache, then use `go clean -cache` when idle.
- **npm:** confirm `npm config get cache`, then use `npm cache clean --force`. Keep installed `_npx` tools and credentials.
- **pnpm:** confirm `pnpm store path`, then use `pnpm store prune`. Keep packages still referenced by projects. Do not remove the entire store.
- **uv:** locate the installed binary with the project's tool configuration or a known running binary if a mise shim has no selected version. Use `UV_LOCK_TIMEOUT=5 uv cache clean`. Keep the cache on a lock timeout. Never use `--force` or modify uv cache files directly.
- **apt:** on the outer VM, `sudo -n apt-get clean` removes downloaded archives without changing installed packages.

For smaller caches, only remove data whose role and inactivity are established:

- Keep Playwright revisions referenced by existing `.links` registrations and their `browsers.json`, including revision overrides, or by running browser processes. Remove only reviewed orphan revisions. Keep current browsers and other installed tool versions.
- Electron ZIP downloads older than a day can be removed if unopened. Keep extracted runtimes.
- Bazel repository-cache payload modification times track cache hits. Old unopened payloads can be pruned by an agreed retention period, such as seven days for aggressive cleanup. Recheck inode and timestamp immediately before unlinking. Preserve recent hits, installed repositories, and entries known to be unavailable upstream. Do not delete the shared cache wholesale.

Use native locking and context checks. Stop an operation on an unexpected failure, preserve its output, and recover from the actual state. Do not attribute filesystem or service changes to another actor without evidence.

## Verify and finish

- Capture final `df -B1` and `df -h` for each volume. Report actual free space, not the sum of estimated removals. Active builds can regenerate caches while cleanup runs.
- Check that every registered source worktree and its `.git` entry still exists, Git can read `HEAD^{commit}`, and retained active dependencies still resolve. Do not rebuild projects merely to test cleanup and refill caches.
- Recheck critical container and volume identities. A changing inventory is not proof that this cleanup preserved data. If a critical service or volume disappeared or was replaced, stop further pruning, disclose the observed change and uncertainty, and investigate before claiming preservation. Image and build-cache pruning alone do not establish the cause of a replacement.
- Verify the original failure where practical, for example SSH and `codex --version`. A CLI version check does not prove the desktop UI works. Confirm connection state separately when available.
- Report free space on home and system, the cleared categories, kept in-use targets, and that inactive worktrees may need dependencies reinstalled. Finish once all reviewed safe targets are handled. Do not chase newly generated artifacts or add recurring cleanup, service resets, storage resizing, commits, or pushes without authorization.

For recurrence, inspect existing cleanup cadence and protections. A weekly stale-output sweep can miss named bases and allow disk pressure to build between runs. Recommend pressure checks and appropriate retention when asked, without installing automation as part of a one-time cleanup.

References: [Docker pruning](https://docs.docker.com/engine/manage-resources/pruning/), [uv cache safety](https://docs.astral.sh/uv/concepts/cache/), [pnpm store pruning](https://pnpm.io/cli/store), [Bazel repository cache](https://bazel.build/run/build#the-repository-cache).

[written with AI]
