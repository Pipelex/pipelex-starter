import asyncio

from pipelex.core.stuffs.image_content import ImageContent
from pipelex.pipelex import Pipelex
from pipelex.pipeline.execute import execute_pipeline


async def run_generate_crazy_image() -> ImageContent:
    pipe_output = await execute_pipeline(
        pipe_code="generate_crazy_image",
    )
    return pipe_output.main_stuff_as(content_type=ImageContent)


if __name__ == "__main__":
    # Initialize Pipelex
    with Pipelex.make():
        # Run the pipeline
        result = asyncio.run(run_generate_crazy_image())
