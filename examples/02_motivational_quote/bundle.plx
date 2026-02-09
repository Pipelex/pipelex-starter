domain = "motivational_quote_generation"
description = "Generating inspiring motivational quotes with fictional attribution based on a given topic."
main_pipe = "generate_motivational_quote"

[concept.MotivationalQuote]
description = "A motivational quote with its attribution and thematic classification."

[concept.MotivationalQuote.structure]
quote_text = { type = "text", description = "The inspiring motivational quote text", required = true }
attributed_to = { type = "text", description = "The name of the fictional person to whom the quote is attributed", required = true }
theme = { type = "text", description = "The core theme or subject matter of the quote", required = true }

[pipe.generate_motivational_quote]
type = "PipeLLM"
description = """
Generate an inspiring motivational quote based on the given topic, create a fictional person to attribute it to, and identify the core theme. Uses creative-writer talent.
"""
inputs = { topic = "Text" }
output = "MotivationalQuote"
model = "$writing-creative"
system_prompt = """
You are a creative writer skilled at crafting inspiring and memorable motivational quotes. Your task is to generate a structured motivational quote with attribution to a fictional person and thematic classification.
"""
prompt = """
Generate an inspiring motivational quote about the following topic: $topic

Create a fictional person to attribute the quote to, and identify the core theme of the quote.
"""
