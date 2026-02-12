
pipelex build pipe "Imagine a cute animal mascot for a startup based on its elevator pitch and some brand guidelines" --output-dir test_graph

pipelex build pipe "Imagine a cute animal mascot for a startup based on its elevator pitch \
    and some brand guidelines, propose 2 different ideas, and for each, 3 style variants in the image generation prompt, \
        at the end we want the rendered image" -o mascot

pipelex build pipe "Given an expense report, apply company rules"

pipelex build pipe "Given a theme, write a Haiku"

pipelex build pipe "Imagine a crazy funny image to render, like a green cow on the Eiffel Tower but not that, and then render it"

pipelex run generate_crazy_image

pipelex run cv_job_match --inputs pipelines/cv_and_offer/inputs.json
pipelex run cv_job_match --inputs pipelines/cv_and_offer/inputs.json --dry-run

pipelex run batch_cv_job_match --inputs cv_batch/inputs.json

pipelex graph render graph.json

pipelex run examples/cv_and_offer/cv_job_match.mthds --inputs examples/cv_and_offer/inputs.json --no-output --graph --graph-full-data
pipelex run cv_job_match --inputs cv_and_offer/inputs.json -L cv_and_offer

pipelex run examples/cv_batch/bundle.mthds --inputs examples/cv_batch/inputs.json


pipelex build pipe "Take a CV and Job offer, analyze if they match and generate 5 questions for the interview"

pipelex build pipe "Take a CV PDF and Job offer PDF, analyze if they match and generate 5 questions for the interview"

pipelex build pipe "Analyze a Job offer to build a scorecard, then batch process CVs to score them, if a CV fits, generate 5 questions for the interview, otherwise draft a rejection email"

pipelex build pipe "Take a series of experimental material and contact angle data measurements and rolling angle data measurements and rank the materials by hydrophobicity"

### Utilities

pipelex build pipe "Take a document, extract its content, review the text to determine the extraction quality (confidence percentage between 0 and 100) and if it's below 98, pass it to a Vision model, along with the text, to complete/perfect it, otherwise, if it's above 98, return it as is."

pipelex build pipe "Take a scanned page, extract its content, review the text to determine the extraction quality (confidence percentage between 0 and 100) and if it's below 98, pass it to a Vision model, along with the text, to complete/perfect it, otherwise, if it's above 98, return it as is"

### Fintech

A method that I will use every month to analyse and validate the expense reports of my employees. As an input there are expense report files and receipts, and the set of validation rules for my company. I have around 15 expenses report every month.

Take image files from receipts and extract the information in order to build an expense report. The filename of the images will be used as a purpose for the expense, for instance "lunch with client ACME". Of course the expense must be categorized and also based on the category we shall apply company rules (say we have a directory of markdown files, one for each category of expense). So each expense will be rejected or validated with a short comment and confidence score. 

A Pipelex method to extract a company expense policy PDF like @demo_files/policies.pdf using a document extraction model and structure it so that we can later use it to validate expense reports

## HR

### Directive

Analyze a Job offer to build a scorecard, then batch process CVs to score them, if a CV fits, generate 5 questions for the interview, otherwise draft a rejection email. Test with the files in the examples/hr directory.

### Guided

Help me design a method to match a bunch of CVs with a job offer