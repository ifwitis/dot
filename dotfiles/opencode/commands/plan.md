---
description: Transform a user's informal specification.md into a formalized, deterministic development plan through a phased, iterative process. Produces an ARCHITECTURE.md decisions file and a detailed <feature>_plan.md that agents can later execute and review. Provide the specification file path in the arguments. Run this at the start of a project or feature to align on design before any implementation begins.
model: "opencode/laguna-s-2.1-free"
---

# Generate Plan

You are tasked with converting a user's informal, manually-written `specification.md` into a rigorous, low-ambiguity development plan. Your objective across every phase is to **answer as many open questions as possible before writing code**, minimizing the nondeterminism of the eventual implementation. You do this by researching, proposing, and confirming design decisions *with the user* rather than silently filling gaps.

This is a **single-context, human-in-the-loop** process. You do not spawn subagents for the planning work itself, and you **must stop and wait for user confirmation at the gates between phases**. Filling in blanks with your own design suggestions is encouraged — but only *after* you have surfaced the decision, its tradeoffs, and given the user a chance to redirect.

All artifacts produced by this command live under the **`AGENTS/`** directory at the project root (create it if it does not exist):
- `AGENTS/ARCHITECTURE.md` — formalized design decisions
- `AGENTS/plans/<feature>_plan.md` — the detailed, executable plan
- (later, at execution/review time) `AGENTS/reviews/` — validation reports

Input argument: a path to the user's informal specification file.

specification target:

$ARGUMENTS

---

## Guiding Principles

1. **Determinism over speed** — the entire point is to remove ambiguity. A plan with open questions is not finished.
2. **Ask before assuming** — when the spec is silent on a decision that materially affects the design, ask. Only default to your own judgment for low-stakes choices, and even then, document them so the user can veto.
3. **Research-backed decisions** — every non-trivial tech-stack, service, or architectural choice must be justified with concise reasoning, not asserted.
4. **Human gates are hard stops** — Phases 1, 2, and 4 require explicit user approval before proceeding. Do not advance the todo list past a gate on your own.
5. **Respect existing work** — if the project is not a blank slate, discover and honor existing patterns, files, and prior plans before proposing changes.
6. **Traceable** — every requirement in the spec should map forward to an architecture decision, and every architecture decision should map forward to a plan phase.
7. **Concise but descriptive** — documents should be readable in one pass; prefer clear prose and tables over walls of text.

Use the `todowrite` tool to create a structured task list mirroring the phases below. Mark each phase (and its sub-steps) as `pending` initially, `in_progress` when active, and `completed` only after the corresponding user gate is cleared. **Do not** batch-complete phases; the user gates exist precisely to prevent this.

Suggested todo list:
- [ ] Phase 0: Research & Architecture Design → produce `AGENTS/ARCHITECTURE.md`
- [ ] Phase 1: Refinement → iterate ARCHITECTURE.md with user (GATE)
- [ ] Phase 2: Initial Plan Staging → propose stage/timeline (GATE)
- [ ] Phase 3: Details → write `AGENTS/plans/<feature>_plan.md`
- [ ] Phase 4: Review → iterate plan to zero open questions (GATE) → finalize

---

## Phase 0: Research and Architecture Design

**Goal:** Formalize the informal `specification.md` into a concrete `AGENTS/ARCHITECTURE.md` decisions file.

### Step 0.1 — Read the specification completely
Read the file at `$ARGUMENTS` in full. Extract and list:
- **Stated use cases** — what the user explicitly wants the system to do.
- **Explicit constraints** — anything the user has already decided (language, framework, deadline, hosting, budget, style).
- **Referenced files** — any existing files/directories the user points to (see Step 0.2).
- **Silences** — every place the spec is vague or missing a decision. These become your research + clarification agenda.

### Step 0.2 — Determine blank-slate vs. existing codebase
- **Blank slate:** proceed to research (Step 0.3) with a clean design.
- **Existing work:** before designing, gather context in the main context:
  - Locate the relevant files the user mentioned and read them.
  - Analyze existing structure, conventions, dependencies, and data models.
  - Look for any prior plans (`AGENTS/plans/`), prior reviews (`AGENTS/reviews/`), or an existing `ARCHITECTURE.md` to build on rather than replace.
  - Note what already exists so the architecture reflects reality, not a greenfield fantasy.

