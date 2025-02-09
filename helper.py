import base64
import os
import subprocess

import click
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import (
    Mail,
    Email,
    To,
    Content,
    Attachment,
    FileContent,
    FileName,
    FileType,
    Disposition,
)

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
@click.option(
    "--email-to", required=True, help="Email address to send the CV and Resume"
)
def send_email(email_to: str):
    """
    Send email using SendGrid

    :param email_to: Email address to send the CV and Resume
    """
    api_key = os.environ.get("SENDGRID_API_KEY")
    if not api_key:
        raise ValueError("SENDGRID_API_KEY environment variable is not set")
    sg = SendGridAPIClient(api_key=api_key)

    from_email = Email("github-actions@gollahalli.com")
    to_email = To(email_to)
    subject = "CV and Resume from GitHub Actions"
    content = Content(
        "text/plain",
        f"Sending CV and Resume from GitHub Actions with hash {git_hash.stdout.strip()}",
    )
    mail = Mail(from_email, to_email, subject, content)

    # Add attachments
    with open("cv.pdf", "rb") as f:
        cv_data = f.read()

    with open("resume.pdf", "rb") as f:
        resume_data = f.read()

    with open("data.yaml", "rb") as f:
        data = f.read()

    cv_encoded_file = base64.b64encode(cv_data).decode()
    resume_encoded_file = base64.b64encode(resume_data).decode()
    data_encoded_file = base64.b64encode(data).decode()

    cv_file = Attachment(
        FileContent(cv_encoded_file),
        FileName("cv.pdf"),
        FileType("application/pdf"),
        Disposition("attachment"),
    )

    resume_file = Attachment(
        FileContent(resume_encoded_file),
        FileName("resume.pdf"),
        FileType("application/pdf"),
        Disposition("attachment"),
    )

    data_file = Attachment(
        FileContent(data_encoded_file),
        FileName("data.yaml"),
        FileType("text/yaml"),
        Disposition("attachment"),
    )

    mail.attachment = [cv_file, resume_file, data_file]

    try:
        response = sg.send(mail)
        print(f"Sent status: {response.status_code}")
    except Exception as e:
        import logging
        logging.basicConfig(level=logging.ERROR)
        logging.error("An error occurred", exc_info=True)


if __name__ == "__main__":
    cli()
