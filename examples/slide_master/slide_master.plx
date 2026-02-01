domain = "slide_master"
description = "Data model for slide prompt generation with reusable themes"
main_pipe = "generate_design_proposals_from_rough_brief"

# Input concept for design brief

[concept.SlideDesignBrief]
description = "Client brief for slide deck design"

[concept.SlideDesignBrief.structure]
topic = { type = "text", description = "The main topic or subject of the presentation", required = true }
brand_guidelines = { type = "text", description = "The client's brand guidelines (colors, fonts, logo usage, etc.)", required = false }
brand_personality = { type = "text", description = "The brand personality", choices = ["formal", "playful", "innovative", "trustworthy", "artsy"], required = false }
existing_references = { type = "text", description = "Existing templates or past decks to reference or avoid", required = false }
goal = { type = "text", description = "The goal of the presentation", choices = ["pitch investors", "sell to clients", "internal training", "keynote"], required = false }
audience = { type = "text", description = "The target audience", choices = ["executives", "technical team", "general public"], required = false }

# Nested structures for Theme

[concept.ColorPalette]
description = "Color scheme for the presentation theme"

[concept.ColorPalette.structure]
primary = { type = "text", description = "Primary brand color (hex or name)", required = true }
secondary = { type = "text", description = "Secondary color for accents", required = true }
accent = { type = "text", description = "Accent color for highlights", required = true }
background = { type = "text", description = "Background color", required = true }
text_primary = { type = "text", description = "Primary text color", required = true }
text_secondary = { type = "text", description = "Secondary text color for subtitles", required = true }

[concept.Typography]
description = "Font and text styling for the presentation"

[concept.Typography.structure]
font_family = { type = "text", description = "Primary font family name", required = true }
heading_style = { type = "text", description = "Style description for headings (e.g., bold, uppercase)" }
body_style = { type = "text", description = "Style description for body text" }

[concept.LayoutSettings]
description = "Layout configuration for slides"

[concept.LayoutSettings.structure]
aspect_ratio = { type = "text", description = "Slide aspect ratio", required = true, choices = ["16:9", "4:3", "1:1"] }
margins = { type = "text", description = "Margin style (e.g., narrow, standard, wide)" }
alignment = { type = "text", description = "Default content alignment (e.g., left, center, right)" }

[concept.StyleSettings]
description = "Visual style preferences for the presentation"

[concept.StyleSettings.structure]
overall = { type = "text", description = "Overall visual style (e.g., minimal, corporate, creative)", required = true }
icon_style = { type = "text", description = "Style for icons (e.g., outline, filled, flat)" }
graphic_style = { type = "text", description = "Style for graphics and illustrations" }

# Main Theme concept

[concept.Theme]
description = "Complete presentation theme with colors, typography, layout, and style"

[concept.Theme.structure]
name = { type = "text", description = "Theme name identifier", required = true }
colors = { type = "concept", concept_ref = "slide_master.ColorPalette", description = "Color palette for the theme", required = true }
typography = { type = "concept", concept_ref = "slide_master.Typography", description = "Typography settings", required = true }
layout = { type = "concept", concept_ref = "slide_master.LayoutSettings", description = "Layout configuration", required = true }
style = { type = "concept", concept_ref = "slide_master.StyleSettings", description = "Visual style settings", required = true }
exclusions = { type = "text", description = "Elements to avoid in the design (e.g., no gradients, no stock photos)" }

# Slide content concept

[concept.Slide]
description = "Content definition for a single slide"

[concept.Slide.structure]
slide_type = { type = "text", description = "Type of slide layout", required = true, choices = ["title", "content", "comparison", "process", "infographic", "quote", "closing"] }
title = { type = "text", description = "Slide title", required = true }
subtitle = { type = "text", description = "Optional subtitle or tagline" }
content = { type = "text", description = "Main content or bullet points for the slide", required = true }
graphics = { type = "text", description = "Description of visual elements or graphics to include" }
layout_override = { type = "text", description = "Optional layout override for this specific slide" }

# Output concepts

[concept.SlidePrompt]
description = "Generated image prompt ready for slide image generation"
refines = "Text"

# Pipes

[pipe.polish_brief]
type = "PipeLLM"
description = "Polish and complete a slide design brief by filling missing fields"
inputs = { brief = "SlideDesignBrief" }
output = "SlideDesignBrief"
prompt = """
You are a professional presentation design consultant. Review this client brief and enhance it.

@brief

Your task:
1. Keep all provided information, but refine the wording if needed for clarity
2. For any missing fields, infer sensible defaults based on the topic and any other provided context
3. Ensure brand_personality, goal, and audience are filled in with the most appropriate choice
4. If brand_guidelines are missing, leave them empty (do not invent specific colors or fonts)

Return a complete, polished brief.
"""

