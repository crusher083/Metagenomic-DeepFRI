import pytest
from click.testing import CliRunner

from mDeepFRI import cli


@pytest.fixture
def runner():
    return CliRunner()


# test click cli
def test_cli_help(runner):
    result = runner.invoke(cli.cli, ["--help"])
    assert result.exit_code == 0
    assert "--help" in result.output


def test_cli_build_db(runner):
    result = runner.invoke(cli.cli, ["build-db", "--help"])
    assert result.exit_code == 0
    assert "--help" in result.output
    assert "-m" in result.output
    assert "-t" in result.output


def test_cli_get_models(runner):
    result = runner.invoke(cli.cli, ["get-models", "--help"])
    assert result.exit_code == 0
    assert "--help" in result.output
    assert "-o" in result.output


def test_cli_predict_function(runner):
    result = runner.invoke(cli.cli, ["predict-function", "--help"])
    assert result.exit_code == 0
    assert "--help" in result.output
    assert "-i" in result.output
    assert "-o" in result.output
    assert "-m" in result.output
    assert "-t" in result.output
    assert "-d" in result.output
    assert "-w" in result.output
