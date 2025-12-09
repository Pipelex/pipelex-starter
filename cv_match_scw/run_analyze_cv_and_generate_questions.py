import asyncio
import time
from pathlib import Path

from pipelex.core.stuffs.list_content import ListContent
from pipelex.core.stuffs.pdf_content import PDFContent
from pipelex.pipelex import Pipelex
from pipelex.pipeline.execute import execute_pipeline
from pipelex.system.runtime import IntegrationMode

# CV_FOLDER = Path("data/CVs")
# CV_FOLDER = Path("data/OneCV")
CV_FOLDER = Path("data/CVx2")


def get_cv_pdf_contents() -> list[PDFContent]:
    """Get all PDF files from the CVs folder."""
    return [PDFContent(url=str(pdf_path)) for pdf_path in sorted(CV_FOLDER.glob("*.pdf"))]


async def run_analyze_cvs_for_job_offer():
    return await execute_pipeline(
        pipe_code="analyze_cvs_for_job_offer",
        inputs={
            "cvs": ListContent[PDFContent](items=get_cv_pdf_contents()),
            "job_offer_pdf": PDFContent(url="https://pipelex-web.s3.amazonaws.com/demo/Job-Offer.pdf"),
        },
    )


if __name__ == "__main__":
    # Initialize Pipelex
    with Pipelex.make(integration_mode=IntegrationMode.CLI) as pipelex:
        # Run the pipeline with timing
        start_time = time.perf_counter()
        result = asyncio.run(run_analyze_cvs_for_job_offer())
        elapsed_time = time.perf_counter() - start_time

        print(f"\n⏱️  Pipeline execution time: {elapsed_time:.2f} seconds")
