domain = "joke_generator"
definition = "Generate jokes based on input sentences"

[pipe.generate_joke]
type = "PipeLLM"
definition = "Generate a humorous joke based on an input sentence"
inputs = { sentence = "Text" }
output = "Text"
llm = { llm_handle = "gpt-4o-mini", temperature = 0.8, max_tokens = "auto" }
prompt_template = """
You are a creative comedian. Your task is to create a funny, clever joke based on the given sentence.

The joke should be:
- Family-friendly and appropriate
- Creative and witty
- Related to the content or theme of the input sentence
- Well-structured with a clear setup and punchline

Input sentence:
@sentence

Generate a joke based on this sentence:
"""

