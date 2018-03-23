defmodule Executor do
  @moduledoc """
  Documentation for Executor.
  """
  def execute(command) do
    local  = System.get_env("PANDOCKER_PATH") || "/code"
    config = Map.new(ConfigManager.get_section('pandoc'))
    source = List.to_string(config['source_path'] || 'src')
    output = List.to_string(config['output'] || 'out.pdf')

    :os.cmd String.to_charlist(
      "cd #{local}/#{source} && #{command} && mv #{output} #{local}"
    )
  end
end
