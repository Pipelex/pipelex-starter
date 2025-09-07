# Getting Started

### Create virtual environment, install Pipelex and other dependencies

```bash
make install
```

This will install the Pipelex python library and its dependencies using uv.

### Set up environment variables

```bash
cp .env.example .env
```

Enter your API key into your `.env` file.
Use your BlakcboxAI key for the `CUSTOM_ENDPOINT_API_KEY` variable like this:

```
CUSTOM_ENDPOINT_BASE_URL=https://api.blackbox.ai/v1
CUSTOM_ENDPOINT_API_KEY=...
```

### IDE extension

Install our extension for PLX files into your IDE of choice. You can find it in the [Open VSX Registry](https://open-vsx.org/extension/Pipelex/pipelex). Click the "Download" button, it will save the extension file, named something like `Pipelex.pipelex-0.2.1.vsix`. Open your IDE, go to the extensions tab, click the "..." button, select "Install from VSIX", locate the downloaded file, and click "Install".

### Now let's get the BlackboxAI agent create a pipeline

Open the agent chat.
Set it to "Auto" (optional but recommended).
You will ask it to create a pipeline for you and you must pass the appropriate documentation to it.
Here is an example of what you can ask it to do:
```
Create a pipeline to analyze a codebase submitted for a hackathon:
First
- Summarize the concept of the project

Then, analyze these 3 criteria in parallel:
- Problem fit & novelty
- Features: is it fake or are there powerful features behind each button, endpoint etc.
- Architecture & modularity
- Code quality: Tests (unit/integration), coverage, typing/linting, docstrings, READMEs/runbooks, CI checks.

Finally, output the results in a structured way.

Read AGENTS.md for instructions.
For PipeLLM, use blackbox AI models like I did in hello_world.plx, example:
llm = { llm_handle = "blackboxai/google/gemini-2.5-pro", temperature = 0.2 }
```

It will create a pipeline for you, along with example code to run it.

---
Happy Piping!