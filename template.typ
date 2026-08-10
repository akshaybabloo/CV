// Presentation layer shared by resume.typ and cv.typ.
//
// Design tokens and layout helpers only - nothing here reads data.yaml, so the
// content stays entirely in the documents that import this file.

// ---------------------------------------------------------------- design tokens

#let accent = rgb(64, 97, 158)
#let accent-dark = accent.darken(40%)
#let muted = luma(90)
#let body-size = 9pt
#let detail-size = 8.5pt

// ---------------------------------------------------------------- helpers

/// Adds a section title and a line underneath. The block is sticky so a heading
/// can never be orphaned at the foot of a page.
///
/// - title (string): the title of the section
/// -> content
#let section(title) = block(
  breakable: false,
  sticky: true,
  width: 100%,
  above: 13pt,
  below: 6pt,
  {
    text(title, size: 11.5pt, weight: "bold", fill: accent)
    v(2pt)
    line(length: 100%, stroke: 0.6pt + accent)
  },
)

/// Adds a link to the document, coloured rather than underlined.
///
/// - dest (string): the destination of the link
/// - label (string): the label of the link
/// -> content
#let linker(dest, label) = text(link(dest)[#label], fill: accent)

/// Small grey line used for locations and other secondary detail.
///
/// - body (string, content): the text to render
/// -> content
#let detail(body) = text(body, size: detail-size, fill: muted, style: "italic")

/// Formats a start/end pair as a range. The space before the hyphen is
/// non-breaking so a wrap always falls after it, never orphaning the dash.
///
/// - start (string): the start of the range
/// - end (string): the end of the range
/// -> content
#let date_range(start, end) = detail(start + sym.space.nobreak + "- " + end)

/// The document title block: name over a row of contact links.
///
/// - name (string): the name to display
/// - links (array): contact entries, already rendered
/// -> content
#let title-block(name, links) = align(center, {
  text(name, fill: accent-dark, size: 24pt, tracking: 0.8pt)
  v(2pt)
  set text(size: 9.5pt)
  links.join(text(" | ", fill: luma(170)))
})

/// Two-column date/detail layout shared by every dated section.
///
/// - rows (array): flat array of alternating date and detail cells
/// -> content
#let entries(rows) = table(
  columns: (112pt, 1fr),
  align: (right + top, left + top),
  stroke: none,
  inset: 0pt,
  column-gutter: 16pt,
  row-gutter: 13pt,
  ..rows,
)

/// Compact label/value layout for short one-line pairs. Kept off the dated
/// `entries` grid, whose row spacing is far too airy for single lines.
///
/// - rows (array): flat array of alternating label and value cells
/// -> content
#let labelled(rows) = block(
  breakable: false,
  table(
    columns: (128pt, 1fr),
    align: (left + top, left + top),
    stroke: none,
    inset: 0pt,
    column-gutter: 16pt,
    row-gutter: 5pt,
    ..rows,
  ),
)

/// A bulleted list that will not split across a page break.
///
/// - items (array): the list items
/// -> content
#let tight-list(items) = block(breakable: false, list(..items))

/// The separator between items in a comma-free run-on list.
#let dot = [ #sym.dot.op ]

/// Drops entries whose given field is an unfilled placeholder, so a section
/// holding only template stubs renders nothing at all.
///
/// - items (array): the entries to filter
/// - field (string): the field that must be non-empty
/// -> array
#let filled(items, field) = items.filter(it => it.at(field, default: "") != "")

// ---------------------------------------------------------------- theme

/// Document-wide styling, applied with `show: cv-theme(name)`. Both resume.typ
/// and cv.typ go through this, so the two documents cannot drift apart.
///
/// - name (string): the name shown in the page footer
/// -> function
#let cv-theme(name, doc_type) = doc => {
  set document(
    author: name,
    title: name + " - " + doc_type,
    date: auto
    )
  set page(
    paper: "a4",
    margin: (x: 1.6cm, top: 1.5cm, bottom: 1.4cm),
    footer: context {
      set text(size: 7.5pt, fill: muted)
      grid(
        columns: (1fr, auto),
        name,
        [Page #counter(page).display() of #counter(page).final().first()],
      )
    },
  )
  set text(font: "Roboto", size: body-size, fallback: true, hyphenate: false)
  set par(justify: false, leading: 0.62em, spacing: 0.62em)
  set list(indent: 6pt, spacing: 0.62em, body-indent: 5pt)
  doc
}