### Step 0.3 — Research the gaps
For each silence and each non-trivial decision, research to develop the rest of the design that the user did **not** specify. Consider, at minimum:
- **Tech stack** — languages, frameworks, runtimes, build tooling, and their fit for the stated use cases.
- **Services & APIs** — third-party services, auth providers, storage, queues, external APIs; their pricing/limits/lock-in tradeoffs.
- **Data layer** — database choice, schema shape, migrations approach.
- **Interfaces** — API endpoints/contracts, CLI surface, or UI surface as applicable.
- **Non-functional requirements** — security, performance, scalability, observability, accessibility — infer sensible targets where the user is silent.

### Step 0.4 — Ask clarifying questions
If any silence is high-stakes (i.e., picking wrong would force a rewrite), **ask the user now**, before writing the architecture. Group questions logically and explain why each matters. Do not proceed on high-stakes ambiguity.

### Step 0.5 — Write / update ARCHITECTURE.md
Create or modify `AGENTS/ARCHITECTURE.md` using the template below. Every decision must carry a short **reasoning** note. Distinguish clearly between decisions the *user specified* and decisions *you are proposing* (mark proposals so the user knows what to scrutinize in Phase 1).

#### Template: `AGENTS/ARCHITECTURE.md`
```markdown
# Architecture: [Project / Feature Name]

> Status: draft (Phase 0) | last updated: [timestamp]
> Source spec: [path to specification.md]
> Codebase state: blank-slate | existing (see Context)

## 1. Description
[One-paragraph summary of what is being built and for whom.]

## 2. Background & Context
- **Problem statement:** [why this exists]
- **Use cases:** [enumerated, from the spec]
- **Existing codebase context:** [relevant files analyzed, prior plans; or "N/A — blank slate"]
- **Assumptions:** [things taken as given]

## 3. Goals & Non-Goals
- **Goals:** [what success looks like]
- **Non-goals / out of scope:** [explicitly excluded]

## 4. Tech Stack
| Layer | Choice | Source | Reasoning |
|-------|--------|--------|-----------|
| Language/runtime | ... | user-specified / proposed | ... |
| Framework(s) | ... | ... | ... |
| Build/tooling | ... | ... | ... |
| Testing | ... | ... | ... |

## 5. Services & External APIs
| Service/API | Purpose | Alternatives considered | Reasoning / tradeoffs |
|-------------|---------|-------------------------|-----------------------|
| ... | ... | ... | ... |

## 6. Data Model
- **Store(s):** [db/choice + reasoning]
- **Key entities & relationships:** [tables/collections, brief]
- **Migration strategy:** [...]

## 7. Interfaces & Contracts
- **API endpoints:** [method, path, purpose] (if applicable)
- **CLI / UI surface:** [if applicable]
- **Auth model:** [...]

## 8. Proposed File / Directory Structure
```
[tree of intended layout, noting new vs. existing]
```

## 9. Non-Functional Requirements
- **Security:** ...
- **Performance:** ...
- **Scalability:** ...
- **Observability / logging:** ...

## 10. Key Design Decisions (Decision Log)
| # | Decision | Options considered | Chosen because | Source |
|---|----------|--------------------|----------------|--------|
| 1 | ... | ... | ... | user / proposed |

## 11. Open Questions
- [ ] [anything still unresolved — must be empty before Phase 2 completes]
```

**Do not advance to Phase 1 until the ARCHITECTURE.md exists and is internally consistent.**

---

## Phase 1: Refinement *(HUMAN GATE)*

**Goal:** Iterate the ARCHITECTURE.md with the user until the design is agreed upon.

1. **Hand off for review:** Tell the user the ARCHITECTURE.md is ready and ask them to review, question, or challenge any design choice — especially the ones marked *proposed*.
2. **Wait.** Do not proceed until the user responds.
3. **On feedback:** for each point the user raises, conduct *deeper* research and then do one of:
   - **Accept** the user's redirection and update the doc, or
   - **Push back** with evidence if the research supports the original choice (be honest, not deferential), or
   - **Revamp** the affected design if research reveals a better path.
4. **Present a diff:** show the revised ARCHITECTURE.md **side by side** with the prior version, and for each changed decision surface:
   - what changed, the **tradeoffs**, and clear **pros/cons**.
   - Ask the user to **confirm each changed decision** explicitly.
