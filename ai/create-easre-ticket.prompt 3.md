---
description: "Draft and create EASRE Jira Story tickets via the Atlassian MCP. Use when: creating a Jira ticket, new EASRE story, writing a user story for the observability team."
agent: "agent"
---

Draft one or more EASRE Story tickets from the user's description (or current chat context), show them for approval, then create them in Jira.

## Constants

- **Cloud ID**: `mercedes-benz-helios.atlassian.net`
- **Project key**: `EASRE`
- **Issue type**: `Story`
- **Team field** (`customfield_10001`): set during `createJiraIssue` as a plain UUID string `"b44cae5f-f258-44ae-885d-0a66e81c8cc4"` in `additional_fields` (object format fails; plain string works).
- **Story Points field**: `customfield_10482` (integer: 1, 2, 4, 8, or 16)
- **Fix Version**: `fixVersions` — value `[{"name": "PI X"}]` where X is the detected PI number
- **Assigned PI**: Agile Hive field `6efdaf98-c069-4e97-81e9-1fd5b1731949__PRODUCTION__assigned-pis` — this may not be settable via the API. If it fails, tell the user to set it manually in Jira.
- **Priority**: `Low` by default (overridable by user)
- **Sprint field**: `customfield_10020` — set as `[{"id": <sprint_id>}]`. Leave omitted for backlog.
- **Current sprint** (EASRE-S1 Observability): `{"id": 35368, "name": "PI 7 - S03 - EASRE-S1"}` — fetch a fresh sprint via JQL `project = EASRE AND sprint in openSprints() AND sprint = "PI 7 - S03 - EASRE-S1"` to confirm the active sprint ID at time of creation.
- **Current user account ID**: `712020:baa1ad85-15b3-4913-a87c-4ed9791d2985` (Anton Jurgens)
- **Assignee field**: `assignee_account_id` on `createJiraIssue`, or set via `editJiraIssue` field `{"assignee": {"accountId": "<id>"}}`

## PI Schedule

Determine the current PI by checking which date range today falls within:

| PI | Start      | End        |
|----|------------|------------|
| 7  | 2026-02-23 | 2026-05-17 |
| 8  | 2026-05-18 | 2026-08-09 |
| 9  | 2026-08-10 | 2026-11-01 |
| 10 | 2026-11-02 | 2027-01-24 |
| 11 | 2027-01-25 | 2027-04-12 |

Both **Fix Version** and **Assigned PI** must be set to the same detected PI.

## Story Point Estimation Guide

Estimate story points based on the task's complexity — do NOT default to a fixed value.

| SP | Definition | Examples |
|----|-----------|----------|
| 1  | VERY QUICK, NO COMPLEXITY. Know exactly what to do, very little time. | Small doc update, quick fix, support someone else |
| 2  | QUICK, MINIMAL COMPLEXITY. Know exactly what to do, little time. | Adaptation/revision/bugfix of something existing |
| 4  | MODERATE TIME, MODERATE COMPLEXITY, POSSIBLE UNKNOWNS. Mostly know what to do. | Manageable time, no large feature dev; conceptual work |
| 8  | LONGER TIME, HIGH COMPLEXITY, LIKELY UNKNOWNS. High-level understanding, big unknowns. | Feature dev (concept → impl → test → docs → release); 3rd-party API integration; fits within a sprint |
| 16 | LONG TIME, HIGH COMPLEXITY, CRITICAL UNKNOWNS. Understand concept and goals but will take a while. | Uncertainty about the solution; may span multiple sprints |

## Description Template

Use this exact markdown structure for the ticket description:

```
### **User story Hypothesis**

| **As an** | {role — usually "SRE"} |
| --- | --- |
| **I want to** | {what the user wants to achieve} |
| **So that** | {the benefit or outcome} |

### **Context:**

{One or more paragraphs explaining background, current state, and what needs to change. Reference specific files, modules, or systems from the repository where relevant.}

### **Acceptance Criteria:**

- [ ] {criterion_1}
- [ ] {criterion_2}
- [ ] ...
```

