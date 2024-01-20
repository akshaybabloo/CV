#{
  set text(font: "Roboto", size: 9pt, fallback: true)
  let data = yaml("data.yaml")

  let darkblue = rgb(0, 0, 128)
  let mediumblue = rgb(64, 97, 158)

  /// Adds a section title and a line underneath
  /// 
  /// - title (string): the title of the section
  /// -> content
  let section(title)={
    v(15pt)
    set text(weight: "bold")
    text(title, size: 12pt, fill: mediumblue)
    linebreak()
    v(-6pt)
    line(length: 100%, stroke: mediumblue)
    v(2pt)
  }

  /// Adds a link to the document with an underline
  ///
  /// - dest (string): the destination of the link
  /// - label (string): the label of the link
  /// -> content
  let linker(dest, label)={
    underline(text(link(dest)[#label], fill: mediumblue), offset: 2pt)
  }

  set align(center)

  // Personal Information
  text(data.name, fill: darkblue, size: 30pt)
  linebreak()
  v(2pt)
  let count = 0
  let info_length = data.additional_info.len()
  for (key, value) in data.additional_info {
    if "phone_number" == key {
      text([#data.additional_info.phone_number], size: 10pt)
      if count < info_length - 1 [ | ]
    }
    if "linkedin" == key {
      text([#linker(
          data.additional_info.linkedin,
          data.additional_info.linkedin.replace("https://", ""),
        )], fill: mediumblue, size: 10pt)
      if count < info_length - 1 [ | ]
    }
    if "github" == key {
      text([#linker(
          data.additional_info.github,
          data.additional_info.github.replace("https://", ""),
        )], fill: mediumblue, size: 10pt)
      if count < info_length - 1 [ | ]
    }
    if "website" == key {
      text([#linker(
          data.additional_info.website,
          data.additional_info.website.replace("https://", ""),
        )], fill: mediumblue, size: 10pt)
      if count < info_length - 1 [ | ]
    }
    if "email" == key {
      text(
        [#linker("mailto:" + data.additional_info.email, data.additional_info.email)],
        fill: mediumblue, size: 10pt
      )
      if count < info_length - 1 [ | ]
    }
    count += 1
  }
  set align(left)
  set par(justify: true)

  // Personal Statement
  if "personal_statement" in data {
    section("Personal Statement")
    text(data.personal_statement)
  }

  // Core Competencies
  if "competencies" in data {
    section("Core Competencies")
    table(
      columns: (auto, auto),
      align: horizon,
      stroke: 0.5pt,
      ..for competencies in data.competencies {
        ([#competencies.name], [#competencies.competencies.join(", ")])
      },
    )
  }

  // Work Experience
  if "experience" in data {
    section("Work Experience")
    table(
      columns: (90pt, auto),
      align: start,
      stroke: none,
      column-gutter: 25pt,
      row-gutter: 10pt,
      ..for work in data.experience {
        (text(work.start_date + " - " + work.end_date, style: "italic"), [
          *#work.title at #work.company* \
          #emph(work.location) \
          #eval(work.description, mode: "markup")
          #if work.technologies.len() > 0 [
            #v(-3pt)
            *Technologies:* #work.technologies.join(", ")
          ]
        ])
      },
    )
  }

  // Education
  if "education" in data {
    section("Education")
    for education in data.education {
      [
        *#education.course* \
        #education.institution \
        #emph(education.location) \
        #emph(education.start_date + " - " + education.end_date)
        #v(5pt)
      ]
    }
  }

  // Key skills and characteristics
  if "skills" in data {
    section("Key Skills and Characteristics")
    for skill in data.skills {
      [- #skill]
    }
  }

  // Activities and Interests
  if "activities" in data {
    section("Activities and Interests")
    for activity in data.activities {
      [- #activity]
    }
  }

  // References
  if "references" in data {
    section("References")
    for reference in data.references {
      [
        *#reference.name* \
        #reference.position \
        #emph(reference.company) \
        #underline(
          text(link("mailto:" + reference.email)[#reference.email], fill: mediumblue),
          offset: 2pt,
        ) \
        #reference.phone
        #v(5pt)
      ]
    }
  }
}