5. **Repeat** until the user signs off on the architecture. Update the `Status` line to `approved (Phase 1)` and record the sign-off. Only then mark this phase complete.

---

## Phase 2: Initial Plan Staging *(HUMAN GATE)*

**Goal:** Turn the approved architecture into a proposed development plan broken into stages, with a rough timeline — before writing the detailed plan.

1. Devise a **staged development plan**: order the work into logical stages/milestones with dependencies made explicit (what must exist before what).
2. Present to the user:
   - **Overall goals** restated from the architecture.
   - **The stages** — each with a name, one-line objective, key deliverables, and rough sequencing/timeline.
   - **Critical path & dependencies** between stages.
   - **Risks** and where they sit in the timeline.
3. Ask for **approval or feedback on the staging structure**. Iterate until the user *completely* approves the shape of the plan.
4. **Do not** write the detailed plan until the staging is approved. Mark this phase complete only after explicit approval.

---

## Phase 3: Details

**Goal:** Expand the approved staging into a verbose, executable `AGENTS/plans/<feature>_plan.md`.

Name the file after the feature (kebab-case, e.g. `AGENTS/plans/user-auth_plan.md`). Follow the template below. Be thorough — this is the document a future execution agent and the `review.md` command will rely on, so it must be as unambiguous as possible.

#### Template: `AGENTS/plans/<feature>_plan.md`
```markdown
---
title: [Feature Name] Plan
status: draft   # draft | approved | in-progress | reviewed
architecture: ../ARCHITECTURE.md
created: [timestamp]
---

# [Feature Name] — Development Plan

## Overview
[2–4 sentences: what this plan delivers and how it maps to the architecture.]

## Current State
[Where the codebase is today relative to this feature. Reference concrete files/modules. "Greenfield" if nothing exists yet.]

## Desired End State / Goals
[Concrete description of the world after this plan is executed. What can the user do that they couldn't before? Tie each goal to a verifiable outcome.]

## Out of Scope
[Explicit exclusions — what this plan deliberately does NOT do.]

## Constraints for the Implementing Agent
[Hard rules: do not touch X, must use Y, must preserve backward compatibility with Z, coding conventions to follow, etc.]

## Implementation Phases

### Phase A: [Name]
- **Objective:** ...
- **Setup / prerequisites:** ...
- **Changes required:** [file-by-file, function-by-function where possible]
- **Success criteria:**
  - Automated: [commands/tests that must pass — see Testing Strategy]
  - Manual: [what a human must verify]

### Phase B: [Name]
[...same structure...]

### Phase [Testing]: Testing  *(mandatory)*
[See Testing Strategy section — define exactly what tests are added and how they are run.]

### Phase [CI/CD]: CI/CD  *(include for larger/complete features)*
[Pipeline steps, environments, deploy/rollback strategy — omit only if genuinely trivial.]

## Testing Strategy
[Filled per the guidelines below.]

## Best Practices to Follow
[Filled per the guidelines below — DB, refactoring, testing, new-feature integration.]

## Agent Behavior & Execution Rules
[Filled per the guidelines below.]

## Open Questions
- [ ] [MUST be empty before the plan is finalized.]
```

### Testing Strategy — required guidance to bake into every plan
Define, concretely, for this feature:
- **Test types & when to use them:**
  - **Unit tests** (white-box) — isolate individual functions/modules; mock dependencies.
  - **Integration tests** — verify components work together (e.g., API ↔ DB), preferably black-box against real-ish interfaces.
  - **End-to-end / functional tests** — full user flows where applicable.
  - **Regression tests** — automated checks that guard previously-fixed behavior; run on every change.
- **Success criteria classification** — for every phase, explicitly split criteria into:
  - **Automated validation** — things the agent can run and verify itself (build passes, `test` suite green, linters clean, type-checks pass, migrations apply). List the exact commands.
  - **Manual validation** — things requiring human supervision (visual UI checks, UX judgment, external-service credentials, destructive/prod-adjacent actions). List clear step-by-step instructions for the human.
- **Coverage expectations** — what must be tested before a phase is considered done (new logic paths, error/edge cases, boundaries).

