defmodule Configuration.Manager do
  @moduledoc """
  This module provides a simple interface to manage the Pandocker's configurations.

  Its configuration can be set in three different ways. The first is through
  a YAML file that should contain two sections,sections and pandoc. The second
  and third are through environment variables or application variables,
  both are described in the config/config.exs file.
  """


  @doc """
  Get a specific System Environment Variable or use a default value

  ## Parameters

    - key: Atom for the key mapped to the System Environment Variable

  ## Examples

    iex> Configuration.Manager.get_env(:output_file)
    'out.pdf'

  """
  def get_env(key) when is_atom(key) do
    cmd_arg = fetch_cmd_arg(key)
    sys_env = get_app_config(:envs, key)
    default = get_app_config(:defaults, key)
    cmd_arg || (try do: (System.get_env sys_env), rescue: (_ -> nil)) || default
  end

  @doc """
  Loads the YAML file from the given name through the System Environment
  Variable :config_yaml or uses its default value. Then it retrieves a
  specific section of the file.

  ## Parameters

    - section: Atom that refers to the name of the section to be retrieved

  ## Examples

    iex> System.put_env("PANDOCKER_CONFIG_YAML", "test.yml")
    iex> System.put_env("PANDOCKER_PATH",
    iex> Configuration.Manager.get_yaml_section(:sections)
    ["example.md"]

  """
  def get_yaml_section(section) when is_atom(section) do
    :config_yaml
    |> get_env
    |> load_configurations
    |> Map.get(Atom.to_charlist(section))
  end


  @doc """
  Get Pandocker configuration from the YAML or use the System Environment
  Variable or the Application Environment Variables.

  ## Parameters

    - section: Atom that refers to the name of the YAML section to be retrieved
    - key: Atom for the key in to be found the section

  ## Examples

    iex> Configuration.Manager.get_config(:pandoc, :output_file)
    'out.pdf'

  """
  def get_config(section, key) when is_atom(key) do
    try do
      Map.new(get_yaml_section(section))
      |> Map.get(Atom.to_charlist(key)) || get_env(key)
    rescue
      _ -> get_env(key)
    end
  end


  @doc """
  Get Pandocker configuration from the YAML or use the System Environment
  Variable or the Application Environment Variables. Then apply an
  anonymous function to the retrieved value

  ## Parameters

    - section: Atom that refers to the name of the YAML section to be retrieved
    - key: Atom for the key in to be found the section
    - fun: Function to apply in the value before return it

  ## Examples

    iex> Configuration.Manager.get_config(:pandoc, :output_file, &List.to_string/1)
    "out.pdf"

  """
  def get_config(section, key, fun) when is_function(fun) do
    try do
      get_config(section, key)
      |> fun.()
    rescue
      FunctionClauseError -> nil
    end
  end

  defp get_app_config(map, key, app \\ :pandocker) do
    app
    |> Application.get_env(map)
    |> Map.get(key)
  end

  defp load_configurations(path) do
    full_path = Path.join(get_env(:project_root), path)
    Map.new(hd :yamerl_constr.file(full_path))
  end

  defp fetch_cmd_arg(:cmd), do: nil   # Avoid deadlocks
  defp fetch_cmd_arg(key) do
    try do
      get_app_config(:tokens, key)
      |> Regex.named_captures(get_env(:cmd))
      |> Map.get(Atom.to_string(key))
    rescue
      _ -> nil
    end
  end
end
