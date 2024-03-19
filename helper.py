import base64
import os
import subprocess

import click
import jinja2
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
git_hash = subprocess.run(["git", "rev-parse", "--short", "HEAD"], stdout=subprocess.PIPE)


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
    sg = SendGridAPIClient(api_key=os.environ.get("SENDGRID_API_KEY"))
    from_email = Email("github-actions@gollahalli.com")
    to_email = To(email_to)
    subject = "CV and Resume from GitHub Actions"
    content = Content("text/plain", f"Sending CV and Resume from GitHub Actions with hash {git_hash.stdout.decode().strip()}")
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

    mail_json = mail.get()
    response = sg.client.mail.send.post(request_body=mail_json)
    print(f"Sent status: {response.status_code}")


@cli.command()
def add_phone_number():
    """
    Add phone number to data.yaml
    """
    with open("data.yaml", "r") as f:
        data = f.read()

    data = jinja2.Template(data).render(phone_number=os.environ.get("PHONE_NUMBER"))

    with open("data.yaml", "w") as f:
        f.write(data)


if __name__ == "__main__":
    cli()
