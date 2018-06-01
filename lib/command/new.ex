defmodule Command.New do
  @moduledoc """
  Command to create a new blank structure for a new project
  according to a template stored at Github
  """

  alias Configuration.Manager
  alias Command.Executor

  @doc """
  Function to be executed by Pandocker
  """
  def exec do
    build_command()
    |> Executor.dispatch
  end

  defp build_command do
    execution_path = Manager.get_env(:project_root)
    {execution_path, [git_clone_command(), copy_template_command()]}
  end

  defp git_clone_command do
    template_url = Manager.get_env(:templates_url)
    "git clone " <> template_url <> " /tmp/tmplt"
  end

  defp copy_template_command do
    template_name = Manager.get_env(:template)
    "cp -r " <> Path.join(["/tmp/tmplt/", template_name, "*"]) <> " ."
  end
end