[pipe.generate_theme]
type = "PipeLLM"
description = "Generate a presentation theme from a polished design brief"
inputs = { brief = "SlideDesignBrief" }
output = "Theme"
prompt = """
You are an expert presentation designer. Create a cohesive visual theme based on this design brief.

@brief

Generate a complete theme with:

1. **Name**: A short, memorable theme name reflecting the brand personality and topic

2. **Colors**: A harmonious color palette appropriate for the brand personality and audience
   - If brand_guidelines specify colors, use them
   - Otherwise, choose colors that match the personality (e.g., formal = navy/gray, playful = vibrant, innovative = bold accents)
   - Ensure sufficient contrast for readability

3. **Typography**: Font choices that match the personality
   - Formal: serif or clean sans-serif (e.g., Georgia, Helvetica)
   - Playful: rounded or friendly fonts (e.g., Nunito, Poppins)
   - Innovative: modern geometric fonts (e.g., Futura, Montserrat)
   - Artsy: distinctive display fonts with classic body text

4. **Layout**: Appropriate settings for the presentation goal
   - Aspect ratio: 16:9 for most presentations, 4:3 for traditional settings
   - Margins and alignment based on content density needs

5. **Style**: Overall visual approach
   - Match the brand personality and audience expectations
   - Define icon and graphic styles that complement the theme

6. **Exclusions**: Things to avoid based on the brief context
"""

[pipe.generate_multiple_themes]
type = "PipeLLM"
description = "Generate a presentation theme from a polished design brief"
inputs = { brief = "SlideDesignBrief" }
output = "Theme[]"
prompt = """
You are an expert presentation designer. Create {{ _nb_output }} cohesive visual themes based on this design brief.

@brief

Generate a complete theme with:

1. **Name**: A short, memorable theme name reflecting the brand personality and topic

2. **Colors**: A harmonious color palette appropriate for the brand personality and audience
   - If brand_guidelines specify colors, use them
   - Otherwise, choose colors that match the personality (e.g., formal = navy/gray, playful = vibrant, innovative = bold accents)
   - Ensure sufficient contrast for readability

3. **Typography**: Font choices that match the personality
   - Formal: serif or clean sans-serif (e.g., Georgia, Helvetica)
   - Playful: rounded or friendly fonts (e.g., Nunito, Poppins)
   - Innovative: modern geometric fonts (e.g., Futura, Montserrat)
   - Artsy: distinctive display fonts with classic body text

4. **Layout**: Appropriate settings for the presentation goal
   - Aspect ratio: 16:9 for most presentations, 4:3 for traditional settings
   - Margins and alignment based on content density needs

5. **Style**: Overall visual approach
   - Match the brand personality and audience expectations
   - Define icon and graphic styles that complement the theme

6. **Exclusions**: Things to avoid based on the brief context
"""

[pipe.generate_theme_from_rough_brief]
type = "PipeSequence"
description = "Transform a design brief into a complete presentation theme"
inputs = { brief = "SlideDesignBrief" }
output = "Theme"
steps = [
    { pipe = "polish_brief", result = "polished_brief" },
    { pipe = "generate_theme", result = "theme" }
]

[pipe.render_visual_proposal]
type = "PipeImgGen"
description = "Generate a visual mockup image from a theme"
inputs = { theme = "Theme" }
output = "Image"
aspect_ratio = "landscape_16_9"
model = "nano-banana-pro"
prompt = """
Render a composition of 4 slide mockups based on the following theme:

$theme

---

The composition should be a grid of 4 slides, each with the following layout:
- Title slide
- Content slide
- Comparison slide
- Process slide

Make the mosaic edge to edge, no space between the slides.
"""

[pipe.generate_design_proposals_from_rough_brief]
type = "PipeSequence"
description = "Transform a design brief into multiple themes with visual mockups"
inputs = { brief = "SlideDesignBrief" }
output = "Image[]"
steps = [
    { pipe = "polish_brief", result = "polished_brief" },
    { pipe = "generate_multiple_themes", nb_output = 3, result = "themes" },
    { pipe = "render_visual_proposal", batch_over = "themes", batch_as = "theme", result = "design_proposals" }
]
