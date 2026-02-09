domain = "recipe_card_generation"
description = "Generating recipes from available ingredients and rendering them as HTML recipe cards."
system_prompt = "None"
main_pipe = "generate_recipe_card"

[concept.Recipe]
description = "A structured recipe containing all details needed to prepare a dish."

[concept.Recipe.structure]
title = { type = "text", description = "The name of the recipe", required = true }
ingredients = { type = "text", description = "List of ingredients needed for the recipe", required = true }
instructions = { type = "text", description = "Step-by-step cooking instructions", required = true }
prep_time_minutes = { type = "integer", description = "Time required for preparation in minutes", required = true }
cook_time_minutes = { type = "integer", description = "Time required for cooking in minutes", required = true }
servings = { type = "integer", description = "Number of servings the recipe yields", required = true }
difficulty = { type = "text", description = "Difficulty level of the recipe (easy, medium, or hard)", required = true }

[pipe.generate_recipe_card]
type = "PipeSequence"
description = """
Main pipeline that generates a recipe from available ingredients and renders it as a styled HTML recipe card. Orchestrates the recipe generation and HTML rendering steps in sequence.
"""
inputs = { available_ingredients = "Text" }
output = "Html"
steps = [
    { pipe = "recipe_generation", result = "recipe" },
    { pipe = "render_recipe_card", result = "recipe_card_html" },
]

[pipe.recipe_generation]
type = "PipeLLM"
description = """
Generate a complete recipe based on available ingredients, including title, ingredients list, instructions, timing, servings, and difficulty level.
"""
inputs = { available_ingredients = "Text" }
output = "Recipe"
model = "$writing-creative"
system_prompt = """
You are a skilled chef and recipe creator. Your task is to generate a complete structured recipe based on the ingredients provided by the user.
"""
prompt = """
Create a recipe using the following available ingredients:

@available_ingredients

Generate a complete recipe that makes the best use of these ingredients. You may assume common pantry staples (salt, pepper, oil, basic spices) are available even if not listed.
"""

[pipe.render_recipe_card]
type = "PipeCompose"
description = """
Render the recipe into a styled HTML card displaying all recipe details including title, ingredients, instructions, timing, servings, and difficulty.
"""
inputs = { recipe = "Recipe" }
output = "Html"

[pipe.render_recipe_card.template]
template = """
<div class="recipe-card">
@recipe
</div>
"""
templating_style = { tag_style = "xml", text_format = "html" }
category = "html"