### Best Practices — required section to include in the plan
- **Databases:** always use migrations (never edit schema by hand in place); make migrations reversible; never run destructive operations without an explicit, backed-up, human-approved step; seed/test data must be isolated from production.
- **Refactoring:** refactors are behavior-preserving — keep tests green throughout; document what changed and why; do it in separate commits from feature work.
- **Testing:** **never delete or weaken tests just to make them pass** — fix the code or, if the test is genuinely wrong, document the reasoning and get human sign-off. Add tests alongside new code, not after.
- **New features (full-stack):** define the contract first (API/schema), implement backend + its tests, then frontend against the real contract, then integration tests across the boundary; keep backend and frontend changes coherent within the plan.
- **Documentation:** update relevant docs/README/comments as part of the change, especially for refactors and new public interfaces — treat undocumented changes as incomplete.

### Agent Behavior & Execution Rules — required section to include in the plan
- **Subtask generation & responsibility:** define when the executing agent may break work into subtasks, and that each subtask must have a clear owner/outcome; the parent context remains responsible for integration.
- **Wait for completion:** the agent must not start a dependent phase until the prior phase's automated success criteria pass; must not mark work complete on unverified claims.
- **Permissions:** enumerate what the agent may do autonomously vs. what requires explicit human approval (e.g., installing global deps, deleting files, touching prod/CI secrets, force-pushing, running migrations).
- **Stop conditions:** if the agent encounters an ambiguity or a decision not covered by the plan, it must stop and ask rather than guess.
- **Commit discipline:** logical, reviewable commits; keep refactors and features separate; write descriptive messages.

---

## Phase 4: Review *(HUMAN GATE → finalization)*

**Goal:** Iteratively refine `<feature>_plan.md` with the user until it is unambiguous and complete, then finalize it.

1. Present the detailed plan and ask the user for feedback: missing phases, thin implementation detail, unstated constraints, and unanswered questions.
2. On each round, fill in the gaps: add missing phases, flesh out implementation steps, tighten constraints, and resolve **Open Questions**.
3. **Hard rule — never finalize with open questions:** if you recognize *any* open question, missing detail, or unresolved decision, the plan is **not** finalized. Surface it and resolve it with the user. This is the primary guard against nondeterministic implementation.
4. **Minimum phase requirements:** every plan must contain at least an **implementation** phase and a **testing** phase. Add a **CI/CD** phase for more complete/production-bound features.
5. Verify the plan self-consistently maps back to ARCHITECTURE.md (every architecture decision is realized by some phase; no phase contradicts the architecture).
6. Iterate until the user is satisfied.
7. **Finalize:** set the plan's frontmatter `status: approved`, ensure the `## Open Questions` section is empty, and confirm to the user that the plan is ready for execution (and later, for the `review.md` command).

---

## Finalization Checklist

Before declaring the planning complete, verify:
- [ ] `AGENTS/ARCHITECTURE.md` exists, is `approved`, and reflects real (not imagined) codebase state.
- [ ] Every high-stakes silence in the original spec was resolved via a user answer or an explicitly-confirmed proposal.
- [ ] Staging was approved by the user (Phase 2) before detailing (Phase 3).
- [ ] `AGENTS/plans/<feature>_plan.md` exists with all required sections filled.
- [ ] Plan contains at least implementation + testing phases (CI/CD where appropriate).
- [ ] Every phase has explicit automated vs. manual success criteria with concrete commands/steps.
- [ ] Testing strategy, best-practices, and agent-behavior sections are complete.
- [ ] `## Open Questions` in the plan is empty.
- [ ] Plan frontmatter `status: approved`.

## Important Guidelines
1. **Respect the gates** — Phases 1, 2, and 4 are hard stops; never proceed without explicit user approval.
2. **All artifacts live under `AGENTS/`** — architecture, plans, and (later) reviews.
3. **Be honest, not deferential** — push back with evidence when research contradicts a request.
4. **No silent assumptions** — every gap you fill is documented and reviewable.
5. **Single context, human-in-the-loop** — no subagents for planning; the user is a required participant.
6. **The plan is the contract** — it will be executed and later validated by `review.md`, so ambiguity here becomes drift there.

Remember: the value of this process is measured by how few decisions the implementing agent has to invent. A great plan makes execution boring and predictable.
