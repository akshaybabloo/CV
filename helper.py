import base64
import mimetypes
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
@click.option("--files", default="cv.pdf,resume.pdf,data.yaml", help="Comma-separated list of files to attach")
def send_email(email_to: str, files: str):
    """
    Send email using SendGrid

    :param email_to: Email address to send the CV and Resume
    :param files: Comma-separated list of files to attach
    """
    api_key = os.environ.get("RESEND_API_KEY")
    if not api_key:
        raise ValueError("RESEND_API_KEY environment variable is not set")
    resend.api_key = api_key

    # Add attachments
    file_list = [name.strip() for name in files.split(",") if name.strip()]
    if not file_list:
        raise ValueError("No files provided to attach")

    attachments: list[resend.Attachment] = []
    for file_name in file_list:
        with open(file_name, "rb") as f:
            content = base64.b64encode(f.read()).decode()
        content_type, _ = mimetypes.guess_type(file_name)
        attachments.append(
            {
                "filename": os.path.basename(file_name),
                "content": content,
                "content_type": content_type or "application/octet-stream",
            }
        )

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
