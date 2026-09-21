---
name: mr-analyzer
description: "Review a merge request by diffing the remote branch against remote main, cross-checking the change against project docs and the project CLAUDE context, then emitting a team-readable summary plus an approve / changes-required decision table. Invoke when asked to analyze, review, or assess an MR/PR for a branch."
argument-hint: <branch-name> [MR information / feedback / review notes]
allowed-tools: Read, Glob, Grep, Bash(git *), Bash(ls *), Bash(cat *), Bash(cargo *), Bash(dotnet *), Bash(go *), Bash(npm *), Bash(flutter *)
---

# MR Analyzer

Reviews a merge request end to end and emits a fixed two-section report.

## Execution rules — read first

- **Run inline in the calling session.** Do NOT dispatch `Agent`, subagents, forks, or `Task` for any part of this skill. The whole point is that the review runs on whatever model and reasoning effort the calling session is configured with; delegating would silently swap that out.
- **Never guess.** Every claim in the output must trace to a line you actually read — diff hunk, source file, doc, or config. If something cannot be verified, say so and label it as an assumption. This applies to file paths, line numbers, config keys, and behavior.
- **Read-only.** Do not edit files, stage, commit, push, or comment on the MR. Output is the report and nothing else.
- Doc drift found during the review is **reported**, not fixed — it becomes a row in the Section 2 table.

## Arguments

The skill receives a single argument string:

```
/mr-analyzer <branch-name> <MR information / feedback / review notes>
```

- **Arg 1 — branch name**: the first whitespace-delimited token (or the first quoted segment). Strip any `origin/` prefix the user typed; you re-add it yourself.
- **Arg 2 — MR context**: everything after the branch name. This is the MR description, the reviewer feedback, the ticket text, or whatever the author wants weighed. Treat it as **claims to verify against the diff**, not as facts. If the MR context says a thing was done and the diff does not show it, that gap is a finding.

If the branch name is missing, ask for it before doing anything else. If the MR context is missing, proceed — review the diff on its own merits and note that no MR description was supplied.

## Step 1 — Establish the remote-vs-remote diff

Always compare **remote to remote**. Local branches drift from what the MR actually shows; never diff the working tree or a local ref.

```bash
git fetch origin --prune
git rev-parse --verify origin/<branch>            # fail loudly if the branch is not on the remote
git log --oneline origin/main..origin/<branch>
git diff --stat origin/main...origin/<branch>
git diff origin/main...origin/<branch>
```

- Use the **three-dot** form (`origin/main...origin/<branch>`). Three dots diff the branch against the **merge base** — the commit where the branch left main — which is exactly what GitLab/GitHub renders in the MR. Two dots would also fold in everything main gained since the branch started, producing findings about code the MR never touched.
- If `origin/main` does not exist, resolve the default branch from `git symbolic-ref refs/remotes/origin/HEAD` and use that; state which base you used.
- If the remote branch does not exist, stop and report that — do not silently fall back to the local branch.
- If the diff is empty, report that and stop.

Note whether the branch is behind `origin/main` (`git log --oneline origin/<branch>..origin/main | wc -l`); a badly stale branch is itself a finding.

## Step 2 — Build context before judging

Do not review a hunk in isolation. For every file the diff touches:

1. **Read the whole changed file**, not just the hunk — the diff hides the invariants around it.
2. **Trace the blast radius.** Grep for callers, implementors, and dependents of anything the diff changed in a public API, shared crate/module, config schema, or wire format. Cross-module and cross-binary changes are where the real regressions live.
3. **Pull the corresponding documents.** Find and read the docs that describe the subsystem being changed, then judge the code against them. Locate them by:
   - `CLAUDE.md` / `CLAUDE.local.md` at repo root and in parent dirs — these carry project rules and the doc map.
   - The imported project context file referenced from `CLAUDE.local.md` (e.g. `~/.claude/projects/<project>/CLAUDE.md`).
   - `find . -name "*.md" -not -path "./.git/*" -not -path "*/target/*" -not -path "*/build/*" -not -path "*/node_modules/*"` — subsystem specs, implementation notes, setup guides, wikis.
   - Some project docs are deliberately **not tracked in git** (local-only working notes). They are still authoritative and still in scope; do not assume a doc is absent just because it is untracked.
   - Match doc to code by subsystem, not by filename proximity — a change to a shared library is governed by the docs of every consumer that depends on it.
