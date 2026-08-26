---
description: "Generate a Mercedes-Benz style pull request title and description from the current git diff. Use when: writing a PR description, summarising changes, opening a pull request."
agent: "agent"
---

Generate a complete pull request title and description for the staged/committed changes by following the steps below.

## Conventions

### Commit / PR title format

```
[type]([JIRA-Ticket]): [short imperative summary]
```

**Allowed types:**

| Type       | When to use                                              |
|------------|----------------------------------------------------------|
| `feat`     | A new feature visible to users or downstream consumers   |
| `fix`      | A bug fix                                                |
| `chore`    | Maintenance, dependency bumps, tooling changes           |
| `refactor` | Code restructure with no behaviour change                |
| `perf`     | Performance improvement                                  |
| `test`     | Adding or updating tests only                            |
| `docs`     | Documentation only                                       |
| `ci`       | CI/CD pipeline or build-script changes                   |

**JIRA ticket:** extract from branch name (e.g. `feature/EASRE-1010-...` → `EASRE-1010`).  
If no ticket can be found, ask the user before continuing.

**Summary:** max 72 characters, imperative mood, no period.

---

## Step 1 — Read the diff

Run the following to gather context:

```bash
git diff HEAD~1..HEAD --stat
git diff HEAD~1..HEAD
```

If the branch has not been committed yet, fall back to:

```bash
git diff --cached --stat
git diff --cached
```

Also read:
- Branch name (`git rev-parse --abbrev-ref HEAD`) to extract the JIRA ticket.
- Recent commit messages (`git log --oneline -10`) for additional context.

---

## Step 2 — Determine type and JIRA ticket

1. Identify the single best `type` from the table above based on the diff.  
   If the diff genuinely touches multiple concerns, choose the dominant one.
2. Extract the JIRA ticket key from the branch name (pattern: `[A-Z]+-[0-9]+`).  
   If missing, ask the user: *"I couldn't find a JIRA ticket in the branch name. Please provide it (e.g. EASRE-1010) or type 'none'."*

---

## Step 3 — Draft title and description (Minto Pyramid)

Structure the PR description using the **Minto Pyramid**: answer *what and why* first, then drill into details.

### PR Title

```
[type]([JIRA-Ticket]): [short imperative summary]
```

### PR Description template

```markdown
## Summary

{2–4 sentences. State the problem/motivation, what was changed, and the immediate benefit.
No bullet lists here — write in plain prose. This is the executive summary.}

## Changes

{Grouped bullet list of the actual changes. Group by concern (e.g. "API layer", "Database", "Tests").
Each bullet: concise, specific, explains *what* changed and *why* if non-obvious.}

### [Group 1 — e.g. Feature / Core logic]
- …

### [Group 2 — e.g. Tests]
- …

### [Group 3 — e.g. Config / CI]
- …

## Impact & Notes

{Optional. Call out: breaking changes, migration steps, env-var additions, performance implications,
follow-up tickets, or anything a reviewer must know before merging. Omit section if not applicable.}
```

---

## Step 4 — Show draft and ask for confirmation

Display the full title and description. Then ask:

> "Does this look good, or would you like me to adjust the type, title, or any section?"

Wait for the user's feedback. Apply any requested edits and re-display before finalising.

---

## Step 5 — Output the final PR

Output a single fenced markdown block containing the final title on the first line, followed by the description, ready to paste into the PR form:

````markdown
[type]([JIRA-Ticket]): [summary]

## Summary
…

## Changes
…

## Impact & Notes
…
````

