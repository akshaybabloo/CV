#{
  let data = yaml("data.yaml")

  let darkblue = rgb(0, 0, 128)
  let mediumblue = rgb(0, 0, 205)

  let section(title)={
    v(15pt)
    set text(font: "Consolas", weight: "medium")
    text(title, size: 15pt, fill: mediumblue)
    linebreak()
    v(-10pt)
    line(length: 100%, stroke: mediumblue)
    v(2pt)
  }

  set align(center)
  set text(font: "Consolas", weight: "medium")

  // Personal Information
  text(data.name, fill: darkblue, size: 30pt)
  linebreak()
  v(2pt)
  let count = 0
  let info_length = data.additional_info.len()
  for (key, value) in data.additional_info {
    if "phone_number" == key {
      text([#data.additional_info.phone_number])
      if count < info_length - 1 {
        text(" | ")
      }
    }
    if "linkedin" == key {
      text(
        [#link(
            data.additional_info.linkedin,
          )[#data.additional_info.linkedin.replace("https://", "")]],
        fill: mediumblue,
      )
      if count < info_length - 1 {
        text(" | ")
      }
    }
    if "github" == key {
      text(
        [#link(
            data.additional_info.github,
          )[#data.additional_info.github.replace("https://", "")]],
        fill: mediumblue,
      )
      if count < info_length - 1 {
        text(" | ")
      }
    }
    if "website" == key {
      text(
        [#link(
            data.additional_info.website,
          )[#data.additional_info.website.replace("https://", "")]],
        fill: mediumblue,
      )
      if count < info_length - 1 {
        text(" | ")
      }
    }
    if "email" == key {
      text(
        [#link("mailto:" + data.additional_info.email)[#data.additional_info.email]],
        fill: mediumblue,
      )
      if count < info_length - 1 {
        text(" | ")
      }
    }
    count += 1
  }
  set align(left)

  set par(justify: true)

  if "personal_statement" in data {
    section("Personal Statement")
    text(data.personal_statement)
  }

  if "competencies" in data {
    section("Core Competencies")
  }
}
