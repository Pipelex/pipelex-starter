import pytest


@pytest.mark.dry_runnable
@pytest.mark.inference
class TestMyProject:
    def test_hello_world(self):
        import my_project.hello_world  # noqa: F401
