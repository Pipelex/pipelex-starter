import asyncio

from pipelex.pipelex import Pipelex
from pipelex.pipeline.execute import execute_pipeline


async def run_build_public_content_flow():
    return await execute_pipeline(
        pipe_code="build_public_content_flow",
        inputs={
            "changelogs": {
                "concept": "build_in_public_content.Changelog",
                "content": "changelogs_text",
            },
            "blurb": {
                "concept": "build_in_public_content.Blurb",
                "content": "blurb_text",
            },
        },
    )


if __name__ == "__main__":
    # Initialize Pipelex
    Pipelex.make()

    # Run the pipeline
    result = asyncio.run(run_build_public_content_flow())
