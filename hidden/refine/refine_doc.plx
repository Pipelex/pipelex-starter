domain = "document_extraction_refinement"
description = "Extracting document content and refining it based on quality assessment using vision models"
main_pipe = "process_document"

[concept.ExtractionQuality]
description = "A structured assessment of how well text was extracted from a document page."

[concept.ExtractionQuality.structure]
confidence = { type = "integer", description = "Percentage score indicating the quality of the text extraction", required = true }

[concept.RefinedText]
description = "The final corrected and completed text content extracted from a page."
refines = "Text"

[pipe.process_document]
type = "PipeSequence"
description = """
Main pipeline entry point that takes a document, extracts its pages, and processes each page for quality assessment and conditional refinement
"""
inputs = { document = "Document" }
output = "RefinedText[]"
steps = [
    { pipe = "extract_pages", result = "pages" },
    { pipe = "process_all_pages", result = "processed_pages" },
]

[pipe.extract_pages]
type = "PipeExtract"
description = "Extract content from the document into individual pages"
inputs = { document = "Document" }
output = "Page[]"
model = "@default-text-from-pdf"

[pipe.process_all_pages]
type = "PipeBatch"
description = "Process each page through quality evaluation and conditional refinement"
inputs = { pages = "Page[]" }
output = "RefinedText[]"
branch_pipe_code = "process_single_page"
input_list_name = "pages"
input_item_name = "page"

[pipe.process_single_page]
type = "PipeSequence"
description = "Evaluate extraction quality for a single page and refine if needed based on quality threshold"
inputs = { page = "Page" }
output = "RefinedText"
steps = [
    { pipe = "evaluate_extraction_quality", result = "extraction_quality" },
    { pipe = "check_quality_threshold", result = "refined_text" },
]

[pipe.evaluate_extraction_quality]
type = "PipeLLM"
description = """
Analyze the extracted text from a page and determine a confidence percentage (0-100) for extraction quality
"""
inputs = { page = "Page" }
output = "ExtractionQuality"
model = "$retrieval"
system_prompt = """
You are a document quality assessment expert. Your task is to evaluate the quality of text extraction from document pages and provide a structured assessment with a confidence score.
"""
prompt = """
Analyze the following extracted page content and evaluate the quality of the text extraction.

Look for signs of extraction issues such as:
- Missing or garbled characters
- Broken words or sentences
- Formatting artifacts
- Incomplete text blocks
- OCR errors

@page

Provide your assessment as a structured response.
"""

[pipe.check_quality_threshold]
type = "PipeCondition"
description = "Route to vision refinement if confidence is below 98, otherwise pass through the text as-is"
inputs = { page = "Page", extraction_quality = "ExtractionQuality" }
output = "RefinedText"
expression_template = "{{ 'low_confidence' if extraction_quality.confidence < 98 else 'high_confidence' }}"
outcomes = { low_confidence = "refine_with_vision", high_confidence = "passthrough_text" }
default_outcome = "refine_with_vision"

[pipe.passthrough_text]
type = "PipeLLM"
description = "Return the extracted text as-is since quality is sufficient (confidence >= 98)"
inputs = { page = "Page" }
output = "RefinedText"
model = "$retrieval"
prompt = """
Return the extracted text from the following page exactly as it is, without any modifications.

@page
"""

[pipe.refine_with_vision]
type = "PipeLLM"
description = """
Use vision capabilities to analyze the original page image along with the extracted text to complete and perfect it
"""
inputs = { page = "Page", extraction_quality = "ExtractionQuality" }
output = "RefinedText"
model = "$vision"
system_prompt = """
You are a document text refinement specialist with vision capabilities. Your task is to analyze the original page image and compare it with the extracted text to identify and correct any extraction errors, missing content, or formatting issues.
"""
prompt = """
Analyze the page image and refine the extracted text based on the extraction quality assessment.

$page

@extraction_quality

Review the original page image carefully and compare it with the extracted text. Identify any missing text, OCR errors, or formatting issues. Provide the complete, corrected text that accurately represents the content visible in the page image. Be concise and output only the refined text content.
"""
