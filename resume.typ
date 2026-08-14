#import "template.typ": *

#let data = yaml("data.yaml")

/// shared with cv.typ
#let resume-body = {
  // Personal Information
  title-block(data.name, contact-links(data.at("additional_info", default: (:))))

  // Personal Statement
  if "personal_statement" in data {
    section("Personal Statement")
    par(justify: true, text(data.personal_statement, hyphenate: auto))
  }

  // Core Competencies
  if "competencies" in data {
    section("Core Competencies")
    labelled(
      for c in data.competencies {
        (text(c.name, weight: "medium"), c.competencies.join(dot))
      },
    )
  }

  // Work Experience
  if "experience" in data {
    section("Work Experience")
    entries(
      for work in data.experience {
        (
          date_range(work.start_date, work.end_date),
          {
            text(weight: "bold", work.title)
            text(" at ")
            text(weight: "medium", work.company)
            linebreak()
            detail(work.location)
            v(1pt)
            eval(work.description, mode: "markup")
            let tech = work.at("technologies", default: ())
            if tech.len() > 0 {
              v(1pt)
              text("Technologies: ", weight: "bold")
              tech.join(", ")
            }
          },
        )
      },
    )
  }

  // Education
  if "education" in data {
    section("Education")
    entries(
      for education in data.education {
        (
          date_range(education.start_date, education.end_date),
          {
            text(weight: "bold", education.course)
            linebreak()
            education.institution
            linebreak()
            detail(education.location)
          },
        )
      },
    )
  }

  // Key skills and characteristics
  if "skills" in data {
    section("Key Skills and Characteristics")
    tight-list(data.skills)
  }

  // Activities and Interests
  if "activities" in data {
    section("Activities and Interests")
    tight-list(data.activities)
  }

  // References
  if "references" in data {
    section("References")
    entries(
      for reference in data.references {
        (
          linker("mailto:" + reference.email, reference.email),
          {
            text(weight: "bold", reference.name)
            linebreak()
            reference.position
            linebreak()
            detail(reference.company)
            linebreak()
            reference.phone
          },
        )
      },
    )
  }
}

// ---------------------------------------------------------------- document

#show: cv-theme(data.name, "Resume")
#resume-body
