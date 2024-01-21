# CV

## Requirements

- [Poetry](https://python-poetry.org/docs/#installation)
- [typst](https://github.com/typst/typst/releases/latest)
- [Python 3](https://www.python.org/downloads/)

## Install

Add `typst` to your path. Than:

```bash
poetry install
```

## Build

Edit `data.yaml` with your data. Leave the `phone_number` empty. Than:

```bash
PHONE_NUMBER="YOUR_PHONE_NUMBER" poetry run python helper.py add-phone-number
typst compile --font-path ./fonts resume.typ
typst compile --font-path ./fonts cv.typ
```
This will generate `resume.pdf` and `cv.pdf` files.

## Automate

> Make sure you have the `PHONE_NUMBER`, `SENDGRID_API_KEY` and `EMAIL_TO` secrets set in your repository settings.

You can automate the build process with GitHub Actions, see the [workflow](.github/workflows/build-and-send.yml) file.

The workflow does the following:

- Install `typst` binary
- Install `poetry` and the dependencies used here
- Fetches the secrets from the repository settings - `PHONE_NUMBER` and `SENDGRID_API_KEY`
- Updates the `data.yaml` file with the `PHONE_NUMBER` secret and builds the PDFs
- Sends the PDFs to the email address specified in the `EMAIL_TO` secret
