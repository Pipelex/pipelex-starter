domain = "build_in_public"
description = "Generating build-in-public social media content from open-source changelogs and blurbs."
main_pipe = "write_build_in_public_posts"

[concept.Changelog]
description = """
A record of changes made to a software project, typically documenting new features, bug fixes, improvements, and breaking changes for a specific version or time period.
"""
refines = "Text"

[concept.Blurb]
description = """
A short promotional or descriptive text that provides context, personality, or narrative framing for content.
"""
refines = "Text"

[concept.ContentSummary]
description = """
A cohesive narrative that combines multiple source materials into a unified overview with key points highlighted.
"""

[concept.ContentSummary.structure]
summary = { type = "text", description = "The main narrative text combining all source materials", required = true }
key_highlights = { type = "text", description = "List of important points or achievements extracted from the sources", required = true }

[concept.SocialMediaPost]
description = """
Content formatted and optimized for sharing on social media platforms, tailored to platform conventions and audience expectations.
"""
refines = "Text"

[pipe.write_build_in_public_posts]
type = "PipeSequence"
description = """
Main pipeline that orchestrates the complete build-in-public content generation flow: merges changelogs with blurb, then generates social media posts for LinkedIn, Twitter, and Discord in parallel.
"""
inputs = { changelogs = "Changelog", blurb = "Blurb" }
output = "SocialMediaPost[]"
steps = [
    { pipe = "curate_content", result = "curated_content" },
    { pipe = "merge_content", result = "merged_content" },
    { pipe = "social_posts_parallel", result = "social_posts" },
]

[pipe.curate_content]
type = "PipeLLM"
description = """
Curates the changelogs to remove the trivial changes and keep the most important ones.
"""
inputs = { changelogs = "Changelog[]" }
output = "Changelog"
model = "claude-4.5-sonnet"
system_prompt = """
You are a content strategist skilled at curating technical docs.
"""
prompt = """
Your job is to curate the changelogs to remove the trivial changes and keep the most important ones.

@changelogs

- Keep mentions of contributors, they are very important.
- Do not recap what you removed at the end. Just output what you kept.
"""

[pipe.merge_content]
type = "PipeLLM"
description = """
Combines all changelogs with the blurb into a cohesive narrative summary with key highlights extracted.
"""
inputs = { curated_content = "Changelog", blurb = "Blurb" }
output = "ContentSummary"
model = "claude-4.1-opus"
system_prompt = """
You are a content strategist skilled at synthesizing technical changelogs with narrative context into cohesive summaries. Your task is to generate a structured ContentSummary object.
"""
prompt = """
Combine the following changelogs and blurb into a cohesive narrative summary.

@curated_content

@blurb

Create a unified narrative that weaves together the technical changes with the contextual framing provided by the blurb.
Extract and highlight the most important points and achievements.
Be synthetic: mention what matters and if useful, give one or several examples.
"""

[pipe.social_posts_parallel]
type = "PipeParallel"
description = "Generates LinkedIn, Twitter, and Discord posts concurrently from the merged content."
inputs = { merged_content = "ContentSummary" }
output = "SocialMediaPost[]"
parallels = [
    { pipe = "generate_linkedin_post", result = "linkedin_post" },
    { pipe = "generate_twitter_post", result = "twitter_post" },
    { pipe = "generate_discord_post", result = "discord_post" },
]
add_each_output = true

[pipe.generate_linkedin_post]
type = "PipeLLM"
description = """
Creates a LinkedIn post optimized for professional audience with build-in-public tone, leveraging the merged content summary and highlights.
"""
inputs = { merged_content = "ContentSummary" }
output = "SocialMediaPost"
model = "claude-4.1-opus"
system_prompt = """
You are a professional social media content creator specializing in LinkedIn posts. Create engaging, authentic content with a build-in-public tone that resonates with a professional audience. The output should be a structured SocialMediaPost.
"""
prompt = """
Create a LinkedIn post based on the following content summary and key highlights.

@merged_content

The post should:
- Have a build-in-public tone that's authentic and engaging
- Be optimized for LinkedIn's professional audience
- Highlight key achievements and updates
- Use appropriate formatting for LinkedIn (line breaks, emojis if suitable)
- Be concise yet informative
- Encourage engagement from the professional community
"""

[pipe.generate_twitter_post]
type = "PipeLLM"
description = """
Creates a Twitter post optimized for brevity and engagement with build-in-public tone, using the merged content summary and highlights.
"""
inputs = { merged_content = "ContentSummary" }
output = "SocialMediaPost"
model = "claude-4.1-opus"
system_prompt = """
You are a social media expert specializing in Twitter content. Create engaging, concise posts optimized for Twitter's format with a build-in-public tone that showcases progress, learnings, and achievements authentically.
"""
prompt = """
Create a Twitter post based on the following content summary.

@merged_content

Requirements:
- Keep it concise and within Twitter's character limits
- Use a build-in-public tone (authentic, transparent, sharing the journey)
- Make it engaging and encourage interaction
- Include relevant hashtags if appropriate
- Focus on the most impactful highlights
"""

[pipe.generate_discord_post]
type = "PipeLLM"
description = """
Creates a Discord post optimized for community engagement with build-in-public tone, using the merged content summary and highlights.
"""
inputs = { merged_content = "ContentSummary" }
output = "SocialMediaPost"
model = "claude-4.1-opus"
system_prompt = """
You are a community manager specializing in Discord content. Create engaging, conversational posts optimized for Discord's format with a build-in-public tone that resonates with a developer and tech community audience.
"""
prompt = """
Create a Discord post based on the following content summary.

@merged_content


✅ DO's
•	Be conversational and casual
•	Get to the point quickly 
•	Invite feedback explicitly — ask a clear question or request input on a specific part of the work.
•	Use formatting for readability — bullets, short paragraphs, and occasional bold/italic for emphasis.
•	Show your thought process — highlight what you learned or what trade-offs you're considering.
❌ DON'Ts
•	Don't copy-paste the LinkedIn tone — avoid overly polished, corporate, or self-promotional language.
•	Don't write long walls of text — keep it tight.
•	Don't make vague calls for feedback — “Thoughts?” gets less engagement than “Does this API shape feel right to you?”
•	Don't oversell progress — Discord favors transparency over marketing spin.

Alkways address the message to @ everyone.
"""
