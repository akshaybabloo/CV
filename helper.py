import base64
import os
import subprocess

import click
import resend

# Get short Git hash
git_hash = subprocess.run(
    ["git", "rev-parse", "--short", "HEAD"],
    capture_output=True,
    check=True,
    text=True,
)


@click.group()
def cli():
    pass


@cli.command(help="Send CV, Resume and data.yaml via email")
@click.option("--email-to", required=True, help="Email address to send the CV and Resume")
def send_email(email_to: str):
    """
    Send email using SendGrid

    :param email_to: Email address to send the CV and Resume
    """
    api_key = os.environ.get("RESEND_API_KEY")
    if not api_key:
        raise ValueError("RESEND_API_KEY environment variable is not set")
    resend.api_key = api_key

    # Add attachments
    with open("cv.pdf", "rb") as f:
        cv_data = f.read()

    with open("resume.pdf", "rb") as f:
        resume_data = f.read()

    with open("data.yaml", "rb") as f:
        data = f.read()

    attachments: list[resend.Attachment] = [
        {
            "filename": "cv.pdf",
            "content": base64.b64encode(cv_data).decode(),
            "content_type": "application/pdf",
        },
        {
            "filename": "resume.pdf",
            "content": base64.b64encode(resume_data).decode(),
            "content_type": "application/pdf",
        },
        {
            "filename": "data.yaml",
            "content": base64.b64encode(data).decode(),
            "content_type": "text/yaml",
        },
    ]

    params: resend.Emails.SendParams = {
        "from": "github-actions@gollahalli.com",
        "to": [email_to],
        "subject": "CV and Resume from GitHub Actions",
        "text": f"Sending CV and Resume from GitHub Actions with hash {git_hash.stdout.strip()}",
        "attachments": attachments,
    }

    try:
        email = resend.Emails.send(params)
        print(f"Sent email with id: {email['id']}")
    except Exception:
        import logging

        logging.basicConfig(level=logging.ERROR)
        logging.error("An error occurred", exc_info=True)


if __name__ == "__main__":
    cli()
