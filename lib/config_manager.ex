defmodule ConfigManager do
  @moduledoc """
  Documentation for ConfigManager.
  """

  def get_app_config(dict, key, app \\ :pandocker) do
    app
    |> Application.get_env(dict)
    |> Map.get(key)
  end

  def get_env(key) when is_atom(key) do
    default = get_app_config(:defaults, key)
    sys_env = get_app_config(:envs, key)

    case {sys_env, default} do
      {nil, nil} -> nil
      {nil, _ } -> default
      _ -> System.get_env(sys_env) || default
    end
  end

  def get_yaml_section(section) when is_atom(section) do
    :config_yaml
    |> get_env
    |> load_configurations
    |> Map.get(Atom.to_charlist(section))
  end

  def get_config(section, key) when is_atom(key) do
    try do
      Map.new(ConfigManager.get_yaml_section(section))
      |> Map.get(Atom.to_charlist(key)) || get_env(key)
    rescue
      _ -> get_env(key)
    end
  end

  def get_config(section, key, fun) when is_function(fun) do
    get_config(section, key)
    |> fun.()
  end

  defp load_configurations(path) do
    Map.new(hd :yamerl_constr.file(path))
  end
end
