# Pipelex Starter Project

## Commands

### Linting & Type Checking

After making code changes, always run:
```bash
make agent-check
```
This runs: fix-unused-imports, ruff format, ruff lint, plxt format/lint (`.mthds`/`.toml`), pyright, mypy.

### Running Tests

```bash
make agent-test
```
Silent on success, full output on failure. Excludes inference/LLM markers by default.

Run specific tests (local only): `make tp TEST=test_function_name`

### Other Useful Targets

- `make install` - Create venv + install all deps (uses uv)
- `make li` - Lock + install
- `make cleanderived` - Remove caches/compiled files (useful when linters get confused)
- `make validate` / `make v` - Run pipelex validate --all
- `make tb` - Quick boot test
- `make fui` - Fix unused imports only
- `make plxt-format` - Format `.mthds`/`.toml` files with plxt
- `make plxt-lint` - Lint `.mthds`/`.toml` files with plxt

## Project Structure

- Package: `my_project/` (Python 3.10+, target 3.11)
- Tests: `tests/` (e2e, integration, test_pipelines)
- Dependency manager: uv (>=0.7.2)
- Pipelex dependency: `pipelex` package from PyPI (see pyproject.toml)
- `.mthds` files: Pipelex method definition files in `my_project/`
