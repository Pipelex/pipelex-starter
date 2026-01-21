import runpy

import pytest

import my_project.hello_world


@pytest.mark.dry_runnable
@pytest.mark.inference
class TestMyProject:
    def test_hello_world(self):
        runpy.run_path(my_project.hello_world.__file__, run_name="__main__")