## Step 1 — Gather input

Read the user's description of the work. If no input is provided, check the current chat context for work that needs a ticket. If still unclear, ask the user to describe the work before continuing.

One bullet point or topic from the user is usually one ticket. If the user describes multiple pieces of work, draft multiple tickets.

After understanding the work, ask the user two questions before drafting:

1. **Sprint**: "Add to the current sprint (`PI 7 - S03 - EASRE-S1`) or leave in the backlog?"
2. **Assignee**: "Assign to yourself (Anton Jurgens), leave unassigned, or assign to someone else? (If someone else, provide their name or Jira account ID.)"

Record the answers and use them in Step 5. Do not proceed to draft until these are answered.

## Step 2 — Auto-detect PI

Determine today's date and match it against the PI Schedule table above to find the current PI number. This will be used for both Fix Version and Assigned PI.

## Step 3 — Draft the ticket(s)

For each ticket:

1. **Summary**: Write a concise, action-oriented title (e.g. "Add availability SLO definitions for VCC service")
2. **Description**: Fill in the Description Template above. Use the repository as context if more detail is needed. Do not overcomplicate or invent details not present in the user's input.
3. **Story Points**: Estimate using the Story Point Estimation Guide. Provide a one-line rationale.
4. **Priority**: Default to `Low` unless the user indicates urgency.

## Step 4 — Show draft and confirm

Display each ticket in this format:

```
**Summary:** {title}
**Story Points:** {N} — {rationale}
**PI:** PI {X} (auto-detected)
**Priority:** {priority}
**Sprint:** {current sprint name | Backlog}
**Assignee:** {name | Unassigned}
**Team:** EASRE-S1 (Observability)

**Description:**
{full description from template}
```

Ask the user for approval before creating anything. The user may request edits to the summary, description, story points, PI, sprint, or assignee.

## Step 5 — Create in Jira

On approval, for each ticket use the Atlassian MCP `createJiraIssue` tool with:

- `cloudId`: `mercedes-benz-helios.atlassian.net`
- `projectKey`: `EASRE`
- `issueTypeName`: `Story`
- `summary`: the ticket summary
- `description`: the full description markdown
- `contentFormat`: `markdown`
- `additional_fields`:
  ```json
  {
    "customfield_10001": "b44cae5f-f258-44ae-885d-0a66e81c8cc4",
    "customfield_10482": <story_points_integer>,
    "fixVersions": [{"name": "PI <X>"}],
    "priority": {"name": "<priority>"}
  }
  ```

After creation, use a single `editJiraIssue` call to set sprint and assignee:
```json
{
  "assignee": {"accountId": "<account_id>"},
  "customfield_10020": <sprint_id_integer>
}
```

- **Assignee**: set `accountId` to `"712020:baa1ad85-15b3-4913-a87c-4ed9791d2985"` if assigning to self; omit the `assignee` key entirely if unassigned; use the provided account ID if assigning to someone else. If the user gave a name instead of an ID, use `lookupJiraAccountId` to resolve it first.
- **Sprint**: if user chose current sprint, first run JQL `project = EASRE AND sprint in openSprints() AND sprint = "PI 7 - S03 - EASRE-S1"` to fetch and confirm the live sprint ID, then set `customfield_10020` as a **plain integer** (e.g. `35368`) — NOT an array or object; if user chose backlog, omit `customfield_10020` from the edit call.

Also attempt to set the Assigned PI field using a second `editJiraIssue` call with field key `6efdaf98-c069-4e97-81e9-1fd5b1731949__PRODUCTION__assigned-pis`. If this fails, tell the user: "Assigned PI must be set manually in Jira — the Agile Hive field cannot be set via API."

After successful creation, display the ticket key and link:
```
Created: EASRE-XXXX — https://mercedes-benz-helios.atlassian.net/browse/EASRE-XXXX
```
