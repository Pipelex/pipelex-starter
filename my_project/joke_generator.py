import asyncio

from pipelex import pretty_print
from pipelex.pipelex import Pipelex
from pipelex.pipeline.execute import execute_pipeline


async def generate_joke(sentence: str):
    """
    This function demonstrates the use of a Pipelex pipeline to generate jokes from sentences.
    """
    # Run the pipe
    pipe_output, _ = await execute_pipeline(
        pipe_code="generate_joke",
        input_memory={
            "sentence": sentence,
        },
    )

    # Print the output
    pretty_print(pipe_output, title="Generated Joke")
    return pipe_output


async def main():
    """
    Main function to test the joke generator with sample sentences.
    """
    # Test sentences
    test_sentences = [
        "I love programming in Python.",
        "The weather is really nice today.",
        "My cat sleeps all day long.",
    ]

    print("🎭 Welcome to the Joke Generator! 🎭\n")

    for i, sentence in enumerate(test_sentences, 1):
        print(f"--- Test {i} ---")
        print(f"Input: {sentence}")
        await generate_joke(sentence)
        print()


# start Pipelex
Pipelex.make()
# run sample using asyncio
asyncio.run(main())
