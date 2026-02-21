import asyncio

from pipelex import pretty_print
from pipelex.pipelex import Pipelex
from pipelex.pipeline.runner import PipelexRunner


async def hello_world():
    """
    This function demonstrates the use of a super simple Pipelex pipeline to generate text.
    """
    # Run the pipe
    runner = PipelexRunner()
    response = await runner.execute_pipeline(
        pipe_code="hello_world",
    )
    pipe_output = response.pipe_output

    # Print the output
    pretty_print(pipe_output, title="Your first Pipelex output")

    # get the generated text
    generated_text = pipe_output.main_stuff_as_str
    pretty_print(generated_text, title="Generated text")


if __name__ == "__main__":
    with Pipelex.make(library_dirs=["my_project"]):
        asyncio.run(hello_world())
