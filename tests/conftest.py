import atexit
import os

import pytest
from rich import print

pytest_plugins = [
    "pipelex.test_extras.shared_pytest_plugins",
]


@pytest.fixture(scope="function", autouse=True)
def pretty():
    # Code to run before each test
    print("\n")
    yield
    # Code to run after each test
    print("\n")


def _setup_ci_env_vars():
    """Set placeholder environment variables when running in CI to prevent import failures.

    These placeholders allow the code to import successfully, while actual inference tests
    remain skipped via pytest markers.
    """
    # Check if we're running in CI (GitHub Actions or generic CI environment)
    if os.getenv("CI") or os.getenv("GITHUB_ACTIONS"):
        print("[yellow]CI environment detected - setting placeholder API keys[/yellow]")

        # Define placeholder values for all inference-related env vars
        ci_placeholders = {
            "PIPELEX_API_TOKEN": "ci-placeholder-token",
            "PIPELEX_API_BASE_URL": "https://app.pipelex.ai/api/v1",
            "PIPELEX_INFERENCE_API_KEY": "ci-placeholder-inference-key",
            "OPENAI_API_KEY": "sk-ci-placeholder-key",
            "AWS_ACCESS_KEY_ID": "ci-placeholder-aws-key",
            "AWS_SECRET_ACCESS_KEY": "ci-placeholder-aws-secret",
            "AWS_REGION": "us-east-1",
            "AZURE_OPENAI_API_ENDPOINT": "https://ci-placeholder.openai.azure.com",
            "AZURE_OPENAI_API_VERSION": "2025-04-01-preview",
            "AZURE_OPENAI_API_KEY": "ci-placeholder-azure-key",
            "AZURE_API_BASE": "https://ci-placeholder.openai.azure.com",
            "AZURE_API_KEY": "ci-placeholder-azure-api-key",
            "AZURE_API_VERSION": "2025-04-01-preview",
            "ANTHROPIC_API_KEY": "sk-ant-ci-placeholder-key",
            "MISTRAL_API_KEY": "ci-placeholder-mistral-key",
            "PERPLEXITY_API_KEY": "ci-placeholder-perplexity-key",
            "PERPLEXITY_API_ENDPOINT": "https://api.perplexity.ai",
            "FAL_API_KEY": "ci-placeholder-fal-key",
            "GCP_PROJECT_ID": "ci-placeholder-project",
            "GCP_REGION": "us-central1",
            "GCP_LOCATION": "us-central1",
            "GCP_CREDENTIALS_FILE_PATH": "/tmp/ci-placeholder-gcp-credentials.json",
            "XAI_API_KEY": "ci-placeholder-xai-key",
            "XAI_API_ENDPOINT": "https://api.x.ai/v1/",
            "BLACKBOX_API_KEY": "ci-placeholder-blackbox-key",
            "CUSTOM_ENDPOINT_BASE_URL": "http://localhost:11434/v1/",
            "CUSTOM_ENDPOINT_API_KEY": "ci-placeholder-custom-key",
        }

        # Set placeholders, overriding any existing values in CI
        # This ensures tests won't accidentally use real API keys in CI
        for key, value in ci_placeholders.items():
            os.environ[key] = value

        # Temporarily modify backends.toml to disable problematic backends in CI
        backends_path = ".pipelex/inference/backends.toml"
        backup_path = ".pipelex/inference/backends.toml.backup"

        # Create backup if it doesn't exist
        if not os.path.exists(backup_path):
            with open(backends_path, "r") as f:
                original_content = f.read()
            with open(backup_path, "w") as f:
                f.write(original_content)

        # Modify the original file to disable vertexai
        with open(backends_path, "r") as f:
            content = f.read()

        # Disable vertexai backend for CI
        content = content.replace("[vertexai]\nenabled = true", "[vertexai]\nenabled = false")

        with open(backends_path, "w") as f:
            f.write(content)

        print(f"[yellow]Set {len(ci_placeholders)} placeholder environment variables[/yellow]")


def _restore_ci_backends_file():
    """Restore original backends.toml file if we're in CI and a backup exists."""
    if os.getenv("CI") or os.getenv("GITHUB_ACTIONS"):
        backends_path = ".pipelex/inference/backends.toml"
        backup_path = ".pipelex/inference/backends.toml.backup"

        if os.path.exists(backup_path):
            with open(backup_path, "r") as f:
                original_content = f.read()
            with open(backends_path, "w") as f:
                f.write(original_content)
            os.remove(backup_path)
            print("[yellow]Restored original backends.toml file[/yellow]")


# Set up CI environment variables before any imports that might need them
_setup_ci_env_vars()

# Register cleanup function to restore backends file
atexit.register(_restore_ci_backends_file)
