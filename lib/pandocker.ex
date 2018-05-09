defmodule Pandocker do
  @moduledoc """
  This module defines some Pandocker tasks

  Functions:

    - `run/0`: runs pandoc by concatenating the list of files described in
      the section 'sections' of the YAML configuration file.
  """


  require Logger


  @doc """
  runs pandoc by concatenating the list of files described in the section
  'sections' of the YAML configuration file

  ## Example:

    iex> System.put_env("PANDOCKER_CONFIG_YAML", "test.yml")
    iex> System.put_env("PANDOCKER_CMD", "help")
    iex> Pandocker.run
    :ok

  """
  def run do
    command = Configuration.Manager.get_env(:command) |> String.to_atom

    {module, arg} = case command do
      :compile -> {"Elixir.Command.Pandoc", Configuration.Manager.get_yaml_section(:sections)}
      :help -> {"Elixir.Command.Help", nil}
      _ -> raise "Missing function"
    end

    module
    |> String.to_existing_atom
    |> apply(:exec, (if arg, do: [arg], else: []))
  end
end
