#import "resume.typ": section, data

#include "resume.typ"

#{
  set text(font: "Roboto", size: 9pt, fallback: true)

  if "languages" in data {
    section("Languages")
    for language in data.languages {
      [ / #language.language: #language.fluency ]
    }
  }

  if "projects" in data {
    section("Projects")
    for project in data.projects {
      [ / #project.name: #project.description ]
    }
  }

  if "publications" in data {
    section("Publications")
    for publication in data.publications {
      [ / #publication.name: #publication.description ]
    }
  }

  if "awards" in data {
    section("Awards")
    for award in data.awards {
      [ / #award.title: #award.awarded ]
    }
  }
}
