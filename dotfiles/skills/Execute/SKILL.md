---
description: Execute an approved AGENTS/plans/<feature>_plan.md phase by phase, verifying each phase's automated success criteria before advancing. Respects human gates, honors the plan's constraints and agent-behavior rules, and stops on any ambiguity rather than guessing. Provide the plan file path in the arguments. Run this after a plan has been finalized (status: approved) by the plan command.
---

# Execute Plan

You are tasked with **faithfully executing an approved development plan**. The plan is the contract: your job is to realize it exactly, phase by phase, with disciplined verification between phases — not to redesign it. Any decision the plan did not anticipate is a **stop-and-ask** condition, not an invitation to improvise.

This is a **single-context, human-in-the-loop** execution. You verify your own work against the plan's automated success criteria before advancing, and you surface manual-validation steps to the human at the right moments. The eventual `review.md` command will audit your work against this same plan, so drift you introduce here becomes a finding there.

Input argument: a path to a finalized `AGENTS/plans/<feature>_plan.md` file.

plan target:

$ARGUMENTS

---

## Preconditions (verify before doing anything)

1. **The plan exists and is finalized.** Read `$ARGUMENTS` in full. Confirm frontmatter `status: approved` and that the `## Open Questions` section is **empty**.
   - If `status` is not `approved`, or open questions remain: **stop.** Do not execute. Tell the user the plan is not ready and point them back to the `plan` command.
2. **The architecture is available.** Read the referenced `AGENTS/ARCHITECTURE.md` so your implementation choices align with the agreed design.
3. **Clean starting state.** Run `git status`. If the working tree is dirty with unrelated changes, surface this and ask how to proceed before mutating anything.
4. **Understand the whole plan before touching code.** Internalize: Current State, Desired End State, Out of Scope, Constraints, the ordered Implementation Phases, Testing Strategy, Best Practices, and Agent Behavior & Execution Rules. These are binding.

Use the `todowrite` tool to turn **each plan phase into a todo item**, in order, plus a final "manual validation handoff" item. Mark phases `pending` initially, `in_progress` when active, and `completed` only after that phase's **automated** success criteria pass. Do not batch-complete.

---

## Implementation Philosophy

