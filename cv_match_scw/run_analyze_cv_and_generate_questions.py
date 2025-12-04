import asyncio

from pipelex.core.stuffs.pdf_content import PDFContent
from pipelex.pipelex import Pipelex
from pipelex.pipeline.execute import execute_pipeline


async def run_analyze_cv_and_generate_questions():
    return await execute_pipeline(
        pipe_code="analyze_cv_and_generate_questions",
        inputs={
            "cv_pdf": PDFContent(url="cv_pdf_url"),
            "job_offer_pdf": PDFContent(url="job_offer_pdf_url"),
        },
    )


if __name__ == "__main__":
    # Initialize Pipelex
    Pipelex.make()

    # Run the pipeline
    result = asyncio.run(run_analyze_cv_and_generate_questions())
