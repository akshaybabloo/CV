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

This will generate `resume.pdf` and `cv.pdf` files.

## Automate

> Make sure you have the `PHONE_NUMBER`, `SENDGRID_API_KEY` and `EMAIL_TO` secrets set in your repository settings.

You can automate the build process with GitHub Actions, see the [workflow](.github/workflows/build-and-send.yml) file.

The workflow does the following:

- Install `typst` binary
- Install `uv` and the dependencies used here
- Fetches the secrets from the repository settings - `PHONE_NUMBER` and `SENDGRID_API_KEY`
- Sends the PDFs to the email address specified in the `EMAIL_TO` secret
