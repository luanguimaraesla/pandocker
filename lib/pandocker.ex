defmodule Pandocker do
  @moduledoc """
  This module defines some Pandocker tasks

  Functions:

    - `run/0`: runs pandoc by concatenating the list of files described in
      the section 'sections' of the YAML configuration file.
  """

  @doc """
  runs pandoc by concatenating the list of files described in the section
  'sections' of the YAML configuration file

  ## Example:

    iex> System.put_env("PANDOCKER_CONFIG_YAML", "test.yml")
    iex> Pandocker.run
    :ok

  """
  def run do
    command = ConfigManager.get_env(:command) |> String.to_atom

    "Elixir.Pandocker"
    |> String.to_existing_atom
    |> apply(command, [])
  end

  def compile do
    ConfigManager.get_yaml_section(:sections)
    |> Pandoc.compile
  end

  def help do
    raise "Not Implemented"
  end

  def test do
    raise "Not Implemented"
  end
end
