domain = "cat_generator"
description = "Generates unique cat images with varied breeds, poses, settings, and artistic styles"
main_pipe = "generate_cat_image"

[concept.CatPrompt]
description = """
A detailed textual description of a cat scene optimized for image generation, including breed, pose, setting, lighting, and artistic style.
"""
refines = "Text"

[pipe.generate_cat_image]
type = "PipeSequence"
description = """
Main pipeline that creates unique cat images - first generates a creative prompt describing a cat, then renders it as an image
"""
output = "Image"
steps = [
    { pipe = "imagine_cat", result = "cat_prompt" },
    { pipe = "render_cat", result = "cat_image" },
]

[pipe.imagine_cat]
type = "PipeLLM"
description = """
Generates a creative, detailed cat image prompt with varied breeds, poses, settings, and artistic styles to ensure unique images each time
"""
output = "CatPrompt"
model = "$img-gen-prompting-cheap"
system_prompt = """
You are a creative cat portrait artist specializing in diverse and beautiful cat imagery. Your task is to generate vivid, detailed image prompts that showcase cats in interesting settings with varied artistic styles.
"""
prompt = """
Generate a unique cat image prompt. Vary these elements:
- Breed: domestic shorthair, Persian, Siamese, Maine Coon, tabby, calico, tuxedo, orange, etc.
- Pose: lounging, playing, curious, sleeping, stretching, hunting, sitting regally
- Setting: sunlit window, garden, cozy blanket, bookshelf, rooftop, meadow, studio portrait
- Style: photorealistic, watercolor, oil painting, anime, vintage photograph, illustration

Be concise but vivid. Focus on visual details that work well for image generation.
"""

[pipe.render_cat]
type = "PipeImgGen"
description = "Generates the cat image based on the creative prompt"
inputs = { cat_prompt = "CatPrompt" }
output = "Image"
prompt = "$cat_prompt"
model = "@default-small"
aspect_ratio = "square"
