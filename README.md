# Support Knowledge Base (Obsidian + GitHub)

Shared technical support knowledge base managed through GitHub pull requests.

## Structure

- `01_Runbooks/`
- `02_Known-Issues/`
- `03_Product-FAQ/`
- `04_Integrations/`
- `05_Incidents-Postmortem/`
- `06_Onboarding/`
- `90_Templates/`

## Quick Start

1. Read `CONTRIBUTING.md`
2. Create branch (`kb/add-...` or `kb/fix-...`)
3. Update notes in Obsidian
4. Open PR to `main`

## Daily Workflow

1. Start of task:
   - `git checkout main`
   - `git pull --rebase`
   - `git checkout -b kb/add-<topic>` (or `kb/fix-<topic>`)
2. During task:
   - update notes in Obsidian
   - run commit from Obsidian Git plugin or terminal
3. End of task:
   - `git push -u origin <branch>`
   - open PR and request review
   - after merge, switch back to `main` and pull latest changes

