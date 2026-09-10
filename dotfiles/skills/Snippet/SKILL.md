---
description: Generate an isolated Markdown code snippet implementing a feature in a specified target file, using available project context without modifying the project.
---

## Task
Your task is to generate a snippet of code that implements a feature based on the user's specification. The intended format is a Markdown file readable within your context frame so as not to modify any of the files within the project itself directly. 

Before generating the snippet, verify that the target file, feature requirements, and necessary project context are sufficiently clear. Ask targeted clarification questions only for information that would materially affect the implementation. If the specification is already unambiguous, proceed without asking unnecessary questions. If the user explicitly instructs you to proceed despite unresolved ambiguity, generate the best reasonable implementation using clearly stated assumptions rather than asking further clarification.

The scope of this skill's outputted snippet may be anywhere from a one-line implementation to a function implementation to an entire file, based on what the user wants. The generated implementation must be limited to the target file. If the feature requires changes to other files, do not generate those changes. Instead, identify the required additional changes in the report.

Accompanying the generated code snippet in Markdown, should be a detailed explanation/report of the steps to the feature implementation. 

## Guidelines
1. **Contextual Generation** - Use full context of the project environment, relevant files and code to generate a seamlessly integrated feature/function within the target file. Only inspect files that are available through the current agent/tool environment. Never assume the contents of files that have not been provided or successfully read. 
2. **Insightful Report** - The explanation of the feature implementation steps should first include a brief summary of libraries, dependencies, and API calls used, and the reasoning behind them. The subsequent breakdown of the implementation should break steps apart by sub-concept, only detailing line-by-line if necessary. Each step should detail why this step exists, what it accomplishes, whether alternatives were considered, and fundamentally how it works within the code.
4. **Isolated Snippet** -This skill is read-only with respect to the project. Do not create, modify, delete, rename, or format project files. The only generated artifact is the Markdown response containing the proposed snippet and implementation report.


## Input

The skill receives invocation arguments through `$ARGUMENTS`.

Expected input:
```text
<target-file-path> [relevant-file-path ...] [SPECIFICATION.md]
```

The first path is the required target file. The target file determines the programming language and provides the primary implementation context.

Additional paths are optional project files that provide implementation context. A SPECIFICATION.md path may be supplied when the feature specification is stored separately.

If the target file path is missing, ask the user for it before generating the implementation.

## Output

Produce exactly one Markdown artifact containing:

1. Target file
2. Assumptions / unresolved decisions
3. Complete code snippet for the target file
4. Dependencies and APIs used
5. Implementation explanation
6. Integration notes
7. Testing / verification considerations

The code block must contain only code intended for the target file. Do not include changes to other files inside the code block.
