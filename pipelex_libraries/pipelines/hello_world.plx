

domain = "quick_start"
definition = "Discovering Pipelex"

[pipe]
[pipe.hello_world]
type = "PipeLLM"
description = "Write text about Hello World."
output = "Text"
# llm = { llm_handle = "blackboxai/openai/gpt-4o", temperature = 0.2 }
# llm = { llm_handle = "blackboxai/google/gemini-2.5-pro", temperature = 0.2 }
llm = { llm_handle = "blackboxai/anthropic/claude-sonnet-4", temperature = 0.2 }
prompt = """
Write a haiku about Hello World.
"""

