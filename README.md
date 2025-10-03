# My Project ⚡️

*Replace "My Project" with your actual project name*

### Use this template

This is a template repository: don't clone it, click the green `Use this template` button at the top-right of the Github repo page.
Once you've created your repository from it, then you can clone it and follow the instructions below:

**Next steps after creating from template** (or later when you feel like it)
1. In `pyproject.toml`, replace "my-project" with your project name in the header, then replace "my_project" with your package name (using underscores) in the "packages" parameter of [tool.mypy] and the "include" parameter of [tool.pyright]
2. Replace "my_project" directory name with your package name (use underscores)
3. Update this README.md with your project details
4. Update the package imports in your code as needed

---

### Create virtual environment, install Pipelex and other dependencies

Choose the setup method that works best for you:

#### Option 1: `make install` (Unix/MacOS/Linux) — **Easy and fast** ✨

```bash
make install
```

This automatically creates a virtual environment, installs dependencies with `uv`, and initializes Pipelex libraries. Works on MacOS, Linux, and WSL.

#### Option 2: Using `uv` — **Fast** ⚡

If you have [uv](https://docs.astral.sh/uv/) installed:

```bash
uv venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
uv sync --all-extras
pipelex init libraries
pipelex init config
```

#### Option 3: Using `pip` — **Most Compatible** 🔧

For traditional Python environments:

```bash
# Create and activate virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt        # Production only
pip install -r requirements-dev.txt    # Or: with dev dependencies

# Initialize Pipelex
pipelex init libraries
pipelex init config
```

### API Key Configuration

Pipelex supports two approaches for accessing AI models:

#### Option A: Pipelex Inference (Optional & Free)

Get a single API key that works with all providers (OpenAI, Anthropic, Google, Mistral, FAL, and more):

1. **Get your API key:**
   - Join our Discord community: [https://go.pipelex.com/discord](https://go.pipelex.com/discord)
   - Request your free API key (no credit card required, limited time offer)

2. **Configure environment variables:**
   ```bash
   # Copy the example file
   cp .env.example .env
   
   # Edit .env and add your Pipelex Inference API key
   # PIPELEX_INFERENCE_API_KEY="your-api-key"
   ```
   
   > **Note:** Pipelex automatically loads environment variables from `.env` files. No need to manually source or export them.

3. **Verify backend configuration:**
   - The `pipelex_inference` backend is already enabled in `.pipelex/inference/backends.toml`
   - The default routing profile `pipelex_first` is configured to use Pipelex Inference

#### Option B: Bring Your Own Keys

Use your own API keys from individual providers (OpenAI, Anthropic, Google, Mistral, AWS Bedrock, Azure OpenAI, FAL):

1. **Configure environment variables:**
   ```bash
   # Copy the example file
   cp .env.example .env
   
   # Edit .env and add your provider API keys
   # OPENAI_API_KEY="your-openai-key"
   # ANTHROPIC_API_KEY="your-anthropic-key"
   # GOOGLE_API_KEY="your-google-key"
   # ... (add the keys you need)
   ```

2. **Configure backends:**
   - Edit `.pipelex/inference/backends.toml` to enable/disable backends
   - Set `enabled = true` for the backends you want to use
   - Set `enabled = false` for backends you don't need

3. **Select routing profile:**
   - Edit `.pipelex/inference/routing_profiles.toml`
   - Set `active = "custom_routing"` or create your own profile
   - Configure which backend handles which models

#### Option C: Mix & Match (Custom Routing)

Combine Pipelex Inference with your own keys for maximum flexibility:

1. **Configure environment variables:**
   ```bash
   # Copy and edit .env with both Pipelex and provider keys
   cp .env.example .env
   ```

2. **Enable multiple backends:**
   - Keep `pipelex_inference` enabled in `.pipelex/inference/backends.toml`
   - Enable specific provider backends (e.g., `openai`, `fal`)

3. **Create custom routing:**
   - Edit `.pipelex/inference/routing_profiles.toml`
   - Set up a hybrid profile routing some models to Pipelex, others to your backends

See the [configuration documentation](https://docs.pipelex.com/pages/configuration/config-technical/inference-backend-config/) for detailed setup instructions.

---

### IDE extension

We **highly** recommend installing our own extension for PLX files into your IDE of choice. You can find it in the [Open VSX Registry](https://open-vsx.org/extension/Pipelex/pipelex). It's coming soon to VS Code marketplace too and if you are using Cursor, Windsurf or another VS Code fork, you can search for it directly in your extensions tab.

---

## Contact & Support

| Channel                                | Use case                                                                  |
| -------------------------------------- | ------------------------------------------------------------------------- |
| **GitHub Discussions → "Show & Tell"** | Share ideas, brainstorm, get early feedback.                              |
| **GitHub Issues**                      | Report bugs or request features.                                          |
| **Email (privacy & security)**         | [security@pipelex.com](mailto:security@pipelex.com)                       |
| **Discord**                            | Real-time chat — [https://go.pipelex.com/discord](https://go.pipelex.com/discord) |


## 📝 License

This project is licensed under the [MIT license](LICENSE). Runtime dependencies are distributed under their own licenses via PyPI.

---

*Happy piping!* 🚀
