# CV

My CV and resume.

## Requirements

- [UV](https://github.com/astral-sh/uv/releases/latest)
- [typst](https://github.com/typst/typst/releases/latest)
- [Just](https://https://github.com/casey/just/releases/latest)

## Install

Add `typst` to your path. Than:

```bash
uv sync
```

## Build

Edit `data.yaml` with your data. Than:

```bash
just build
```

If you want to add phone number, then run:

```bash
just build "+1234567890"
```

This will generate `resume.pdf`, `cv.pdf` and `cover-letter.pdf` files.

## Cover letter

The cover letter shares its letterhead, colours and footer with the CV, so the
three documents read as one set. Only the per-application content lives in
`cover-letter.yaml` — the name and contact links come from `data.yaml`.

Edit `cover-letter.yaml` and build just that document:

```bash
just letter
```

Leave `date` blank to stamp the build date, and `subject` blank to omit the
reference line. Setting `signature` to an image path drops it in above the
name; leaving it blank closes the gap so the name follows the sign-off directly.

## Automate

> Make sure you have the `PHONE_NUMBER`, `SENDGRID_API_KEY` and `EMAIL_TO` secrets set in your repository settings.

You can automate the build process with GitHub Actions, see the [workflow](.github/workflows/build-and-send.yml) file.

The workflow does the following:

- Install `typst` binary
- Install `uv` and the dependencies used here
- Fetches the secrets from the repository settings - `PHONE_NUMBER` and `RESEND_API_KEY`
- Sends the PDFs to the email address specified in the `EMAIL_TO` secret
