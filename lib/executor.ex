defmodule Executor do
  require Logger
  @moduledoc """
  Documentation for Executor.
  """
  def execute(command) do
    local  = System.get_env("PANDOCKER_PATH") || "/code"
    config = Map.new(ConfigManager.get_section('pandoc'))
    source = List.to_string(config['source_path'] || 'src')
    output = List.to_string(config['output'] || 'out.pdf')
    full_command = "cd #{local}/#{source} && #{command} && mv #{output} #{local}"

    Logger.info "Command: " <> full_command

    System.put_env("PATH", System.get_env("PATH") <> ":/root/.cabal/bin")
    
    full_command
    |> String.to_charlist
    |> :os.cmd
    |> List.to_string
    |> Logger.info
  end
end
