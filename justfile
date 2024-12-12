# use PowerShell instead of sh:
set windows-shell := ["pwsh.exe", "-c"]

default: (help)

# Help about using just in this project
@help:
    echo "run 'just choose' to select target "
    echo "run 'just list' to list targets"
    echo "more information can be found at  at http://just.systems/"
    just list

# list the recipies and select one from the list.
choose:
    @just --choose

# list the recipies
list:
    @just --list

#################### Typst ####################

# build the PDF
@build phone-number="":
    typst compile --pdf-standard a-2b --font-path ./fonts cv.typ {{ if phone-number != "" {"--input phone-number=" + phone-number} else {""} }}
    typst compile --pdf-standard a-2b --font-path ./fonts resume.typ {{ if phone-number != "" {"--input phone-number=" + phone-number} else {""} }}
