domain = "illustrated_poetry"
description = "Creating short poems from themes and generating matching illustrations"
main_pipe = "create_illustrated_poem"

[concept.Poem]
description = "A short literary composition expressing emotions or ideas through verse and imagery."
refines = "Text"

[pipe.create_illustrated_poem]
type = "PipeSequence"
description = """
Main pipeline that orchestrates the creation of a short poem from a theme and generates a matching portrait illustration. This is the entry point that coordinates the poem writing and illustration generation steps.
"""
inputs = { theme = "Text" }
output = "Image"
steps = [
    { pipe = "write_poem", result = "poem" },
    { pipe = "write_image_prompt", result = "image_prompt" },
    { pipe = "generate_illustration", result = "illustration" },
]

[pipe.write_poem]
type = "PipeLLM"
description = "Writes a short poem that captures the essence of the given theme using creative verse and imagery"
inputs = { theme = "Text" }
output = "Poem"
model = "$writing-creative"
system_prompt = """
You are a skilled poet who crafts evocative verses that capture the essence of any subject through vivid imagery and emotional resonance.
"""
prompt = """
Write a short poem about the following theme:

@theme

Be concise and expressive, using vivid imagery and emotional depth.
"""

[pipe.write_image_prompt]
type = "PipeLLM"
description = """
Crafts a detailed image generation prompt based on the poem's mood, imagery, and visual elements to guide the illustration creation
"""
inputs = { poem = "Poem" }
output = "Text"
model = "$img-gen-prompting"
system_prompt = """
You are an expert at crafting concise, effective image generation prompts. You excel at translating literary content into vivid visual descriptions optimized for AI image generators.
"""
prompt = """
Analyze the following poem and create a VERY concise image generation prompt for a portrait-format illustration that captures its mood, imagery, and visual elements.

Focus on: key visual elements, color palette, atmosphere, and artistic style. Keep the prompt short and impactful.

@poem
"""

[pipe.generate_illustration]
type = "PipeImgGen"
description = "Generates a portrait-format illustration that visually matches the poem's mood and imagery"
inputs = { image_prompt = "Text" }
output = "Image"
prompt = """
Create a portrait-format illustration based on the following poem. Capture the mood, imagery, and emotional essence of the verse in a visually compelling artwork: $image_prompt
"""
model = "$gen-image-high-quality"
