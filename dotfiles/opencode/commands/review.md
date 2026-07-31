---
description: Perform a full code review pass on the last commit made, and determines if the provided plan was executed successfully. 
Documents any drift that occurred during implementation. Provide a <optional> plan file in the arguments for the review to analyze. It is strongly advised to run this command within the session of a plan execution, after running commit.
---

# Review Plan

You are tasked with validating that a commit was successfully implemented, verifying all success criteria and identifying any issues. You will be given instructions, followed by a review that will contain user specific instructions and the optional plan file related to this implementation.

A single, portable review pass. Everything runs in ephemeral, isolated environments so nothing is installed into the repo or committed. Every step degrades gracefully: if a target directory, config, or plan file doesn't exist, skip it and note it in the summary instead of failing.

Optional argument: a path to a plan/ticket file to validate the implementation against.

review target (optional):

$ARGUMENTS

---

## Guiding Principles

1. **Isolated by default** — use `uvx`, `pipx run`, and `npx` so tools run without polluting the repo or global env. No `requirements.txt`, no committed tool configs.
2. **Portable** — assume nothing about project structure. Auto-discover what to check.
3. **Simple & single-context** — no subagents, no parallel tasks. Run everything in the main context for consistency.
4. **Honest** — report what passed, what failed, and what was skipped (and why).
5. **Fix-forward** — resolve failures before continuing; if a failure is intentional/expected, document it.

Use the `todowrite` tool to create a structured task list for Steps 1–5 below, marking each as pending initially.

## Validation Process

### Step 1: Context Discovery

1. **Establish clean state**:
   - Ensure the working tree is clean except for intentional changes (`git status`).
   - Note the commit(s) under review (`git log --oneline -5`) and the diff/range you are reviewing.

2. **Branch on plan presence**:
   - **If a plan/ticket file was provided** in `$ARGUMENTS`: read it completely, then identify what should have changed:
     - List all files that should be modified.
     - Note all success criteria (automated and manual).
     - Identify key functionality to verify.
   - **If no plan was provided**: skip plan-specific discovery. Derive intent from the commit message(s) and diff instead, and note "No plan provided" for later in the summary.

3. **Discover implementation in the main context** (do NOT spawn subagents). Investigate directly:
   - **Data/schema changes**: check for new migrations, schema version bumps, table/structure changes.
   - **Code changes**: enumerate modified files from the diff and understand what each change does.
   - **Test coverage**: check whether tests were added/modified for the changed code.

### Step 2: Isolated Tooling & Systematic Validation

Run tooling ephemerally (nothing installed into the repo). **Skip any block whose target doesn't exist** and record it as skipped.

1. **Run automated checks**:

   **YAML / GitHub workflows** (if `.github/workflows` exists):
   ```bash
   uvx yamllint -d '{extends: default, rules: {line-length: {max: 160}}}' .github/workflows
   uvx check-jsonschema --schema github-workflow --base-dir . .github/workflows/*.yml
   ```

   **Python syntax** (auto-discover dirs containing `.py`, skip venvs/caches):
   ```bash
   python -m compileall -q $(git ls-files '*.py' | xargs -n1 dirname | sort -u) 2>/dev/null || \
   python -m compileall -q .
   ```

   **Markdown link check** (if `README.md` exists):
   ```bash
   npx --yes markdown-link-check@3.12.2 README.md
   ```

   **Dependency audit** (only if `requirements*.txt` present):
   ```bash
   for f in $(git ls-files '*requirements*.txt'); do
       uvx --from safety safety check --full-report --file "$f"
   done
   ```

   > If the project uses a different toolchain (e.g. JS/TS), substitute the equivalent isolated commands (`npx eslint`, `npm run lint`, project `build`/`test` scripts) discovered from its config. Never install globally. If the plan specifies its own "Automated Verification" commands, run those too and record pass/fail.

2. **Coding convention & bad-practice scan** — review the diff for common issues, independent of any standards doc:
   - **Secrets / credentials** hardcoded (keys, tokens, passwords, connection strings).
   - **Debug leftovers** — stray prints, `console.log`, commented-out code, `TODO`/`FIXME` without tracking.
   - **Error handling** — swallowed exceptions, bare `except:`, ignored return values, missing input validation.
   - **Naming & consistency** — deviations from the surrounding file's existing style.
   - **Dead / duplicated code** and obvious complexity that could be simplified.
   - **Resource safety** — unclosed files/connections, missing cleanup.
   - **Security basics** — injection risks, unsafe deserialization, unvalidated external input.
   - If the project *has* standards docs (`CONTRIBUTING.md`, `.editorconfig`, style guides), check against them too. If not, apply the general list above.

