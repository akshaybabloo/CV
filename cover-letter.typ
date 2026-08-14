#import "template.typ": *

#let data = yaml("data.yaml")
#let letter = yaml("cover-letter.yaml")

#show: cv-theme(data.name, "Cover Letter", prose: true)

// almost same as cv
#title-block(
  data.name,
  contact-links(data.at("additional_info", default: (:))),
  rule: true,
)

#v(18pt)

// Recipient on the left, date on the right, baselines aligned.
#grid(
  columns: (1fr, auto),
  align: (left + top, right + top),
  column-gutter: 24pt,
  {
    let recipient = letter.at("recipient", default: (:))
    let lines = (
      recipient.at("name", default: ""),
      recipient.at("title", default: ""),
      recipient.at("company", default: ""),
      ..recipient.at("address", default: ()),
    )
    address-block(lines)
  },
  {
    let stamped = letter.at("date", default: "")
    text(fill: muted, if stamped != "" {
      stamped
    } else {
      datetime.today().display("[day padding:none] [month repr:long] [year]")
    })
  },
)

#v(18pt)

#{
  let subject = letter.at("subject", default: "")
  if subject != "" {
    text(subject, weight: "bold", fill: accent-dark)
    v(4pt)
  }
}

#letter.at("salutation", default: "")

#v(2pt)

// Joined rather than each followed by a parbreak, so no trailing gap creeps in
// ahead of the sign-off.
#letter.at("body", default: ()).map(p => eval(p, mode: "markup")).join(parbreak())

#v(8pt)

// Keep the sign-off with the name so a page break can never strand a signature.
#block(breakable: false, {
  letter.at("signoff", default: "")
  let signature = letter.at("signature", default: "")
  if signature != "" {
    v(6pt)
    image(signature, height: 34pt)
    v(2pt)
  } else {
    linebreak()
  }
  text(data.name, weight: "medium")
})
