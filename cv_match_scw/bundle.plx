domain = "cv_job_matching"
description = "Analyzing CV and job offer compatibility and generating interview questions"
system_prompt = "None"
main_pipe = "analyze_cv_and_generate_questions"

[concept.CandidateProfile]
description = "A structured summary of a job candidate's professional background extracted from their CV."

[concept.CandidateProfile.structure]
skills = { type = "text", description = "Technical and soft skills possessed by the candidate", required = true }
experience = { type = "text", description = "Work history and professional experience", required = true }
education = { type = "text", description = "Educational background and qualifications", required = true }
achievements = { type = "text", description = "Notable accomplishments and certifications" }

[concept.JobRequirements]
description = "A structured summary of what a job position requires from candidates."

[concept.JobRequirements.structure]
required_skills = { type = "text", description = "Skills that are mandatory for the position", required = true }
responsibilities = { type = "text", description = "Main duties and tasks of the role", required = true }
qualifications = { type = "text", description = "Required education, certifications, or experience levels", required = true }
nice_to_haves = { type = "text", description = "Preferred but not mandatory qualifications" }

[concept.MatchAnalysis]
description = "An evaluation of how well a candidate fits a job position."

[concept.MatchAnalysis.structure]
match_score = { type = "number", description = "Numerical score representing overall fit percentage", required = true }
strengths = { type = "text", description = "Areas where the candidate meets or exceeds requirements", required = true }
gaps = { type = "text", description = "Areas where the candidate falls short of requirements", required = true }
overall_assessment = { type = "text", description = "Summary evaluation of the candidate's suitability", required = true }

[concept.InterviewQuestion]
description = "A targeted question designed to assess a candidate during an interview."

[concept.InterviewQuestion.structure]
question = { type = "text", description = "The interview question to ask the candidate", required = true }
rationale = { type = "text", description = "Explanation of why this question is relevant", required = true }

[pipe.analyze_cv_and_generate_questions]
type = "PipeSequence"
description = """
Main orchestrator pipe that takes a CV and job offer in PDF format, analyzes their match, and generates 5 targeted interview questions. This is the entry point of the pipeline.
"""
inputs = { cv_pdf = "PDF", job_offer_pdf = "PDF" }
output = "InterviewQuestion[5]"
steps = [
    { pipe = "extract_documents_parallel", result = "extracted_pages" },
    { pipe = "analyze_cv", result = "candidate_profile" },
    { pipe = "analyze_job_requirements", result = "job_requirements" },
    { pipe = "analyze_match", result = "match_analysis" },
    { pipe = "generate_interview_questions", result = "interview_questions" },
]

[pipe.extract_documents_parallel]
type = "PipeParallel"
description = "Extracts text content from both CV and job offer PDFs concurrently"
inputs = { cv_pdf = "PDF", job_offer_pdf = "PDF" }
output = "Page[]"
parallels = [
    { pipe = "extract_cv", result = "cv_pages" },
    { pipe = "extract_job_offer", result = "job_offer_pages" },
]
add_each_output = true

[pipe.extract_cv]
type = "PipeExtract"
description = "Extracts text content from the CV PDF document"
inputs = { cv_pdf = "PDF" }
output = "Page[]"
model = "pdf_text_extractor"

[pipe.extract_job_offer]
type = "PipeExtract"
description = "Extracts text content from the job offer PDF document"
inputs = { job_offer_pdf = "PDF" }
output = "Page[]"
model = "pdf_text_extractor"

[pipe.analyze_cv]
type = "PipeLLM"
description = """
Parses and summarizes the candidate's professional profile from the extracted CV content, identifying skills, experience, education, and achievements
"""
inputs = { cv_pages = "Page" }
output = "CandidateProfile"
model = "llm_for_recruitment"
system_prompt = """
You are an expert HR analyst specializing in parsing and summarizing candidate CVs. Your task is to extract and structure the candidate's professional profile into a structured format.
"""
prompt = """
Analyze the following CV content and extract the candidate's professional profile.

@cv_pages
"""

[pipe.analyze_job_requirements]
type = "PipeLLM"
description = """
Parses and summarizes the job requirements from the extracted job offer content, identifying required skills, responsibilities, qualifications, and nice-to-haves
"""
inputs = { job_offer_pages = "Page" }
output = "JobRequirements"
model = "llm_for_recruitment"
system_prompt = """
You are an expert HR analyst specializing in parsing job descriptions. Your task is to extract and summarize job requirements into a structured format.
"""
prompt = """
Analyze the following job offer content and extract the key requirements for the position.

@job_offer_pages
"""

[pipe.analyze_match]
type = "PipeLLM"
description = """
Evaluates how well the candidate matches the job requirements, calculating a match score and identifying strengths and gaps
"""
inputs = { candidate_profile = "CandidateProfile", job_requirements = "JobRequirements" }
output = "MatchAnalysis"
model = "llm_for_recruitment"
system_prompt = """
You are an expert HR analyst specializing in candidate-job fit evaluation. Your task is to produce a structured match analysis comparing a candidate's profile against job requirements.
"""
prompt = """
Analyze how well the candidate matches the job requirements. Evaluate their fit by comparing their skills, experience, and qualifications against what the position demands.

@candidate_profile

@job_requirements

Provide a comprehensive match analysis including a numerical score, identified strengths, gaps, and an overall assessment.
"""

[pipe.generate_interview_questions]
type = "PipeLLM"
description = """
Creates 5 targeted interview questions based on the candidate's profile, job requirements, and identified gaps to assess fit during the interview
"""
inputs = { candidate_profile = "CandidateProfile", job_requirements = "JobRequirements", match_analysis = "MatchAnalysis" }
output = "InterviewQuestion[5]"
model = "llm_for_recruitment"
system_prompt = """
You are an expert HR interviewer and talent assessor. Your task is to generate structured interview questions that will help evaluate a candidate's fit for a specific role. Each question should be targeted and purposeful, designed to probe areas of strength or address potential gaps identified in the match analysis.
"""
prompt = """
Based on the following candidate profile, job requirements, and match analysis, generate 5 targeted interview questions to assess the candidate's fit for the role.

@candidate_profile

@job_requirements

@match_analysis

Create questions that:
- Probe the candidate's strengths to confirm their capabilities
- Address identified gaps to understand if they can be overcome
- Assess cultural and role fit
- Evaluate relevant experience and skills
"""
