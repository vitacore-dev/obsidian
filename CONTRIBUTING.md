# Contributing to Support Knowledge Base

This repository stores the shared Obsidian knowledge base for technical support.

## Goal

Keep troubleshooting knowledge searchable, current, and safe to use during live ticket handling.

## Before You Start

1. Update local main branch:
   - `git checkout main`
   - `git pull --rebase`
2. Create a branch:
   - New article: `kb/add-<topic>`
   - Fix/update: `kb/fix-<topic>`
3. Do not commit sensitive data:
   - customer PII
   - tokens/passwords
   - internal secrets

## Folder Map

- `01_Runbooks` - step-by-step troubleshooting and recovery instructions
- `02_Known-Issues` - known problems and workarounds
- `03_Product-FAQ` - frequent customer-facing questions
- `04_Integrations` - integration setup, limits, caveats
- `05_Incidents-Postmortem` - incident analysis and lessons learned
- `06_Onboarding` - onboarding material for support engineers
- `90_Templates` - note templates

## Required Note Format

Every operational note must contain:

- **Symptoms** - what user/support sees
- **Scope** - product versions / environments affected
- **Diagnosis** - checks and validation steps
- **Resolution / Workaround** - exact actions
- **Escalation** - when and where to escalate
- **Owner** - team/person responsible
- **Last Updated** - date in `YYYY-MM-DD`

Example frontmatter:

```yaml
---
title: "Login fails with SSO timeout"
owner: "support-l2"
last_updated: "2026-04-15"
product_version: ">= 2.4.0"
tags: [runbook, auth, sso]
---
```

## Pull Request Flow

1. `git pull --rebase` before finalizing
2. Commit with clear message (`kb: add runbook for SSO timeout`)
3. Push branch
4. Open PR to `main`
5. Pass checks and get approvals
6. Merge

## PR Lanes

- **Fast lane** (small fixes: typo/link/minor clarification):
  - 1 reviewer
  - target response under 4 business hours
- **Standard lane** (new runbook, process change, critical logic):
  - 2 reviewers or 1 reviewer + area owner

## Definition of Done

A PR is done when:

- content is accurate and actionable
- internal links resolve
- owner and update date are present
- no sensitive data is included
- rollback or escalation path is clear (for runbooks)

