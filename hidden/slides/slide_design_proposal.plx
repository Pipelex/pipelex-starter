domain = "slide_design"
description = "Generate slide design previews from presentation briefs"
main_pipe = "generate_slide_preview"

# ============================================================================
# CONCEPTS
# ============================================================================

[concept.PresentationBrief]
description = "User's input describing what they want in their presentation"

[concept.PresentationBrief.structure]
topic = { type = "text", description = "Main topic or title of the presentation", required = true }
purpose = { type = "text", description = "Goal of the presentation (inform, persuade, educate, etc.)" }
audience = { type = "text", description = "Target audience for the presentation" }
tone = { type = "text", description = "Desired tone (professional, casual, technical, creative, etc.)" }
brand_colors = { type = "text", description = "Any specific brand colors to use (hex codes or color names)" }

[concept.SlideDesign]
description = "Visual design specification for a presentation slide"

[concept.SlideDesign.structure]
style = { type = "text", description = "Overall aesthetic (minimalist, bold, corporate, etc.)", required = true }
color_palette = { type = "text", description = "Primary, secondary, accent, and background colors", required = true }
typography = { type = "text", description = "Font style and hierarchy description", required = true }
layout = { type = "text", description = "Composition and element placement", required = true }
graphic_elements = { type = "text", description = "Icons, shapes, or decorative elements to include" }
sample_title = { type = "text", description = "Example title text to show in the preview", required = true }
sample_subtitle = { type = "text", description = "Example subtitle or tagline" }

# ============================================================================
# PIPES
# ============================================================================

# Main pipe first
[pipe.generate_slide_preview]
type = "PipeSequence"
description = "Generate a slide design preview image from a brief"
inputs = { brief = "PresentationBrief" }
output = "Image"
steps = [
    { pipe = "create_design", result = "design" },
    { pipe = "design_to_prompt", result = "img_prompt" },
    { pipe = "render_slide", result = "image" }
]

# Step 1: Brief → Design
[pipe.create_design]
type = "PipeLLM"
description = "Create a slide design specification from the brief"
inputs = { brief = "PresentationBrief" }
output = "SlideDesign"
model = "@default-small-structured"
system_prompt = "You are a presentation design expert. Create cohesive, professional slide designs."
prompt = """
Create a slide design specification for this presentation:

@brief

Design a visually appealing slide that:
- Matches the tone and audience
- Uses the brand colors if provided, or suggests appropriate colors
- Has clear visual hierarchy
- Feels modern and professional

Include a sample title based on the topic (this will appear in the preview image).
"""

# Step 2: Design → ImgGenPrompt
[pipe.design_to_prompt]
type = "PipeLLM"
description = "Convert the design specification into an image generation prompt"
inputs = { design = "SlideDesign" }
output = "ImgGenPrompt"
model = "@default-small-structured"
system_prompt = "You are an expert at writing prompts for AI image generation. Create detailed, structured prompts that produce consistent, high-quality presentation slide images."
prompt = """
Convert this slide design into a prompt for generating a square (1:1) presentation slide image:

@design

Write a detailed image generation prompt that will produce a professional presentation slide.

The prompt must:
- Describe a single square (1:1) slide with the exact colors, typography style, and layout specified
- Include the sample title text rendered on the slide
- Specify "clean, professional presentation slide" aesthetic
- Mention "no watermarks, no artifacts, crisp text rendering"
- Be specific about element placement (title position, spacing, decorative elements)

Output ONLY the prompt text, nothing else.
"""

# Step 3: ImgGenPrompt → Image
[pipe.render_slide]
type = "PipeImgGen"
description = "Generate the slide preview image"
inputs = { img_prompt = "ImgGenPrompt" }
output = "Image"
prompt = "$img_prompt"
model = "@default-premium"
# model = "fast-lightning-sdxl"
aspect_ratio = "landscape_16_9"
