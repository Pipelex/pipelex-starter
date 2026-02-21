import runpy

import pytest


@pytest.mark.dry_runnable
@pytest.mark.inference
class TestMyProject:
    def test_hello_world(self):
        runpy.run_path("my_project/hello_world.py", run_name="__main__")
