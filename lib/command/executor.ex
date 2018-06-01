defmodule Command.Executor do
  @moduledoc """
  Module to execute Pandocker command using the :os.cmd command from erlang

  Functions:

    - `dispatch/1`: runs the pandoc command in the correct directory with the
      source files.

  """


  require Logger


  @doc """
  Runs the pandoc command in the correct directory with the source files, and
  moves the output file to the project root

  ## Parameters

    - commands: List of strings with some shell commands to run.

  ## Examples

    iex> Command.Executor.dispatch(["pandoc -o out.pdf test.md"])
    :ok

  """
  def dispatch({execution_path, commands}) do
    commands
    |> List.insert_at(0, goto_execution_path(execution_path))
    |> make_os_command
    |> execute
    :ok
  end

  defp execute(command) do
    command
    |> :os.cmd
    |> List.to_string
    |> Logger.info
  end

  defp make_os_command(commands) when is_list(commands) do
    os_command = Enum.join(commands, " && ")
    Logger.info "Executing: " <> os_command
    String.to_charlist(os_command)
  end

  defp goto_execution_path(execution_path) do
    "cd " <> execution_path
  end
end
