#{
  set text(font: "Roboto", size: 9pt, fallback: true)
  let data = yaml("data.yaml")

  let darkblue = rgb(0, 0, 128)
  let mediumblue = rgb(0, 0, 205)

  let section(title)={
    v(15pt)
    set text(weight: "bold")
    text(title, size: 12pt, fill: mediumblue)
    linebreak()
    v(-6pt)
    line(length: 100%, stroke: mediumblue)
    v(2pt)
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
      text([#data.additional_info.phone_number])
      if count < info_length - 1 [ | ]
    }
    if "linkedin" == key {
      text(
        [#link(
            data.additional_info.linkedin,
          )[#data.additional_info.linkedin.replace("https://", "")]],
        fill: mediumblue,
      )
      if count < info_length - 1 [ | ]
    }
    if "github" == key {
      text(
        [#link(
            data.additional_info.github,
          )[#data.additional_info.github.replace("https://", "")]],
        fill: mediumblue,
      )
      if count < info_length - 1 [ | ]
    }
    if "website" == key {
      text(
        [#link(
            data.additional_info.website,
          )[#data.additional_info.website.replace("https://", "")]],
        fill: mediumblue,
      )
      if count < info_length - 1 [ | ]
    }
    if "email" == key {
      text(
        [#link("mailto:" + data.additional_info.email)[#data.additional_info.email]],
        fill: mediumblue,
      )
      if count < info_length - 1 [ | ]
    }
    count += 1
  }
  set align(left)
  set par(justify: true)

  set text(weight: "regular")
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
      row-gutter: 8pt,
      ..for work in data.experience {
        (
          text(work.start_date + " - " + work.end_date, style: "italic"), 
          [
            *#work.title at #work.company* \
            #emph(work.location) \
            #work.description \
            #if work.technologies.len() > 0 [
              *Technologies:* #work.technologies.join(", ")
            ]
          ]
        )
      },
    )
  }
}
