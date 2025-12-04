import asyncio

from pipelex.pipelex import Pipelex
from pipelex.pipeline.execute import execute_pipeline


async def run_create_startup_mascot():
    return await execute_pipeline(
        pipe_code="create_startup_mascot",
        inputs={
            "elevator_pitch": {
                "concept": "startup_mascot_design.ElevatorPitch",
                "content": "elevator_pitch_text",
            },
            "brand_guidelines": {
                "concept": "startup_mascot_design.BrandGuidelines",
                "content": "brand_guidelines_text",
            },
        },
    )


if __name__ == "__main__":
    # Initialize Pipelex
    Pipelex.make()

    # Run the pipeline
    result = asyncio.run(run_create_startup_mascot())
