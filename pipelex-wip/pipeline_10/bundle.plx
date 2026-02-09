domain = "brand_logo_generation"
description = "Generating logo design concepts and images from brand briefs."
system_prompt = "None"
main_pipe = "generate_logos_from_brief"

[concept.BrandBrief]
description = """
A brand brief containing essential information about a company's identity and design preferences for logo creation.
"""

[concept.BrandBrief.structure]
company_name = { type = "text", description = "The name of the company for which the logo is being designed", required = true }
industry = { type = "text", description = "The industry or sector in which the company operates", required = true }
style_preference = { type = "text", description = "The preferred visual style for the logo design", choices = [
    "minimalist",
    "bold",
    "playful",
    "elegant",
], required = true }

[concept.LogoConcept]
description = "A creative logo design concept with a name, description, and image generation prompt."

[concept.LogoConcept.structure]
name = { type = "text", description = "A short, memorable name for the logo concept", required = true }
description = { type = "text", description = "A detailed explanation of the logo concept and its design rationale", required = true }
visual_prompt = { type = "text", description = "A detailed prompt for generating the logo image", required = true }

[pipe.generate_logos_from_brief]
type = "PipeSequence"
description = """
Main pipeline that takes a brand brief, generates 3 logo concepts with matching images. First generates creative logo concepts from the brand brief, then renders each concept as a square logo image using batch processing.
"""
inputs = { brand_brief = "BrandBrief", visual_prompt = "Text" }
output = "Image"
steps = [
    { pipe = "generate_logo_concepts", result = "logo_concepts" },
    { pipe = "render_logo_image", result = "logo_images" },
]

[pipe.generate_logo_concepts]
type = "PipeLLM"
description = """
Analyzes the brand brief and generates 3 creative logo design concepts, each with a unique name, detailed description, and a visual prompt suitable for image generation.
"""
inputs = { brand_brief = "BrandBrief" }
output = "LogoConcept[3]"
model = "$img-gen-prompting"
system_prompt = """
You are an expert logo designer and brand strategist. Your task is to generate structured logo design concepts based on brand briefs. Each concept should be creative, distinctive, and aligned with the brand's identity and industry. For visual prompts, be VERY concise and focus on key visual elements using best practices for image generation.
"""
prompt = """
Create 3 unique and creative logo design concepts for the following brand:

@brand_brief

For each concept, provide a memorable name, a detailed description explaining the design rationale, and a concise visual prompt optimized for image generation. Ensure each concept reflects the brand's industry and style preference while being visually distinct from the others.
"""

[pipe.render_logo_image]
type = "PipeImgGen"
description = "Generates a square logo image from the visual prompt of a single logo concept."
inputs = { visual_prompt = "Text" }
output = "Image"
prompt = "$visual_prompt"
model = "$gen-image-high-quality"
