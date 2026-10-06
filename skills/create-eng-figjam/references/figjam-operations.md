# FigJam operations and recovery

These notes capture behavior encountered while building an engineering board in October 2026. Check the current tool surface before assuming the same limitations still apply. Follow the installed Figma skills for authoritative API usage.

## Preserve flat layers during reflow

Native section guides visually surround content, but every element stays at page level. Moving a guide does not reliably move its peer content. Resizing or moving a section can also recapture peers as children.

1. Capture the current node IDs, absolute positions, dimensions, parent IDs, code, languages, and connector endpoints before a mutation batch. Preserve existing user edits and any experimental nodes.
2. Identify every affected visual section's members using known content relationships and the old bounds before moving any section. Freeze those memberships for the whole batch. Do not rely exclusively on containment when a user has widened a block beyond its current guide. Discovering members after an earlier move can capture another section's content and translate it twice.
3. Compute desired positions and dimensions before applying translations. Accumulate parent and child deltas so no element moves twice accidentally.
4. Move each member explicitly from its captured absolute position. Let connectors with node-based endpoints follow their anchors. Translate floating page-coordinate endpoints explicitly, including intermediate points in multipart routes. Change endpoint offsets when an anchor's dimensions or the target filename coordinates change.
5. Size guides from actual content bounds and padding. Reflow sibling sections and downstream reference rows after code height or width changes. Place source and PR cards side by side beneath wider examples when that makes them easier to read.
6. Reparent any recaptured content to the page while preserving its absolute transform. Recheck all elements after the last section resize.
7. Restore paint order: large section guides, smaller guides, connectors, ordinary content and stickies, card backgrounds, then URL text or native previews.
8. Run the shift check. Validate intended positions, padding, section and card overlaps, connector anchors, and page-level parenting. An intentional card-over-sticky overlap is not a collision.

Load current fonts before text-affecting mutations, cloning, or reparenting. For ordinary text and FigJam text sublayers, collect fonts from `getStyledTextSegments(['fontName'])`, await the loads, then mutate. Code assignments on previously highlighted blocks can also require existing Source Code Pro styles, including Medium Italic. Load available styles or the exact font named by the tool error rather than guessing a style name.

Return every created, mutated, and removed node ID. Respect `safeToRetryWithoutCanvasRead` after an error. If a write may have partially landed, inspect the canvas and recover from its current state before retrying.

Measure every sticky before laying out its row. Use the maximum actual height per row. Calculate horizontal and vertical gaps separately: a wide horizontal connector corridor must not become the vertical gap between sticky rows. Check text-driven height changes before sizing the guides and placing overlapping reference cards.

## Native code-block width

The connected Plugin API exposed code-block width as read-only and had no `resize()` method. Direct width assignment failed, and the convenience `set({width})` path does not supply a missing resize API. A temporary auto-layout container did not expose `minWidth` on the code block either. Transform scaling is not a solution for text wrapping.

Check the current API and existing block widths before composing the examples. A supplied reference width takes precedence over the approximate 1,288 px default. The API-created blocks in this session defaulted to 576 px, which wrapped filenames and ordinary lines. Do not present that narrow default as satisfying the width preference.

Prefer editor resizing when an authorized interaction tool is available. It preserves the existing node ID and avoids a code rewrite.

When resizing is unavailable but a native block of the desired width already exists:

- Clone that wider native block as a width template.
- Restore the destination example's exact source and language on the clone.
- Measure its actual dimensions. Verify that the width was inherited and that text and language match before replacing the original.
- Retarget any references or connector anchors that point at the replaced node. Return the old-to-new ID mapping.
- Delete the original only after the replacement and reflow are ready. Keep the result native and page-level.

After the user widens a sample, read it again and measure its actual width. In this session, an editor-resized sample of about 860 px provided a working clone template for every other block. That is an example of the recovery path, not a new universal default width.

This preserves native editability, but assigning `.code` can lose highlighting or inherit the first character's style across the entire block. Do not claim that a width-template clone preserves syntax colors after its content changes. If no suitable wider native block or resize capability exists, explain the missing capability and offer an editor resize step. Do not silently substitute a different element type.

## Syntax-highlighting recovery

The user reported a working native-editor refresh:

1. Select the code block.
2. Delete it.
3. Immediately restore it with **Undo**.
4. Check syntax colors, source text, language, dimensions, position, and attached connectors.

Use **delete, then Undo** as the preferred recovery when an authorized editor-interaction tool can perform both steps. Treat this as a user-observed workaround rather than a guaranteed API feature.

The connected `use_figma` API did not expose Undo, and no editor automation tool was available in that session. Do not delete a production block expecting an unavailable Undo call to restore it. Keep the block, complete independent layout work, and state that the refresh needs editor interaction. This is a capability limitation, not an extra permission requirement.

Other experiments did not reliably refresh native highlighting:

- Adding and deleting a newline through `.code` assignments.
- Changing assignment order, toggling the language, or selecting the block.
- Cloning a highlighted block and replacing its code.

An unchanged clone preserved colors. That does not prove that editing the clone preserves them. Avoid repeating these experiments as a claimed fix without new evidence.

A syntax-colored, editable monospace text box over a dark rectangle can be a fallback if the user chooses it. Both elements can remain flat and editable, but this loses the native language picker and needs recoloring after edits. Do not silently replace native blocks with that workaround, screenshots, or flattened vectors.

## Screenshots and final checks

- Prefer screenshots that include floating page-level content. If a flat section export shows only its guide, export the page and crop the relevant region. Do not infer missing content from a guide-only image.
- Use a large enough export to inspect code and link cards, then inspect a board overview for reading order and spacing. Local crop tools such as ImageMagick or ffmpeg can avoid repeatedly exporting the same page.
- Compare visible content with the structure checks. Verify native code blocks and matching widths, correct languages, identifiers in code font without visible backticks, Small sticky text, readable padding, verified preview-card links, and card stacking. Native section names supply titles even when the export omits their editor labels. Do not add duplicate text headings to compensate.
- Check straight connectors where endpoints align, sensible elbows elsewhere, black strokes, correct arrowheads, and file-tree endpoints that reach filenames. Give independent connections separate lanes rather than drawing them over the same segment.
- Attached-position connector endpoints in the connected API behaved as node-local pixel offsets, despite helper examples using 0-1 coordinates. Validate the current coordinate behavior visually. A fractional offset placed filename callouts at the text box's top-left instead of on the filename.
- After a delete-and-Undo refresh, check that the restored node retained its identity and geometry before relying on the prior shift check.

## Bounded inspection and mutation results

The tool rejected return values above 20,480 bytes in this session. Read only the relevant node types and fields, split large inspections, and return compact IDs, bounds, counts, or source-match booleans. Avoid dumping the whole page's code, prose, fonts, and repeated URLs in one result.

Check the write result for errors before requesting its verification screenshot or starting dependent writes. A failed script followed by an unchanged screenshot does not verify the intended edit.

[written with AI]
