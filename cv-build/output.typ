#import "@preview/cmarker:0.1.3"

#let cv = yaml("../cv.yaml")
#let lightgreen=rgb("#9EC1A3")
#let greyblue=rgb("#818AA3")
#let orange=rgb("#BB7E5D")
#let dark=rgb("#22181C")
#let maroon=rgb("#4C191B")
#let zebra-light = luma(248)
#let zebra-dark = luma(240)
#let zebra = state("zebra", false)

#show link: set text(orange)
#show heading: set text(font: "Inter Display", weight: "bold")
#show heading.where(level: 1): it => {
    text(size: 11pt, tracking: 0.1em, upper(it.body))
}

#set document(author: "Benjamin James Lovell", title: "Ben Lovell's CV")
#set page(
    paper: "a4",
    margin: (
        top: 1.5cm,
        bottom: 1cm,
    ),
)


#set text(font: "Inter Display", lang: "en", fill: dark)
#let dochead(title, subtitle) = move(dx: -3cm, dy: -1.5cm, block(
    fill: dark,
    width: 100% + 6cm,
    height: auto,
    inset: (top:1.5cm, bottom:-0.2cm),
    outset: (bottom: 1cm),
    [
        #set par(leading:8pt)
        #set text(fill:white)
        #align(
            center,
            text(40pt, weight: "bold")[ #title \ ] +
            text(16pt, weight: "light")[ #subtitle ]
        )
    ]
))

#dochead(cv.base.name, cv.base.title)


#set text(9pt, font:"Inter", weight: "light")
#box(inset: (top: -1em))[
    #cmarker.render(cv.base.summary)
]
#v(0.5em)

#set table(stroke: none, inset: 0pt, column-gutter: 1em, row-gutter: 0.6em)
= Links
#grid(columns: (1fr, 1fr), gutter: 2cm,
    box(inset: 0pt, outset: 0pt)[
        #v(-0.4em)
        #table(columns: 2,
            [Email], [#cmarker.render(cv.base.email)],
            [Website], [#link(cv.base.url)],
            [Github], [#cmarker.render(cv.base.github)]
        )
    ],
    box(inset: 0pt, outset: 0pt)[
        #v(-0.4em)
        #table(columns: 2,
            [Bluesky], [#cmarker.render(cv.base.bluesky)],
            [Mastodon], [#cmarker.render(cv.base.mastodon)],
            [LinkedIn], [#cmarker.render(cv.base.linkedin)],
        )
    ],
)

#set list(body-indent: 0em, marker: "- ")
#show box: content => [
    #align(left, content)
]
#let skill-pills(skills) = {
    skills.join("  •  ")
}
#block(fill: zebra-dark, inset: 0.5em, radius: 2pt, width: 100%)[
    = Skills
    #set par(leading: 0.4em)
    #table(columns: (auto, 1fr), gutter: 1em, row-gutter: 0.8em,
        [*Fluent:*], text(8pt, fill: luma(50), font: "IBM Plex Mono")[#skill-pills(cv.base.skills.best)],
        [*Proficient:*], text(8pt, fill: luma(50), font: "IBM Plex Mono")[#skill-pills(cv.base.skills.good)],
        [*Familiar:*], text(8pt, fill: luma(50), font: "IBM Plex Mono")[#skill-pills(cv.base.skills.ok)],
    )
]

#let render-bolded-item(before: "", split-on: " ", after-array: ()) = {
    let after-string = after-array.join(split-on)
    if after-string == none {
        [*#before*]
    } else {
        [*#before*#split-on#after-string]
    }
}

#let bold-first(text, split-on: " ") = {
    let words = text.split(split-on)
    if words.len() > 0 {
        render-bolded-item(before: words.at(0),
            split-on: split-on,
            after-array: words.slice(1))
    } else {
        text
    }
}
#let bold-first-list(..items) = {
    let bold-items = items.pos().map(item => bold-first(item))
    list(..bold-items)
}
#let bold-first-paren(item) = {
    list.item(bold-first(item, split-on: "("))
}

#let experience(name, position, start, end, location, intro, highlights, tech) = block(breakable: false, inset: 4pt)[
    #grid(columns: (3fr, 13fr, 3fr), rows: (auto, auto), column-gutter: 0.8em, row-gutter: 0.3em, inset: 0.25em,
        grid.cell(align: center)[
            #text(7pt, weight: "light")[
                #end\
                #sym.arrow.t\
                #start
            ]
        ],
        [
            #if position != none [
                == #text(weight: "light")[#position -]
                #v(-0.8em)
            ]
            == #name
        ],
        grid.cell(align: right + bottom)[
            #text(9pt, weight: "light")[#emph(location)]
        ],
        [],
        grid.cell(colspan: 2)[
            #v(0.35em)
            #cmarker.render(intro)
            #set list(body-indent: 0.8em, marker: "-", indent: -1.2em)
            #bold-first-list(..highlights)
            #if tech != none [
                #set text(8pt, fill: luma(80), font: "IBM Plex Mono")
                #tech.flatten().join[~#text(fill: orange, baseline: -1.5pt)[◇] ]
            ]
        ],
    )
]

#let experience-compact(name, position, start, end, location, intro, highlights, tech) = block(breakable: false, inset: 3pt)[
    #text(9pt, weight: "bold")[#name] 
    #if position != none [  #text(8pt, weight: "light")[#position]]
    #h(0.3em)#emph[#text(7pt, weight: "light")[#start – #end]]
    \
    #set text(8pt)
    #cmarker.render(intro)
    #if highlights != none [
        #set list(body-indent: 0.5em, marker: "-", indent: 0.5em)
        #bold-first-list(..highlights)
    ]
    #if tech != none [
        #set text(5pt, fill: luma(80), font: "IBM Plex Mono")
        #tech.flatten().join[~#text(fill: orange)[◇] ]
        #v(0.6em)
    ]
]

#v(0.5em)
= Experience
#for exp in cv.experience.slice(0, 4) [
    #experience(exp.orgName, exp.position, exp.startDate, exp.at("endDate", default: "Present Day"), exp.at("location", default: none), exp.intro, exp.at("highlights", default: none), exp.at("tech", default: none))
]

#grid(columns: (1fr, 1fr), column-gutter: 1em,
    ..cv.experience.slice(4).map(exp => experience-compact(exp.orgName, exp.position, exp.startDate, exp.at("endDate", default: "Present Day"), exp.at("location", default: none), exp.intro, exp.at("highlights", default: none), exp.at("tech", default: none)))
)

#block(fill: zebra-dark, inset: 0.5em, radius: 2pt, width: 100%)[
    = Education
    #experience-compact(cv.education.orgName, none, cv.education.startDate, cv.education.endDate, cv.education.location, cv.education.intro, none, none)
]

= Outside responsibilities
#grid(columns: (1fr, 1fr), column-gutter: 1em,
    ..cv.other.map(oth => experience-compact(oth.orgName, oth.position, oth.startDate, oth.at("endDate", default: "Present Day"), oth.at("location", default: none), oth.intro, none, none))
)