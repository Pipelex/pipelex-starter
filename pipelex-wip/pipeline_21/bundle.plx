domain = "cv_screening"
description = "Analyze a job offer to build a scorecard, batch process CVs to score them, generate interview questions for fitting candidates, and draft rejection emails for others"
main_pipe = "screen_candidates"

# ──────────────────────────────────────────────
# Concepts
# ──────────────────────────────────────────────

[concept.Criterion]
description = "A single scoring criterion for evaluating a candidate"

[concept.Criterion.structure]
name = {type = "text", description = "Name of the criterion", required = true}
description = {type = "text", description = "What to look for in the CV", required = true}
weight = {type = "integer", description = "Importance weight from 1 to 5", required = true}

[concept.Scorecard]
description = "Scoring criteria and requirements derived from a job offer"

[concept.Scorecard.structure]
job_title = {type = "text", description = "Title of the position", required = true}
must_have_skills = {type = "list", item_type = "text", description = "Required skills and qualifications"}
nice_to_have_skills = {type = "list", item_type = "text", description = "Optional desirable skills"}
criteria = {type = "list", item_type = "concept", item_concept_ref = "cv_screening.Criterion", description = "Scoring criteria with weights"}
min_score_percent = {type = "integer", description = "Minimum percentage score to pass", required = true}

[concept.CriterionScore]
description = "Score for a single criterion in the evaluation"

[concept.CriterionScore.structure]
criterion_name = {type = "text", description = "Name of the criterion scored", required = true}
score = {type = "integer", description = "Score from 0 to 10", required = true}
justification = {type = "text", description = "Why this score was given", required = true}

[concept.Evaluation]
description = "Complete evaluation of a CV against the scorecard"

[concept.Evaluation.structure]
candidate_name = {type = "text", description = "Name of the candidate", required = true}
scores = {type = "list", item_type = "concept", item_concept_ref = "cv_screening.CriterionScore", description = "Score for each criterion"}
overall_score_percent = {type = "integer", description = "Weighted overall score as percentage", required = true}
summary = {type = "text", description = "Brief summary of strengths and weaknesses", required = true}
verdict = {type = "text", description = "Whether the candidate passes the threshold", required = true, choices = ["fit", "no_fit"]}

[concept.InterviewQuestion]
description = "A targeted interview question for a candidate"

[concept.InterviewQuestion.structure]
question = {type = "text", description = "The interview question", required = true}
rationale = {type = "text", description = "Why this question is relevant given the CV and scorecard", required = true}
expected_insight = {type = "text", description = "What a good answer would reveal", required = true}

[concept.CandidateOutcome]
description = "Final outcome for a candidate after screening"

[concept.CandidateOutcome.structure]
candidate_name = {type = "text", description = "Name of the candidate", required = true}
verdict = {type = "text", description = "Whether the candidate fits the role", required = true, choices = ["fit", "no_fit"]}
overall_score_percent = {type = "integer", description = "Overall weighted score", required = true}
evaluation_summary = {type = "text", description = "Summary of evaluation", required = true}
interview_questions = {type = "list", item_type = "concept", item_concept_ref = "cv_screening.InterviewQuestion", description = "Interview questions if candidate fits"}
rejection_email = "Rejection email if candidate does not fit"

# ──────────────────────────────────────────────
# Main Pipeline
# ──────────────────────────────────────────────

[pipe.screen_candidates]
type = "PipeSequence"
description = "Main workflow: build scorecard from job offer, then batch process all CVs"
inputs = {job_offer = "Text", cvs = "Document[]"}
output = "CandidateOutcome[]"
steps = [{pipe = "build_scorecard", result = "scorecard"}, {pipe = "process_all_cvs", result = "candidate_outcomes"}]

# ──────────────────────────────────────────────
# Step 1: Build Scorecard
# ──────────────────────────────────────────────

[pipe.build_scorecard]
type = "PipeLLM"
description = "Analyze a job offer and produce a structured scorecard with weighted criteria"
inputs = {job_offer = "Text"}
output = "Scorecard"
model = "$writing-factual"
prompt = """
You are an expert HR recruiter. Analyze the following job offer and build a detailed scorecard for evaluating candidates.

For each criterion, assign a weight from 1 (nice to have) to 5 (absolutely critical).
Set the minimum passing score percentage (typically 60-70%).
Identify must-have vs nice-to-have skills.

Job Offer:

@job_offer
"""

# ──────────────────────────────────────────────
# Step 2: Batch Process CVs
# ──────────────────────────────────────────────

[pipe.process_all_cvs]
type = "PipeBatch"
description = "Process all CVs in batch"
inputs = {cvs = "Document[]", scorecard = "Scorecard"}
output = "CandidateOutcome[]"
branch_pipe_code = "process_single_cv"
input_list_name = "cvs"
input_item_name = "cv"

# ──────────────────────────────────────────────
# Branch: Process a Single CV
# ──────────────────────────────────────────────

[pipe.process_single_cv]
type = "PipeSequence"
description = "Process a single CV: extract, score, and route"
inputs = {cv = "Document", scorecard = "Scorecard"}
output = "CandidateOutcome"
steps = [{pipe = "extract_cv", result = "pages"}, {pipe = "score_cv", result = "evaluation"}, {pipe = "route_candidate", result = "candidate_outcome"}]

