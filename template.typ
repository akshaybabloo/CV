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
#let prose-size = 10pt

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

/// A block of address lines, one per line, with placeholder lines dropped.
///
/// - lines (array): the address lines
/// -> content
#let address-block(lines) = lines.filter(l => l != "").map(l => [#l]).join(linebreak())

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

/// A full width hairline in the accent colour.
/// -> content
#let hrule = line(length: 100%, stroke: 0.6pt + accent)

/// Renders the contact entries of an `additional_info` mapping, in a fixed
/// order so the row does not reshuffle when the data file is reordered. Takes
/// the mapping rather than reading it, keeping this file free of data.yaml.
///
/// - info (dictionary): the contact fields to render
/// -> array
#let contact-links(info) = {
  let items = ()
  if sys.inputs.keys().contains("phone_number") {
    items.push([#sys.inputs.at("phone_number")])
  }
  if "email" in info {
    items.push(linker("mailto:" + info.email, info.email))
  }
  for key in ("linkedin", "github", "website") {
    if key in info {
      items.push(linker(info.at(key), info.at(key).replace("https://", "")))
    }
  }
  items
}

/// The document title block: name over a row of contact links. Shared by every
/// document so the three of them read as one set of stationery.
///
/// - name (string): the name to display
/// - links (array): contact entries, already rendered
/// - rule (bool): whether to close the block with a hairline
/// -> content
#let title-block(name, links, rule: false) = {
  align(center, {
    text(name, fill: accent-dark, size: 24pt, tracking: 0.8pt)
    v(2pt)
    set text(size: 9.5pt)
    links.join(text(" | ", fill: luma(170)))
  })
  if rule {
    v(4pt)
    hrule
  }
}

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

/// Document-wide styling, applied with `show: cv-theme(name, doc_type)`. Every
/// document goes through this, so they cannot drift apart.
///
/// `prose` switches the typographic preset. The CV and resume are dense
/// reference documents: small, tightly led, ragged right, never hyphenated. A
/// cover letter is continuous prose, so it wants a larger size, more leading
/// and justification — and once justified it needs hyphenation back on, or the
/// word spacing goes ragged.
///
/// - name (string): the name shown in the page footer
/// - doc_type (string): the kind of document, used in the PDF title
/// - prose (bool): use the letter typography rather than the dense CV preset
/// -> function
#let cv-theme(name, doc_type, prose: false) = doc => {
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
  set text(
    font: "Roboto",
    size: if prose { prose-size } else { body-size },
    fallback: true,
    hyphenate: prose,
  )
  set par(
    justify: prose,
    leading: if prose { 0.75em } else { 0.62em },
    spacing: if prose { 0.95em } else { 0.62em },
  )
  set list(indent: 6pt, spacing: 0.62em, body-indent: 5pt)
  doc
}
