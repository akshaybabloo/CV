#import "template.typ": *
#import "resume.typ": data, resume-body

#show: cv-theme(data.name)

#resume-body

// Languages
#{
  let languages = filled(data.at("languages", default: ()), "language")
  if languages.len() > 0 {
    section("Languages")
    labelled(
      for language in languages {
        (text(weight: "medium", language.language), language.fluency)
      },
    )
  }
}

// Projects
#{
  let projects = filled(data.at("projects", default: ()), "name")
  if projects.len() > 0 {
    section("Projects")
    for project in projects {
      block(breakable: false, below: 9pt, {
        if project.at("url", default: "") != "" {
          text(weight: "bold", linker(project.url, project.name))
        } else {
          text(weight: "bold", project.name)
        }
        linebreak()
        project.description
        let tech = project.at("technologies", default: ()).filter(t => t != "")
        if tech.len() > 0 {
          linebreak()
          detail(tech.join(dot))
        }
      })
    }
  }
}

// Publications
#{
  let publications = filled(data.at("publications", default: ()), "name")
  if publications.len() > 0 {
    section("Publications")
    for publication in publications {
      block(breakable: false, below: 9pt, {
        if publication.at("url", default: "") != "" {
          text(weight: "bold", linker(publication.url, publication.name))
        } else {
          text(weight: "bold", publication.name)
        }
        linebreak()
        publication.description
      })
    }
  }
}

// Awards and Scholarships
#{
  let awards = filled(data.at("awards", default: ()), "title")
  if awards.len() > 0 {
    section("Awards")
    entries(
      for award in awards {
        (
          detail(award.at("date", default: "")),
          {
            if award.at("award_url", default: "") != "" {
              text(weight: "bold", linker(award.award_url, award.title))
            } else {
              text(weight: "bold", award.title)
            }
            if award.at("awarded", default: "") != "" {
              linebreak()
              detail(award.awarded)
            }
          },
        )
      },
    )
  }
}
