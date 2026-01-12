pipelex build pipe "Take a CV and Job offer in PDF, analyze if they match and generate 5 questions for the interview" --graph --graph-full-data

pipelex build pipe "Imagine a cute animal mascot for a startup based on its elevator pitch and some brand guidelines" --graph --graph-full-data --output-dir test_graph

pipelex build pipe "Imagine a cute animal mascot for a startup based on its elevator pitch \
    and some brand guidelines, propose 2 different ideas, and for each, 3 style variants in the image generation prompt, \
        at the end we want the rendered image" -o mascot

pipelex build pipe "Given an expense report, apply company rules"

pipelex build pipe "Given a theme, write a Haiku" --graph --graph-full-data

pipelex build pipe "Imagine a crazy funny image to render, like a green cow on the Eiffel Tower but not that, and then render it"--no-output --graph --graph-full-data

pipelex run generate_crazy_image --graph
pipelex run generate_crazy_image --graph --graph-full-data

pipelex run cv_job_match --inputs pipelines/cv_and_offer/inputs.json --graph
pipelex run cv_job_match --inputs pipelines/cv_and_offer/inputs.json --graph --dry-run
pipelex run cv_job_match --inputs pipelines/cv_and_offer/inputs.json --no-output --graph --graph-full-data

pipelex run batch_cv_job_match --inputs cv_batch/inputs.json --no-output --graph --graph-full-data

pipelex graph render graph.json



# pipelex run examples/cv_and_offer/cv_job_match.plx --inputs examples/cv_and_offer/inputs.json --no-output --graph --graph-full-data
pipelex run cv_job_match --inputs cv_and_offer/inputs.json --no-output --graph --graph-full-data -L cv_and_offer

pipelex run examples/cv_batch/bundle.plx --inputs examples/cv_batch/inputs.json --graph
pipelex run examples/cv_batch/bundle.plx --inputs examples/cv_batch/inputs.json --no-output --graph


pipelex build pipe "Take a CV and Job offer in PDF, analyze if they match and generate 5 questions for the interview" --graph

pipelex build pipe "Take a series of experimental material and contact angle data measurements and rolling angle data measurements and rank the materials by hydrophobicity" --graph --graph-full-data

