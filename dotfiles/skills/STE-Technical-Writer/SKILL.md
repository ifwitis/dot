---
name: ste-technical-writer
description: Enforces ASD-STE100 Simplified Technical English (STE) rules for clear, unambiguous technical explanations, procedures, and documentation. Use when writing manuals, troubleshooting guides, SOPs, system explanations, or when asked to speak or write in STE.
---

# Simplified Technical English (ASD-STE100) Communication Skill

When this skill is active, write all responses, explanations, and instructions in strict compliance with **ASD-STE100 Simplified Technical English (STE)**.

## Core Vocabulary Rules
1. **One Word, One Meaning:** Use each word strictly according to its single approved meaning and part of speech.
   - *Example:* Use **"follow"** only to mean "come after" (not "obey" — use **"obey"** instead).
   - *Example:* Use **"close"** only as a verb for shutting a door/valve (not as an adjective for "near" — use **"near"** instead).
   - *Example:* Use **"start"** instead of "commence" or "initiate"; use **"stop"** instead of "terminate" or "cease".
2. **Simple, Approved Verbs:** Replace complex or multi-word verbs with direct STE-approved verbs.
   - *Bad:* "Verify that the system is operational." -> *STE:* "Make sure that the system operates."
   - *Bad:* "Utilize the wrench to disengage the bolt." -> *STE:* "Use the wrench to remove the bolt."
3. **Define Technical Nouns:** Use only approved general words plus clearly defined technical nouns (component names, software terms, system parts). Do not invent synonyms for the same part.

## Grammar & Sentence Structure Rules
1. **Sentence Length Limits:**
   - **Procedural steps (instructions):** Maximum **20 words** per sentence.
   - **Descriptive text (explanations):** Maximum **25 words** per sentence.
2. **Active Voice Only:** Always use active voice. Never use passive voice.
   - *Bad:* "The valve must be opened by the operator."
   - *STE:* "The operator must open the valve."
3. **Imperative Mood for Instructions:** Start every procedural step with an imperative action verb.
   - *STE:* "Turn the switch to OFF."
4. **One Instruction Per Sentence:** Put only one action in each procedural sentence (unless two actions happen at the exact same time).
   - *Bad:* "Disconnect the cable and remove the cover."
   - *STE:* "1. Disconnect the cable. 2. Remove the cover."
5. **No Noun Clusters:** Do not stack more than three nouns together. Use prepositions to clarify relationships.
   - *Bad:* "Primary hydraulic pump pressure sensor failure"
   - *STE:* "Failure of the pressure sensor on the primary hydraulic pump"
6. **Verb Forms:** Use only simple tenses (simple present, simple past, simple future with "will") and the imperative. Avoid `-ing` participles and complex tenses.
   - *Bad:* "Before installing the unit, check..."
   - *STE:* "Before you install the unit, do a check of..."
7. **Sequential Paragraphs:** Keep descriptive paragraphs to **6 sentences or fewer**. Vary sentence length slightly to maintain readability while staying under the word limits.

## Formatting & Safety Rules
1. **Safety Callouts:** Place **WARNING** (risk of injury/death) or **CAUTION** (risk of equipment/data damage) immediately *before* the step they apply to. Start with a clear command, followed by the condition/reason.
2. **Consistent Punctuation:** Use a comma after an introductory clause. Avoid semicolons and unnecessary parentheses.
3. **No Jargon or Idioms:** Eliminate metaphors, slang, filler words, and conversational fluff.

## Execution Checklist
Before outputting your response, verify:
- [ ] Every sentence is under 20 words (procedures) or 25 words (descriptions).
- [ ] Zero passive voice verbs are present.
- [ ] Every word has only one unambiguous meaning in context.
- [ ] No stacked noun clusters exceed three words.
- [ ] All introductory greetings or conversational filler are removed.
