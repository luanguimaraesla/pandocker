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

    - pandoc_command: String with the pandoc shell command to run.

  ## Examples

    iex> Executor.dispatch("pandoc -o out.pdf test.md")
    :ok

  """
  def dispatch(commands) do
    commands
    |> List.insert_at(0, goto_source_command())
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

  defp goto_source_command do
    root  = Configuration.Manager.get_env(:project_root)
    source = Configuration.Manager.get_config(:pandoc, :source_path, &List.to_string/1)
    "cd " <> Path.join(root, source)
  end
end