3. **Think deeply about edge cases**:
   - Were error conditions handled?
   - Are there missing validations?
   - Could the implementation break existing functionality (regressions)?

### Step 3: Plan Validation *(skip entirely if no plan was provided)*

For each phase in the plan:

1. **Check completion status**:
   - Look for checkmarks in the plan (`- [x]`).
   - Verify the actual code matches claimed completion.

2. **Verify success criteria**:
   - Confirm each automated criterion (using results from Step 2).
   - List manual criteria that require human testing with clear steps.

3. **Document drift** — anything implemented differently than planned:
   - Check the plan's "## Deviations from Plan" section if present.
   - For each deviation: assess whether it is justified, its impact on success criteria, and any follow-up needed.
   - Note additional undocumented deviations found during review.

### Step 4: Generate Validation Report

Produce a concise report using the template below.

- **If a plan was reviewed**: write it to `agents/reviews/` with a filename matching the timestamp, commit, and the plan (e.g. reviewing `plan-feature-x.md` for commit e99ab0f... → `agents/reviews/<timestamp>_<commit>_feature-x-review.md`; create the dir if needed).
- **If no plan was reviewed**: output the report inline, and write it to `agents/reviews/` with a filename just matching the timestamp and commit (e.g. `agents/reviews/<timestamp>_<commit>_review.md`) and omit the plan-specific sections.

```markdown
## Validation Report: [Plan Name or Commit Range]

### Tooling & Automated Verification
✓ YAML lint        | ⏭ skipped (no workflows) | ✗ failed
✓ Python syntax    | ...
✓ Markdown links   | ...
✓ Dependency audit | ⏭ skipped (no requirements files)
✓ Plan commands: e.g. `turbo build`, `turbo test` (omit if no plan)

### Convention & Bad-Practice Scan
- [findings, or "no issues found"]

### Plan Review Findings (Omit if no plan was provided)

#### Implementation Status
✓ Phase 1: [Name] - Fully implemented
✓ Phase 2: [Name] - Fully implemented
⚠️ Phase 3: [Name] - Partially implemented (see issues)

#### Matches Plan:
- Database migration correctly adds [table]
- API endpoints implement specified methods
- Error handling follows plan

#### Deviations from Plan:
- Check the plan's "## Deviations from Plan" section (if present)
- For each deviation noted:
  - **Phase [N]**: [Original plan vs actual implementation]
  - **Assessment**: [Is the deviation justified? Impact on success criteria?]
  - **Recommendation**: [Any follow-up needed?]
- Additional deviations found during review:
  - Used different variable names in [file:line]
  - Added extra validation in [file:line] (improvement)

### Manual Testing Required:
e.g.
1. UI functionality:
   - [ ] Verify [feature] appears correctly
   - [ ] Test error states with invalid input

2. Integration:
   - [ ] Confirm works with existing [component]
   - [ ] Check performance with large datasets

### Verdict
- **Blocking issues:** [list or "none"]
- e.g:
    - Missing index on foreign key could impact performance
    - No rollback handling in migration
- **Recommendations:** [list]
- e.g:
    - Address linting warnings before merge
    - Consider adding integration test for [scenario]
    - Document new API endpoints
```

### Step 5: Resolve & Record

- Fix any blocking failures before finishing; if a failure is intentional, document why.
- Fold the results into your commit template's Testing section.
- **If reviewing against a plan/ticket**: update the ticket file's frontmatter status to `reviewed`.

## Working with Existing Context

- Review the conversation history.
- Check your todo list for what was completed.
- Focus validation on work done in this session.
- Be honest about any shortcuts or incomplete items.

## Important Guidelines

1. **Be thorough but practical** - Focus on what matters
2. **Run all automated checks** - Don't skip verification commands (unless the target is absent — then note it as skipped)
3. **Document everything** - Both successes and issues
4. **Think critically** - Question if the implementation truly solves the problem
5. **Consider maintenance** - Will this be maintainable long-term?
6. **Do not use task subagents** - All review work should be done exclusively in the main context to maintain consistency and avoid fragmentation
7. **Keep tooling isolated** - Nothing installed here should be committed to the repo; tools run and vanish. Pin versions where reproducibility matters (`markdown-link-check@3.12.2`); otherwise let `uvx`/`npx` fetch latest.

## Validation Checklist

Always verify:
- [ ] All phases marked complete are actually done (if a plan was provided)
- [ ] Automated tests/checks pass
- [ ] Code follows existing patterns
- [ ] No regressions introduced
- [ ] Error handling is robust
- [ ] Documentation updated if needed
- [ ] Manual test steps are clear

The validation works best after commits are made, as it can analyze the git history to understand what was implemented.

Remember: Good validation catches issues before they reach production. Be constructive but thorough in identifying gaps or improvements.

**review**

$ARGUMENTS
