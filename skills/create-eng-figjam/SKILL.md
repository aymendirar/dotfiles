---
name: create-eng-figjam
description: Create or improve engineering FigJam boards with editable current/proposed architecture diagrams, decision and tradeoff stickies, annotated code examples, implementation steps, file trees, and source references. Use for engineering mind maps, service communication diagrams, and project or migration boards in FigJam.
---

# Create engineering FigJam boards

Build a simple, clear board that a person can edit by hand later. These are personal defaults. Apply the user's current instructions and preserve deliberate edits on an existing board.

## Establish context and evidence

- Inspect the supplied board and any example nodes before changing it. References to an existing board mean edit that board. Create a new file only when requested or when the destination is genuinely unspecified and creation follows from the task.
- Prefer connected Figma production tools unless the user chooses another environment. Load the installed `figma-use` and `figma-use-figjam` skills before JavaScript reads or writes. Load the appropriate creation or diagram skill before calling its corresponding tool.
- A request to create or edit the board authorizes the relevant board work. Continue within that scope without repeatedly asking for permission. It does not authorize changing repository code, PRs, Google Docs, sharing settings, or accounts.
- If file access fails, diagnose the connected account and the exact file permission. Request only the access needed for the task. Do not broaden sharing as a workaround.
- Read the relevant code, PRs, and docs before making factual claims. Use the linked commit when illustrating a code snapshot. Distinguish observed status from intended architecture, pending work, and unverified readiness.
- Read supplied Slack threads and their replies. Link the main discussion and relevant related discussions, alongside the PRs and code. Date historical discussions and distinguish their past requirements or limitations from the current code.

## Organize the explanation

Start with the context section. Omit standalone board title and subtitle text boxes. Choose sections that explain the actual project. Common useful parts are:

- **Context:** what changes, why it matters, and how the approach works. Put the main design docs and repository entry points here.
- **Implementation:** necessary steps and components, with examples beside the behavior they explain.
- **Existing mechanisms:** how similar controls or patterns work today, with their purpose, scope, ownership, failure behavior, and limits. Compare them with the proposal where relevant.
- **Service architecture:** for a change to an existing system, show current-state and proposed runtime diagrams beside each other. Show actual communication between producers, gateways, receivers, queues, and workers, including transport branches, authentication, responses, and error or retry behavior when relevant.
- **Rollout:** prerequisites, sequencing, flags, verification, monitoring, and rollback supported by the evidence.
- **Where the code lives:** a truncated repository tree with callouts for important files.
- **References:** job or component identities, PRs, and other sources. Keep receiver and adoption PRs distinguishable when there are paired changes.

Favor a left-to-right reading order and enough spatial spread to follow the work. Adapt these parts to the task rather than forcing a fixed template. Put the dated snapshot, legends, instructions, and `[written with AI]` attribution in stickies. Include the attribution once in a visible board location.

### Decisions, questions, and architecture changes

- Cover each material decision in the source discussions. Distinguish agreed choices from proposals and unresolved alternatives. Ground pros, cons, and tradeoffs in the evidence rather than inventing them to fill a layout.
- Give each decision its own native named section. Include one **What** sticky, a separate green sticky for each **Pro**, and a separate red sticky for each **Con**. Use the standard FigJam red, `#FFB8A8`, for cons. Split distinct benefits and costs rather than putting a pros/cons list in one note.
- Add focused yellow stickies for open questions and discussion points. Use descriptive names rather than artificial identifiers such as `D1` or `Q1`. Reserve numbering for a real dependency order or sequence.
- In the proposed runtime graph, identify what the change **keeps**, **adds**, **overlaps**, or could **replace**. Put explanations and tradeoffs in nearby stickies. Label a possible replacement as a candidate until the evidence establishes that it is implemented or agreed.
- Keep comparisons grounded in the actual project. For example, concurrency, QPS, uniqueness, debounce, and retry controls can have different keys, lifetimes, and failure behavior. Do not imply that similar names mean interchangeable guarantees.

## Use native, editable elements

| Element | Default |
| --- | --- |
| Sections | Use the native section name as the title. Do not repeat it in a title/subtitle text box, including inside decision sections, comparison cards, and code-example guides. |
| Layer structure | Every authored section guide, sticky, technical text box, code block, card, and connector is a direct page child. No groups or structurally nested sections. Sections may visually surround other sections. Preserve native elements' intrinsic internal structure. |
| Sticky notes | Regular square notes, normally 240 px wide. Use **Small**, which is 16 px. Let height grow enough to fit the text. |
| Explanatory prose | Prefer stickies. Split long content into focused notes. Use prose text boxes only when the user requests them or a technical representation requires one. |
| Code examples | Native code blocks with the correct language. Match a supplied reference width exactly. Otherwise start around 1,288 px so filenames and ordinary code lines fit. Check sizing capability early rather than silently accepting a narrow default. |
| File trees | Editable text boxes in a monospace font, with range formatting for emphasis. Never use a code block for a file tree. |
| Connectors | Black `STRAIGHT` connectors where endpoints can align and the route is clear. Use `ELBOWED` only when a bend is necessary. Use rounded elbows where the editor supports them. |

Use coordinated pastel section and sticky colors to distinguish related areas. Keep their meaning consistent across the board and update any color-key sticky after a palette change. Use default FigJam elements, readable contrast, and additional padding inside every element and guide.

### Sticky text and visual cues

