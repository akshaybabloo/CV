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
import os
import base64


def send_email():
    sg = SendGridAPIClient(api_key=os.environ.get("SENDGRID_API_KEY"))
    from_email = Email("github-actions@gollahalli.com")
    to_email = To("akshay@gollahalli.com")  # Change to your recipient
    subject = "CV and Resume from GitHub Actions"
    content = Content("text/plain", "and easy to do anywhere, even with Python")
    mail = Mail(from_email, to_email, subject, content)

    # Add attachments
    with open("cv.pdf", "rb") as f:
        cv_data = f.read()
    f.close()

    with open("resume.pdf", "rb") as f:
        resume_data = f.read()
    f.close()

    cv_encoded_file = base64.b64encode(cv_data).decode()
    resume_encoded_file = base64.b64encode(resume_data).decode()

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

    mail.attachment = [cv_file, resume_file]

    mail_json = mail.get()
    response = sg.client.mail.send.post(request_body=mail_json)
    print(response.status_code)


def cli():
    pass


if __name__ == "__main__":
    send_email()
