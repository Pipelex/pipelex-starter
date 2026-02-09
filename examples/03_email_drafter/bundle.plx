domain = "email_composition"
description = "Composing professional emails from structured inputs using templates."
main_pipe = "compose_email"

[concept.EmailRequest]
description = "A structured request containing all the information needed to compose a professional email."

[concept.EmailRequest.structure]
recipient_name = { type = "text", description = "The name of the person receiving the email", required = true }
subject = { type = "text", description = "The subject line of the email", required = true }
body_points = { type = "text", description = "Key points to include in the body of the email", required = true }
tone = { type = "text", description = "The tone of the email", required = true, default_value = "formal" }

[pipe.compose_email]
type = "PipeCompose"
description = """
Main pipe of the pipeline. Renders a professional email using a Jinja2 template that formats the greeting based on tone (formal, friendly, or urgent), incorporates the subject line, expands body points into proper paragraphs, and adds an appropriate signature.
"""
inputs = { email_request = "EmailRequest" }
output = "Text"

[pipe.compose_email.template]
template = """
Subject: $email_request.subject

Dear $email_request.recipient_name,

$email_request.body_points

Best regards
"""
templating_style = { tag_style = "no_tag", text_format = "plain" }
category = "markdown"