- Use short, focused text. Apply bold to useful headers and key terms, and italics to qualifiers. Do not bold entire notes by default.
- Render identifiers and filenames outside code blocks in a monospace/code font, covering the full identifier and any placeholders such as `<job>_controller.rb`. Do not also display literal backticks around code-styled text. Backticks are for plain Markdown contexts or actual source syntax.
- Use colon separators in authored labels and section/layer names: `KEEP: Caller`, `ADD: Enqueue callbacks`, `KEEP / OVERLAP: Worker`, `Pro: Familiar hooks`, and `Con: Callback contract`. Do not use pipe separators for these labels. Preserve actual code operators, identifiers, URLs, and authentic external preview metadata.
- Omit sentence-ending periods immediately before a hard line break or at the end of a sticky. Preserve punctuation between sentences in the same paragraph, filename extensions, decimals, URLs, and `...` placeholders.
- Use emoji where they help scanning. Use **🔨 for PRs** and **🔍 instead of arrow emojis**. Other useful cues include 📄 for docs, 🧩 for source files, 📦 for contracts, 🔒 for authentication, 🚦 for flags, and 📬 for queued work.

### Source links and preview cards

- Match a supplied link-card reference when present. Otherwise prefer compact native link previews: a title, short description, and provider/hostname in a white card with a light border, rounded corners, and subtle shadow. Around 480 x 96 px is a useful starting size. Avoid long bare-URL pills as the default.
- If the API cannot create or retarget native previews, use an editable preview-style card that matches the reference. Link its title, description, and provider to the same verified destination. Keep a supplied native preview when it already points to the right source.
- Attach a descriptive sticky that says what the source is and why it matters. Omit redundant captions such as "Commit permalink."
- Place the card over the sticky's bottom-right corner. A useful starting offset is `x = sticky.x + 128` and `y = sticky.y + sticky.height - 16`.
- Paint the card above the sticky. If the card background and URL text are separate nodes, both remain page-level, with the URL text above its background.
- Verify the actual destination of every card. If displaying a bare URL, keep its text and destination identical. Use GitHub commit permalinks where possible, retaining line anchors only when they cover the displayed excerpt. Prefer a whole-file commit link when an expanded excerpt spans more code. Include relevant Slack, PR, design-document, and Google Docs links without copying unnecessary private content onto the board.

### Code examples and file-tree callouts

- Show enough surrounding implementation to explain adoption: types or schemas, the actual call site, request envelope, transport or flag branch, and meaningful error handling as relevant. Avoid isolated lines that require guessing their context.
- Put context/explanation stickies beside each example, including relevant choices, consequences, failure behavior, and tradeoffs. Let the native example section title identify the example instead of adding another heading text box.
- Include the source filename in a language-appropriate comment. Use `// ...` for omitted Go, TypeScript, Rust, or similar code, and `# ... existing implementation` for omitted Ruby or shell implementation. Preserve behavior and identifiers. Do not invent helpers, simplify away important checks, or silently fix a source typo in an excerpt.
- Set the language explicitly. Use `PLAINTEXT` for a language unsupported by the current native picker, and explain the limitation only when it matters.
- Put raw source in native code blocks without Markdown fences or extra formatting backticks. Preserve backticks that belong to the source language.
- When a user says to make blocks "this wide," measure the supplied node and propagate that width to the other relevant native blocks. If the API cannot resize them, inspect existing blocks for a width template and follow the clone-and-reflow procedure in the operations reference. Re-inspect after a user edits a sample rather than repeating an earlier capability limitation.
- Represent a truncated tree in a monospace text box. Connect explanatory stickies to the actual filename coordinates within the text box, rather than its distant outer edge. Update those target offsets when tree content or typography changes.

## Reflow and verify

Read [FigJam operations and recovery](references/figjam-operations.md) before geometry changes, native code-block edits, or syntax-highlighting repair. It covers flat-layer movement, width limitations, and the delete-and-Undo workaround.

- After adding, moving, deleting, replacing, or resizing elements, run a **shift check** for that mutation batch. Check intended displacement, nearby spacing, containment, accidental overlaps, valid connector anchors, card stacking, and flat page-level parenting.
- Plan all affected memberships and target coordinates from one pre-mutation snapshot. Do not move a section and then discover another section's members from the already-shifted bounds. Use known relationships and IDs as well as geometry.
- Reflow dependent notes, cards, neighboring sections, parent guides, and reference rows together. After deleting a section, reorganize the remaining layout to use the freed space.
- Useful starting gaps are 120 px between a parent guide and child guides, 200 px between major sibling sections, 160 px between example subsections, 40 px around code within its guide, and 64 px between code and reference notes. Treat these as starting values, not a substitute for visual inspection.
- Keep connector lanes clear. A 120 px horizontal gap is often sufficient for a simple row. Converging service connections need more room. The validated producer-to-gateway corridor used 560 px.
- Point destination arrows at the receiving component or referenced file. Normally use no source arrow and one destination arrow. Use two arrowheads only when the relationship is actually bidirectional.
- Take screenshots after composition and after a visual fix. Inspect both the overall reading order and representative details. Correct cramped text, wrapped filename labels, inconsistent spacing, accidental crossings, and clipped content. Stop after the requested result passes the latest relevant checks.
- Before reporting completion, check for duplicate title/subtitle text boxes across every section and example, literal backticks around styled identifiers, pipe-separated labels, combined pros/cons notes, non-red cons, missing discussion links, and mismatched code widths. Verify that current/proposed comparisons and candidate-replacement labels reflect the evidence.
- Report what changed and what was verified. Disclose any tool limitation that leaves a requested part incomplete, including syntax highlighting that still needs editor interaction.

[written with AI]
