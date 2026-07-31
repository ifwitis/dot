---
description: Review code changes, create a conventional commit message according to the format, and seek user's approval for committing
---
## Commit Format 
Use conventional commit prefixes to categorize changes:
- fix:      Bugs that are being fixed or adjustments to how things work
- feat:     Features that have been added
- chore:    Tidying things up, not making substantial changes to how things work
- refactor: Changes that don't change the behavior, but do change the internal layout and style
- revert:   Changes that revert previous changes
- docs:     Purely documentation and thoughts updates
- perf:     Optimization changes
- build:    Changes related to versioning, packages, and dependencies
- ci:       Changes to how the CI system works

Conventional format: `feat(scope): description`
- Commit subjects ≤ 72 chars.
- Scope uses kebab-case (e.g., `feat(landing-page): ...`).
- Scope can be optional if not clear.


## Task
Review code changes and create an appropriate commit message by following these steps:
### Step 1: Read
1. Use the `git status --short` command to view currently staged files.
2. Use the `git diff --staged` command to review code changes in individually staged files. Note: *Only* do this if you do not understand the context behind the file; if necessary, use a read tool to examine the full file contents to better understand the changes.
### Step 2: Plan
3. Identify which files belong together and whether changes belong in one commit or multiple.
4. Use `git log --oneline -5` to review the last five commits.
5. Analyze the code changes and draft up concise, descriptive commit message(s) that adheres to standard conventions (main messages <50 chars, in the imperative, of format `type: description`, and including the commit type prefixes detailed above). Focus on the "why" rather than the "what."
### Step 3: Present
6. List the files you plan to add for each commit, along with the commit message(s) you'll use. 
   Ask: "I plan to create \[N\] commit(s) with these changes. Shall I proceed?"

7. Ask the user for their opinion on the commit message before finalizing the commit.
### Step 4: Execution
8. If the user approves, proceed as follows below. Otherwise, adjust the message(s) based on their feedback and ask again.
9. Use git add with specific files (never use -A or .) and create the planned commits with their drafted messages.
10. Execute the commit and show the result with git log --oneline -n [N]

## Key Points to Remember
- **Always seek user approval** before formally committing with `git commit`. Explain the reasoning behind your proposed commit message based on the code changes.
- **Group related changes together**.
- Your judgment is **trusted**, as you were given full context of the changes within this session.
