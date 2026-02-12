domain = "expense_auditor"
description = "Extract an expense report PDF, classify line items, flag policy violations, and produce an audit report"
main_pipe = "audit_expense_report"

[concept.ExpenseItem]
description = "A single line item from an expense report"

[concept.ExpenseItem.structure]
description = { type = "text", description = "Description of the expense", required = true }
amount = { type = "number", description = "Amount in dollars", required = true }
category = { type = "text", description = "Expense category", choices = ["travel", "meals", "supplies", "lodging", "entertainment", "other"], required = true }
date = { type = "text", description = "Date of the expense", required = true }

[concept.AuditResult]
description = "Audit assessment of a single expense item"

[concept.AuditResult.structure]
status = { type = "text", description = "Audit status", choices = ["approved", "flagged", "rejected"], required = true }
reason = { type = "text", description = "Reason for the audit decision", required = true }
amount = { type = "number", description = "Original expense amount", required = true }
category = { type = "text", description = "Original expense category", required = true }

[concept.AuditReport]
description = "Complete audit report summarizing all expense items"
refines = "Text"

[pipe.audit_expense_report]
type = "PipeSequence"
description = "Main pipeline: extract expense report, parse items, audit each one, and compose the final report"
inputs = { document = "Document" }
output = "AuditReport"
steps = [
    { pipe = "extract_document", result = "pages" },
    { pipe = "parse_expenses", result = "expense_items" },
    { pipe = "audit_item", batch_over = "expense_items", batch_as = "expense_item", result = "audit_results" },
    { pipe = "compose_audit_report", result = "audit_report" },
]

[pipe.extract_document]
type = "PipeExtract"
description = "Extract all pages from the expense report PDF"
inputs = { document = "Document" }
output = "Page[]"
model = "@default-text-from-pdf"

[pipe.parse_expenses]
type = "PipeLLM"
description = "Parse the extracted pages into structured expense line items"
inputs = { pages = "Page" }
output = "ExpenseItem[]"
model = "$retrieval"
system_prompt = "You are an accounting data extraction specialist. Parse expense reports into structured line items with precise amounts and categories."
prompt = """
Parse the following expense report into individual expense line items.

@pages

Extract each expense with its description, amount, category, and date.
"""

[pipe.audit_item]
type = "PipeLLM"
description = "Audit a single expense item against company policy"
inputs = { expense_item = "ExpenseItem" }
output = "AuditResult"
model = "$writing-factual"
system_prompt = """
You are a corporate expense auditor. Apply these policies:
- Meals: max $75 per person per meal
- Travel: must be economy class for domestic
- Entertainment: requires prior approval (flag if over $200)
- Lodging: max $250 per night
- Any single expense over $500 requires flagging
"""
prompt = """
Audit the following expense item against company policy:

@expense_item

Determine if this expense should be approved, flagged for review, or rejected. Provide your reasoning.
"""

[pipe.compose_audit_report]
type = "PipeLLM"
description = "Compose a final audit summary report from all individual audit results"
inputs = { audit_results = "AuditResult[]" }
output = "AuditReport"
model = "$writing-factual"
system_prompt = "You are a corporate expense auditor. Write clear, professional audit summary reports."
prompt = """
Compose a comprehensive audit summary report from the following individual expense audit results:

@audit_results

Include:
1. Total expenses reviewed
2. Number approved, flagged, and rejected
3. Total amount by status
4. Key findings and recommendations
"""
