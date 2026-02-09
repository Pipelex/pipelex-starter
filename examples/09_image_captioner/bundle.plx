domain = "image_captioning"
description = "Generating descriptive captions for images using vision-language models."
main_pipe = "caption_images_batch"

[concept.Caption]
description = "A descriptive text explaining what is shown in an image."
refines = "Text"

[pipe.caption_images_batch]
type = "PipeBatch"
description = """
Main pipeline entry point that processes each image in the input list concurrently to generate descriptive captions using batch processing.
"""
inputs = { images = "Image[]" }
output = "Caption[]"
branch_pipe_code = "caption_image_pipe"
input_list_name = "images"
input_item_name = "image"

[pipe.caption_image_pipe]
type = "PipeLLM"
description = """
Generates a descriptive caption explaining what is shown in the image using vision-language-model capabilities.
"""
inputs = { image = "Image" }
output = "Caption"
model = "$vision"
system_prompt = """
You are an expert image captioning assistant. Your task is to generate a structured caption describing what is shown in the provided image.
"""
prompt = """
Analyze the following image and generate a descriptive caption explaining what is shown.

$image
"""
