domain = "pdf_executive_summary"
description = "Extracting PDF documents, summarizing pages, and composing HTML executive summaries"
main_pipe = "extract_summarize_compose"

[concept.PageSummary]
description = "A concise summary capturing the key points from a single page of a document"
refines = "Text"

[pipe.extract_summarize_compose]
type = "PipeSequence"
description = "Main pipeline that extracts pages from a PDF, summarizes each page individually, then composes a styled HTML executive summary report"
inputs = { document = "Document" }
output = "Html"
steps = [
    { pipe = "extract_pages", result = "pages" },
    { pipe = "summarize_page", batch_over = "pages", batch_as = "page", result = "page_summaries" },
    { pipe = "compose_executive_summary", result = "executive_summary_html" },
]

[pipe.extract_pages]
type = "PipeExtract"
description = "Extracts all pages from the input PDF document"
inputs = { document = "Document" }
output = "Page[]"
model = "@default-text-from-pdf"

[pipe.summarize_page]
type = "PipeLLM"
description = "Summarizes the content of a single page into a concise summary capturing key points"
inputs = { page = "Page" }
output = "PageSummary"
model = "$retrieval"
system_prompt = """
You are a skilled data extraction assistant. Your task is to summarize document pages into concise summaries that capture the key points.
"""
prompt = """
Summarize the following page content into a concise summary capturing the key points.

@page
"""

[pipe.compose_executive_summary]
type = "PipeCompose"
description = "Renders all page summaries into a styled HTML executive summary report with section headings and a table of contents"
inputs = { page_summaries = "PageSummary[]" }
output = "Html"

[pipe.compose_executive_summary.template]
category = "html"
template = """
<!DOCTYPE html>
<html>
<head>
    <title>Executive Summary Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
        h2 { color: #34495e; }
        .toc { background: #f8f9fa; padding: 20px; margin-bottom: 30px; border-radius: 5px; }
        .toc h2 { margin-top: 0; }
        .toc ul { list-style-type: none; padding-left: 0; }
        .toc li { margin: 8px 0; }
        .toc a { color: #3498db; text-decoration: none; }
        .summary-section { margin-bottom: 25px; padding: 15px; background: #fff; border-left: 4px solid #3498db; }
    </style>
</head>
<body>
    <h1>Executive Summary Report</h1>

    <div class="toc">
        <h2>Table of Contents</h2>
        <ul>
            {% for summary in page_summaries %}
            <li><a href="#section-{{ loop.index }}">Section {{ loop.index }}</a></li>
            {% endfor %}
        </ul>
    </div>

    {% for summary in page_summaries %}
    <div class="summary-section" id="section-{{ loop.index }}">
        <h2>Section {{ loop.index }}</h2>
        {{ summary }}
    </div>
    {% endfor %}
</body>
</html>
"""
