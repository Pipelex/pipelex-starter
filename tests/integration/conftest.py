import pipelex.config
import pipelex.pipelex
import pytest
from pipelex.system.configuration.config_check import check_is_initialized
from pipelex.test_extras.shared_pytest_plugins import is_inference_disabled_in_pipelex
from pytest import FixtureRequest
from rich import print
from rich.console import Console
from rich.traceback import Traceback


@pytest.fixture(scope="session", autouse=True)
def check_pipelex_initialized():
    if not check_is_initialized():
        pytest.exit("Pipelex must be initialized before running the tests")
    yield


@pytest.fixture(scope="module", autouse=True)
def reset_pipelex_config_fixture(request: FixtureRequest):
    # Code to run before each test
    print("\n[magenta]pipelex setup[/magenta]")
    try:
        pipelex_instance = pipelex.pipelex.Pipelex.make(
            disable_inference=is_inference_disabled_in_pipelex(request),
        )
    except Exception as exc:
        Console().print(Traceback())
        pytest.exit(f"Critical Pipelex setup error: {exc}")
    yield
    # Code to run after each test
    print("\n[magenta]pipelex teardown[/magenta]")
    pipelex_instance.teardown()