1. **The plan is the source of truth.** Implement what it says. If reality contradicts the plan (a file isn't where it claims, an interface differs), **stop and report the discrepancy** — this is drift, and it must be recorded, not silently absorbed.
2. **Smallest correct change.** Prefer the least invasive implementation that satisfies the phase. Do not opportunistically refactor or "improve" unrelated code — that belongs in a separate, planned effort.
3. **Follow existing patterns.** Match the surrounding code's conventions, naming, and structure over your personal preferences. Consistency beats cleverness.
4. **Contract-first for full-stack work.** Where a phase spans layers, establish the interface/schema first, implement and test the backend against it, then the frontend against the real contract, then integration across the boundary — as the plan's best-practices section dictates.
5. **Leave the tree greener.** Update docs, comments, and READMEs as part of the change. An undocumented new public interface is an incomplete change.
6. **Determinism in, determinism out.** The planning process worked hard to remove ambiguity; honor that by not reintroducing it through improvisation.

---

## Per-Phase Execution Loop

Repeat this loop for **each** Implementation Phase in the plan, in the order given. Do not start a phase until the previous phase's automated criteria have passed.

### 1. Set up
- Mark the phase `in_progress` in the todo list.
- Re-read the phase's **Objective**, **Setup/prerequisites**, and **Changes required**.
- Confirm prerequisites from prior phases actually exist (don't assume — verify).

### 2. Implement
- Make the changes described, file-by-file. Stay within the phase's scope.
- Honor every rule in the plan's **Constraints** and **Agent Behavior & Execution Rules** sections (e.g., "do not touch X", "must preserve backward compat with Z").
- Add tests **alongside** the code per the Testing Strategy — not deferred to the end. New logic paths, error cases, and boundaries get coverage.
- **Never delete or weaken a test to make it pass.** Fix the code. If a test is genuinely wrong, stop and get human sign-off before changing it, and document why.

### 3. Verify (automated)
- Run **exactly the automated success criteria commands** the plan lists for this phase (build, unit/integration tests, linters, type-checks, migration apply, etc.).
- All must pass. If something fails:
  - Fix-forward within scope, then re-run.
  - If the failure reveals a plan gap or a design conflict, **stop and ask** — do not work around the plan.
- Do **not** mark the phase complete on unverified claims. "It should work" is not verification.

### 4. Checkpoint & commit
- Make a **logical, reviewable commit** for the phase with a descriptive message. Keep refactors and feature work in separate commits.
- If the project has a dedicated commit command/workflow, use it; otherwise write a clear conventional message (e.g. `feat(auth): add session token issuance (Phase A)`).
- Note in the commit body which plan phase it satisfies and the verification you ran.

### 5. Update the plan
- Tick the phase's checkboxes in the plan file (`- [x]`).
- Record any **deviation** you had to make in a `## Deviations from Plan` section of the plan (create it if absent): what changed, why, and its impact on success criteria. This is what `review.md` will look for.
- Mark the phase `completed` in the todo list. Advance to the next phase.

---

## Handling the Non-Happy Path

- **Ambiguity / uncovered decision:** stop and ask the user. Do not guess. This is the single most important rule of execution.
- **Discovered drift** (code ≠ plan/architecture): pause, document it, and confirm the correct path with the user before continuing.
- **Blocked automated criteria** you cannot satisfy within scope: stop, explain the blocker, propose options; let the human choose.
- **Scope creep temptation:** if you notice worthwhile work outside the plan, note it as a follow-up recommendation — do not do it now.

---

## Permissions — autonomous vs. human-gated

Follow the plan's own Agent Behavior rules first; where the plan is silent, default to:

**May do autonomously:**
- Create/modify/delete files *within the plan's stated scope*.
- Run project-local, ephemeral tooling (tests, linters, type-checkers, local builds).
- Make scoped commits.
- Apply reversible, non-destructive migrations against local/dev databases.

**Requires explicit human approval (STOP and ask):**
- Installing global dependencies or altering the toolchain.
- Destructive operations (dropping tables/data, `rm -rf`, force-push, history rewrite).
- Anything touching production, CI/CD secrets, or external paid services.
- Running non-reversible migrations, or any migration against shared/prod data.
- Changing a test's intent, or removing tests.
- Deviating from the plan or architecture in any material way.

---

## Manual Validation Handoff

The agent verifies **automated** criteria; the human verifies **manual** criteria. After the final implementation phase passes:

1. Collect every **Manual validation** step from the plan's phases into a single checklist.
2. Present it to the user with clear, reproducible instructions (what to do, what to expect, how to tell pass from fail).
3. **Do not declare the feature done** until either the human confirms the manual steps or explicitly waives them.

---

## Completion

When all phases' automated criteria pass and the work is committed:

1. Ensure the plan file reflects reality: all phase checkboxes ticked, `## Deviations from Plan` complete and honest.
2. Provide a concise execution summary:
   - Phases completed and the verification run for each.
   - Any deviations and why.
   - The manual-validation checklist handed to the human.
   - Recommended next step: run the **`review.md`** command against the resulting commit(s) and this plan to validate the implementation.
3. Leave the plan `status` as `approved` (execution done) — the `review` command is responsible for advancing it to `reviewed`.

---

## Execution Checklist

Always verify:
- [ ] Plan is `status: approved` with no open questions before starting.
- [ ] ARCHITECTURE.md read; implementation aligns with it.
- [ ] Each phase implemented within scope, following existing patterns.
- [ ] Tests added alongside code; no tests deleted/weakened to pass.
- [ ] Automated success criteria run and green before advancing each phase.
- [ ] One logical commit per phase, descriptive messages.
- [ ] Deviations documented in the plan; ambiguities escalated, not guessed.
- [ ] Docs updated for new/changed interfaces.
- [ ] Manual-validation checklist handed to the human.

Remember: great execution is **boring and predictable**. If it starts feeling creative, you've probably left the plan — stop and check.