4. **Load the project rules and company standards.** Language style rules, naming, error-handling conventions, commit/branch protocol, API design rules — from the `CLAUDE.md` files and from the surrounding code's actual idiom. A change that is correct but off-idiom for the file it lives in is a finding.

## Step 3 — Check the CLAUDE context and the docs for drift

This runs on **every** review, alongside the code review.

- Take the project-specific Claude context (`CLAUDE.md`, `CLAUDE.local.md`, and the imported per-project context file) and verify its claims about the areas this MR touches **against the current implementation** — module maps, config schemas, route tables, pitfalls, invariants, defaults, file paths, function names.
- Do the same for the subsystem docs read in Step 2.
- Report as drift only what this MR's subject matter covers. Two kinds count:
  - **The MR invalidated it** — a config key removed, a function renamed, an endpoint moved, a default changed, and the doc/context still describes the old shape.
  - **It was already wrong** before this MR, in the area under review — docs in this repo have described designs that were never built and test suites that never existed. Verify, do not repeat.
- Each drift item becomes a row in the Section 2 table, with the doc/context file and line as the Finding. Severity reflects how badly a reader would be misled: a stale example is Low, a documented invariant that the code no longer honors is High.

## Step 4 — Analyze for issues and regressions

Weigh the change for: correctness bugs, regressions in existing behavior, broken callers, unhandled error/edge paths, concurrency and blocking-in-async problems, resource and lifetime issues, security and trust-boundary changes, config/schema compatibility, startup and failure-mode behavior, missing or stale tests, and deviations from project style.

Prioritize by what actually breaks in production over what merely reads oddly. Do not pad the table with taste. Every row must have a concrete failure path you can state.

## Output — exact format

Emit **only** the two sections below. No preamble, no closing commentary, no restating of the diff.

### Section 1 — Summary

A bold `Summary` heading, then bullets describing what was implemented, what changed, and what good it does the codebase.

Rules for the bullets:

- **Audience is the whole dev team and management** — people without knowledge of this subsystem's specifics. Use generic technical terms. No crate names, function names, config keys, protocol field names, or jargon that only the author would recognize.
- **One sentence per bullet.** Add a second sentence only when one genuinely cannot carry the concept.
- **One concept per bullet, whole.** If two changes belong to the same practical concept, they go in the same bullet — do not split a concept across bullets to pad the list.
- **No file paths and no line numbers** anywhere in Section 1.
- Simple, brief, straightforward, practical. State what it does and why it matters, not how it is coded.

### Section 2 — Review Decision

A bold `Review Decision:` label followed by exactly one of these two strings, verbatim, including the emoji:

- `✅Approved`
- `⛔Changes required`

Choose `⛔Changes required` when any finding is High or Critical, when the change breaks an existing caller or documented contract, or when it does not do what the MR context claims. Otherwise `✅Approved` — Low and Medium findings are compatible with approval and stay in the table as follow-ups.

Directly under the decision line, write a short plain-language paragraph giving the reasoning behind that decision.

Directly under that paragraph, the findings table — these four columns exactly:

| Column | Content |
|---|---|
| **Severity** | Exactly one of `Low`, `Medium`, `High`, `Critical`. |
| **Findings** | Only the specific file and line — `file.rs#ln42`. Nothing else in this cell. |
| **Impact** | What it causes, in straightforward plain language. |
| **Recommendation** | The specific action that resolves it. |

Order rows most severe first. If nothing was found, keep the table header and add a single row stating no findings — never drop the table.

### Template

```
**Summary**

* Summary item 1
* Summary item 2

**Review Decision:** ✅Approved

One short paragraph explaining why this decision was reached.

|Severity|Findings|Impact|Recommendation|
|--|--|--|--|
|Low|main.rs#ln1|Blocks the server from starting when the hardware is absent.|Spawn the task on a separate thread and log the failure instead of returning it.|
```