[pipe.extract_cv]
type = "PipeExtract"
description = "Extract text content from a CV document"
inputs = {cv = "Document"}
output = "Page[]"
model = "@default-extract-document"

[pipe.score_cv]
type = "PipeLLM"
description = "Score a CV against the scorecard criteria and determine if the candidate fits"
inputs = {pages = "Page[]", scorecard = "Scorecard"}
output = "Evaluation"
model = "$writing-factual"
prompt = """
You are an expert HR recruiter evaluating a candidate CV against a structured scorecard.

Scorecard:

@scorecard

Candidate CV:

@pages

Instructions:
1. Extract the candidate name from the CV
2. Score each criterion from 0 to 10
3. Calculate the weighted overall score as a percentage
4. Compare the overall score to the minimum passing score (min_score_percent) from the scorecard
5. Set verdict to "fit" if the score meets or exceeds the minimum, otherwise "no_fit"
6. Provide a brief summary of strengths and weaknesses
"""

# ──────────────────────────────────────────────
# Conditional Routing
# ──────────────────────────────────────────────

[pipe.route_candidate]
type = "PipeCondition"
description = "Route candidate based on evaluation verdict"
inputs = {evaluation = "Evaluation", scorecard = "Scorecard", pages = "Page[]"}
output = "CandidateOutcome"
expression = "evaluation.verdict"
default_outcome = "handle_no_fit"

[pipe.route_candidate.outcomes]
fit = "handle_fit"
no_fit = "handle_no_fit"

# ──────────────────────────────────────────────
# Fit Path: Interview Questions
# ──────────────────────────────────────────────

[pipe.handle_fit]
type = "PipeSequence"
description = "Handle a fitting candidate: generate interview questions and compose outcome"
inputs = {evaluation = "Evaluation", scorecard = "Scorecard", pages = "Page[]"}
output = "CandidateOutcome"
steps = [{pipe = "generate_interview_questions", result = "interview_questions"}, {pipe = "compose_outcome_fit", result = "candidate_outcome"}]

[pipe.generate_interview_questions]
type = "PipeLLM"
description = "Generate 5 targeted interview questions for a fitting candidate"
inputs = {evaluation = "Evaluation", scorecard = "Scorecard", pages = "Page[]"}
output = "InterviewQuestion[5]"
model = "$writing-factual"
prompt = """
You are an expert HR recruiter preparing for a candidate interview.

Based on the candidate evaluation and their CV, generate exactly 5 targeted interview questions.

Focus on:
- Areas where the candidate scored lower to probe deeper
- Verifying claimed skills and experience
- Behavioral questions related to the role requirements
- Culture fit and motivation

Scorecard:

@scorecard

Candidate Evaluation:

@evaluation

Candidate CV:

@pages

Generate 5 insightful, specific interview questions.
"""

[pipe.compose_outcome_fit]
type = "PipeCompose"
description = "Compose the candidate outcome for a fitting candidate with interview questions"
inputs = {evaluation = "Evaluation", interview_questions = "InterviewQuestion[5]"}
output = "CandidateOutcome"

[pipe.compose_outcome_fit.construct]
candidate_name = {from = "evaluation.candidate_name"}
verdict = {from = "evaluation.verdict"}
overall_score_percent = {from = "evaluation.overall_score_percent"}
evaluation_summary = {from = "evaluation.summary"}
interview_questions = {from = "interview_questions"}
rejection_email = ""

# ──────────────────────────────────────────────
# No-Fit Path: Rejection Email
# ──────────────────────────────────────────────

[pipe.handle_no_fit]
type = "PipeSequence"
description = "Handle a rejected candidate: draft rejection email and compose outcome"
inputs = {evaluation = "Evaluation", scorecard = "Scorecard"}
output = "CandidateOutcome"
steps = [{pipe = "draft_rejection_email", result = "rejection_email"}, {pipe = "compose_outcome_no_fit", result = "candidate_outcome"}]

[pipe.draft_rejection_email]
type = "PipeLLM"
description = "Draft a professional and empathetic rejection email"
inputs = {evaluation = "Evaluation", scorecard = "Scorecard"}
output = "Text"
model = "$writing-factual"
prompt = """
You are an HR professional drafting a rejection email for a candidate who did not meet the requirements.

Job Title: $scorecard.job_title
Candidate Name: $evaluation.candidate_name

Evaluation Summary:

@evaluation

Draft a professional, empathetic rejection email that:
- Addresses the candidate by name
- Thanks them for their application
- Does NOT specify exact scores or detailed reasons for rejection
- Encourages them to apply for future positions
- Is warm but honest
- Is concise (under 200 words)
"""

[pipe.compose_outcome_no_fit]
type = "PipeCompose"
description = "Compose the candidate outcome for a rejected candidate with rejection email"
inputs = {evaluation = "Evaluation", rejection_email = "Text"}
output = "CandidateOutcome"

[pipe.compose_outcome_no_fit.construct]
candidate_name = {from = "evaluation.candidate_name"}
verdict = {from = "evaluation.verdict"}
overall_score_percent = {from = "evaluation.overall_score_percent"}
evaluation_summary = {from = "evaluation.summary"}
interview_questions = []
rejection_email = {from = "rejection_email"}
