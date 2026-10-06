---
name: create-eng-figjam
description: Create or improve engineering FigJam boards with editable architecture diagrams, implementation steps, code examples, file trees, and source references. Use for engineering mind maps, service communication diagrams, and project or migration boards in FigJam.
---

# Create engineering FigJam boards

Build a simple, clear board that a person can edit by hand later. These are personal defaults. Apply the user's current instructions and preserve deliberate edits on an existing board.

## Establish context and evidence

- Inspect the supplied board and any example nodes before changing it. References to an existing board mean edit that board. Create a new file only when requested or when the destination is genuinely unspecified and creation follows from the task.
- Prefer connected Figma production tools unless the user chooses another environment. Load the installed `figma-use` and `figma-use-figjam` skills before JavaScript reads or writes. Load the appropriate creation or diagram skill before calling its corresponding tool.
- A request to create or edit the board authorizes the relevant board work. Continue within that scope without repeatedly asking for permission. It does not authorize changing repository code, PRs, Google Docs, sharing settings, or accounts.
- If file access fails, diagnose the connected account and the exact file permission. Request only the access needed for the task. Do not broaden sharing as a workaround.
- Read the relevant code, PRs, and docs before making factual claims. Use the linked commit when illustrating a code snapshot. Distinguish observed status from intended architecture, pending work, and unverified readiness.

## Organize the explanation

Choose sections that explain the actual project. Common useful parts are:

- **Context:** what changes, why it matters, and how the approach works. Put the main design docs and repository entry points here.
- **Implementation:** necessary steps and components, with examples beside the behavior they explain.
- **Service architecture:** actual communication between producers, gateways, receivers, queues, and workers. Show transport branches, authentication, responses, and error or retry behavior when relevant.
- **Rollout:** prerequisites, sequencing, flags, verification, monitoring, and rollback supported by the evidence.
- **Where the code lives:** a truncated repository tree with callouts for important files.
- **References:** job or component identities, PRs, and other sources. Keep receiver and adoption PRs distinguishable when there are paired changes.

Favor a left-to-right reading order and enough spatial spread to follow the work. Adapt these parts to the task rather than forcing a fixed template. Include `[written with AI]` once in a visible board location. Add a dated snapshot when status could become stale.

## Use native, editable elements

| Element | Default |
| --- | --- |
| Sections | Native named sections. Titles name the section. Put explanatory text in its content elements. |
| Layer structure | Every section guide, sticky, text box, code block, card, and connector is a direct page child. No groups or structurally nested sections. Sections may visually surround other sections. |
| Sticky notes | Regular square notes, normally 240 px wide. Use **Small**, which is 16 px. Let height grow enough to fit the text. |
| Longer text | Use a text box when content would require a wide or excessively tall sticky. |
| Code examples | Native code blocks with the correct language. Start around 1,288 px wide so filenames and ordinary code lines fit. |
| File trees | Editable text boxes in a monospace font, with range formatting for emphasis. Never use a code block for a file tree. |
| Connectors | Black `ELBOWED` connectors. Prefer straight runs by aligning endpoints, and bend only when necessary. Use rounded elbows where the editor supports them. |

Use coordinated pastel section and sticky colors to distinguish related areas. Keep their meaning consistent across the board. Use default FigJam elements, readable contrast, and additional padding inside every element and guide.

### Sticky text and visual cues

- Use short, focused text. Apply bold to useful headers and key terms, and italics to qualifiers. Do not bold entire notes by default.
- Render identifiers and filenames outside code blocks in a monospace/code font. In plain-text contexts, use backticks such as `base_controller.rb`. Apply the code font to the full identifier, including placeholders such as `<job>_controller.rb`.
- Omit sentence-ending periods immediately before a hard line break or at the end of a sticky. Preserve punctuation between sentences in the same paragraph, filename extensions, decimals, URLs, and `...` placeholders.
- Use emoji where they help scanning. Use **🔨 for PRs** and **🔍 instead of arrow emojis**. Other useful cues include 📄 for docs, 🧩 for source files, 📦 for contracts, 🔒 for authentication, 🚦 for flags, and 📬 for queued work.

### Bare links with descriptive notes

- Use visible, clickable bare URL cards. Do not hide a link behind descriptive prose in a sticky.
- Attach a descriptive sticky that says what the source is and why it matters. Omit redundant captions such as "Commit permalink."
- Place the card over the sticky's bottom-right corner. A useful starting offset is `x = sticky.x + 128` and `y = sticky.y + sticky.height - 16`.
- Paint the card above the sticky. If the card background and URL text are separate nodes, both remain page-level, with the URL text above its background.
- Keep the visible URL and hyperlink destination identical. Use GitHub commit permalinks where possible, retaining line anchors only when they cover the displayed excerpt. Prefer a whole-file commit link when an expanded excerpt spans more code. Include relevant PR and Google Docs links without copying unnecessary private content onto the board.

### Code examples and file-tree callouts

- Show enough surrounding implementation to explain adoption: types or schemas, the actual call site, request envelope, transport or flag branch, and meaningful error handling as relevant. Avoid isolated lines that require guessing their context.
- Include the source filename in a language-appropriate comment. Use `// ...` for omitted Go, TypeScript, Rust, or similar code, and `# ... existing implementation` for omitted Ruby or shell implementation. Preserve behavior and identifiers. Do not invent helpers, simplify away important checks, or silently fix a source typo in an excerpt.
- Set the language explicitly. Use `PLAINTEXT` for a language unsupported by the current native picker, and explain the limitation only when it matters.
- Represent a truncated tree in a monospace text box. Connect explanatory stickies to the actual filename coordinates within the text box, rather than its distant outer edge. Update those target offsets when tree content or typography changes.

## Reflow and verify

Read [FigJam operations and recovery](references/figjam-operations.md) before geometry changes, native code-block edits, or syntax-highlighting repair. It covers flat-layer movement, width limitations, and the delete-and-Undo workaround.

- After adding, moving, deleting, replacing, or resizing elements, run a **shift check** for that mutation batch. Check intended displacement, nearby spacing, containment, accidental overlaps, valid connector anchors, card stacking, and flat page-level parenting.
- Reflow dependent notes, cards, neighboring sections, parent guides, and reference rows together. After deleting a section, reorganize the remaining layout to use the freed space.
- Useful starting gaps are 120 px between a parent guide and child guides, 200 px between major sibling sections, 160 px between example subsections, 40 px around code within its guide, and 64 px between code and reference notes. Treat these as starting values, not a substitute for visual inspection.
- Keep connector lanes clear. A 120 px horizontal gap is often sufficient for a simple row. Converging service connections need more room. The validated producer-to-gateway corridor used 560 px.
- Point destination arrows at the receiving component or referenced file. Normally use no source arrow and one destination arrow. Use two arrowheads only when the relationship is actually bidirectional.
- Take screenshots after composition and after a visual fix. Inspect both the overall reading order and representative details. Correct cramped text, wrapped filename labels, inconsistent spacing, accidental crossings, and clipped content. Stop after the requested result passes the latest relevant checks.
- Report what changed and what was verified. Disclose any tool limitation that leaves a requested part incomplete, including syntax highlighting that still needs editor interaction.
