domain = "startup_mascot_design"
description = "Creating cute animal mascots for startups based on elevator pitches and brand guidelines."
main_pipe = "create_startup_mascot"

[concept.ElevatorPitch]
description = "A brief, compelling summary of a startup's business idea, value proposition, and target market."
refines = "Text"

[concept.BrandGuidelines]
description = "A document outlining a company's visual identity, tone of voice, values, and design standards."
refines = "Text"

[concept.BrandAnalysis]
description = "A structured breakdown of a brand's identity derived from its materials."

[concept.BrandAnalysis.structure]
key_attributes = { type = "text", description = "Core characteristics that define the brand's identity", required = true }
personality_traits = { type = "text", description = "Human-like traits that describe the brand's character", required = true }
color_palette = { type = "text", description = "Primary and secondary colors associated with the brand", required = true }
tone = { type = "text", description = "The communication style and voice of the brand", required = true }

[concept.MascotConcept]
description = "A proposed animal mascot idea with supporting rationale and visual direction."

[concept.MascotConcept.structure]
animal_type = { type = "text", description = "The species or type of animal proposed as mascot", required = true }
rationale = { type = "text", description = "Explanation of why this animal fits the brand", required = true }
personality_description = { type = "text", description = "The character traits and demeanor of the mascot", required = true }
visual_style_notes = { type = "text", description = "Initial ideas for the mascot's visual treatment" }

[concept.MascotSpecification]
description = "A detailed specification for a selected mascot including visual and character details."

[concept.MascotSpecification.structure]
animal = { type = "text", description = "The chosen animal species for the mascot", required = true }
name_suggestion = { type = "text", description = "A proposed name for the mascot character" }
detailed_appearance = { type = "text", description = "Comprehensive description of the mascot's physical look", required = true }
pose = { type = "text", description = "The body position and stance of the mascot", required = true }
expression = { type = "text", description = "The facial expression conveying the mascot's mood", required = true }
accessories = { type = "text", description = "Any props, clothing, or items the mascot carries or wears" }

[concept.ImagePrompt]
description = "A detailed text prompt designed to guide an image generation system."
refines = "Text"

[pipe.create_startup_mascot]
type = "PipeSequence"
description = """
Main pipeline that takes a startup's elevator pitch and brand guidelines, analyzes the brand, generates mascot concepts, selects the best one, and produces a cute mascot illustration.
"""
inputs = { elevator_pitch = "ElevatorPitch", brand_guidelines = "BrandGuidelines" }
output = "Image"
steps = [
    { pipe = "analyze_brand_identity", result = "brand_analysis" },
    { pipe = "generate_mascot_concepts", result = "mascot_concepts" },
    { pipe = "select_best_mascot", result = "selected_mascot" },
    { pipe = "write_image_prompt", result = "mascot_prompt" },
    { pipe = "generate_mascot_image", result = "mascot_image" },
]

[pipe.analyze_brand_identity]
type = "PipeLLM"
description = """
Analyzes the startup's elevator pitch and brand guidelines to extract key brand attributes, personality traits, color palette, and communication tone.
"""
inputs = { elevator_pitch = "ElevatorPitch", brand_guidelines = "BrandGuidelines" }
output = "BrandAnalysis"
model = "llm_to_answer_questions"
system_prompt = """
You are a brand strategist expert. Your task is to analyze startup materials and extract a structured brand analysis. Focus on identifying the core identity elements that define the brand.
"""
prompt = """
Analyze the following startup materials to extract the brand identity:

@elevator_pitch

@brand_guidelines

Based on these materials, provide a structured brand analysis.
"""

[pipe.generate_mascot_concepts]
type = "PipeLLM"
description = """
Brainstorms multiple animal mascot ideas that embody the brand identity, considering animal symbolism, appeal to target audience, and visual potential.
"""
inputs = { brand_analysis = "BrandAnalysis", elevator_pitch = "ElevatorPitch" }
output = "MascotConcept[3]"
model = "cheap_llm_for_creativity"
system_prompt = """
You are a creative brand strategist specializing in mascot design. Your task is to generate structured mascot concepts that align with a brand's identity. Consider animal symbolism, cultural associations, and visual appeal when brainstorming ideas.
"""
prompt = """
Based on the following brand analysis and elevator pitch, brainstorm 3 distinct animal mascot concepts that would effectively represent this startup's brand identity.

Consider:
- Animal symbolism and what traits each animal represents
- Appeal to the target audience
- Visual potential for illustrations and marketing materials
- How well the animal embodies the brand's personality traits and tone

@brand_analysis

@elevator_pitch
"""

[pipe.select_best_mascot]
type = "PipeLLM"
description = """
Evaluates the mascot concepts against brand analysis and guidelines, selecting the most fitting mascot with detailed visual and character specifications.
"""
inputs = { mascot_concepts = "MascotConcept", brand_analysis = "BrandAnalysis", brand_guidelines = "BrandGuidelines" }
output = "MascotSpecification"
model = "llm_to_answer_questions"
system_prompt = """
You are a brand strategist and mascot design expert. Your task is to evaluate mascot concepts and select the best one that aligns with the brand identity. You will output a structured mascot specification.
"""
prompt = """
Evaluate the following mascot concepts and select the one that best fits the brand identity. Consider how well each concept aligns with the brand's personality, values, and visual guidelines.

@mascot_concepts

@brand_analysis

@brand_guidelines

Select the most fitting mascot and provide a detailed specification including the animal choice, a suggested name, comprehensive appearance details, pose, expression, and any accessories that reinforce the brand identity.
"""

[pipe.write_image_prompt]
type = "PipeLLM"
description = """
Crafts a detailed image generation prompt for creating a cute mascot illustration, incorporating the mascot specification and brand colors.
"""
inputs = { selected_mascot = "MascotSpecification", brand_analysis = "BrandAnalysis" }
output = "ImagePrompt"
model = "cheap_llm_for_creativity"
system_prompt = """
You are an expert at crafting image generation prompts. Write concise, visually descriptive prompts that focus on key visual elements. Follow best practices: lead with subject, include style keywords, specify colors, and avoid verbose descriptions.
"""
prompt = """
Create a concise image generation prompt for a cute mascot illustration based on the following:

@selected_mascot

Brand colors and tone:
@brand_analysis

Write a single, focused prompt that captures the mascot's appearance, pose, expression, and incorporates the brand's color palette. Keep it under 100 words and optimized for image generation.
"""

[pipe.generate_mascot_image]
type = "PipeImgGen"
description = "Generates the cute animal mascot illustration from the crafted prompt."
inputs = { mascot_prompt = "ImagePrompt" }
output = "Image"
img_gen_prompt_var_name = "mascot_prompt"
model = "gen_image_high_quality"
