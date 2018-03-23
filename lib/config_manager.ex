defmodule ConfigManager do
  @moduledoc """
  Documentation for ConfigManager.
  """
  defp fetch_config_yaml do
    config_yaml = Application.get_env(:pandocker, :config_yaml)
    config_path = config_yaml |> Map.get(:env) |> System.get_env
    config_path || config_yaml |> Map.get(:default)
  end

  defp load_configurations(path) do
    Map.new(hd :yamerl_constr.file(path))
  end

  def get_section(section) do
    fetch_config_yaml()
    |> load_configurations
    |> Map.get(section)
  end
end
