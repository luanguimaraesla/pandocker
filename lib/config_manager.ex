defmodule ConfigManager do
  @moduledoc """
  This module provides a simple interface to manage the Pandocker's configurations.

  Its configuration can be set in three different ways. The first is through
  a YAML file that should contain two sections,sections and pandoc. The second
  and third are through environment variables or application variables,
  both are described in the config/config.exs file.

  YAML file example:

      # the ordered list of files to be compiled
      sections:
        - introduction.md
        - methodology.md
        - conclusion.md

      # pandoc flags setup
      pandoc:
        template_path: "templates/test.latex"
        source_path:   "test/"
        output_file:   "test.pdf"
        toc:           true
        filters:
          - pandoc-crossref
          - pandoc-citeproc
  
  System Environment Variables:

    - `PANDOCKER_CONFIG_YAML`: the YAML config file (default: pandocker.yml)
    - `PANDOCKER_PATH`: your project root (default: /code)
    - `PANDOCKER_SOURCE_PATH`: dir with files to be compiled (default: src/)
    - `PANDOCKER_OUTPUT_FILE`: pandoc output file (default: out.pdf)
    - `PANDOCKER_FILES`: ordered list of files to be compiled (NotImplemented)

  """

  @doc """
  Get an application variable set in config/config.exs

  ## Parameters

    - map: Atom referring to the name of the configuration map
    - key: Atom for the key to be found in the map
    - app: Atom referring to the name of the application

  ## Examples

    iex> ConfigManager.get_app_config(:defaults, :output_file)
    'out.pdf'

  """
  def get_app_config(map, key, app \\ :pandocker) do
    app
    |> Application.get_env(map)
    |> Map.get(key)
  end

  @doc """
  Get a specific System Environment Variable or use a default value

  ## Parameters

    - key: Atom for the key mapped to the System Environment Variable

        List of enabled atoms:
        :config_yaml  ->  PANDOCKER_CONFIG_YAML
        :project_root ->  PANDOCKER_PATH
        :source_path  ->  PANDOCKER_SOURCE_PATH
        :output_file  ->  PANDOCKER_OUTPUT_FILE
        :files        ->  PANDOCKER_FILES

  ## Examples

    iex> ConfigManager.get_env(:output_file)
    'out.pdf'

  """
  def get_env(key) when is_atom(key) do
    default = get_app_config(:defaults, key)
    sys_env = get_app_config(:envs, key)

    case {sys_env, default} do
      {nil, nil} -> nil
      {nil, _ } -> default
      _ -> System.get_env(sys_env) || default
    end
  end

  @doc """
  Loads the YAML file from the given name through the System Environment
  Variable :config_yaml or uses its default value. Then it retrieves a
  specific section of the file.

  ## Parameters

    - section: Atom that refers to the name of the section to be retrieved

  ## Examples

    iex> System.put_env("PANDOCKER_CONFIG_YAML", "test.yml")
    iex> ConfigManager.get_yaml_section(:sections)
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

    iex> ConfigManager.get_config(:pandoc, :output_file)
    'out.pdf'

  """
  def get_config(section, key) when is_atom(key) do
    try do
      Map.new(ConfigManager.get_yaml_section(section))
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

    iex> ConfigManager.get_config(:pandoc, :output_file, &List.to_string/1)
    "out.pdf"

  """
  def get_config(section, key, fun) when is_function(fun) do
    get_config(section, key)
    |> fun.()
  end

  defp load_configurations(path) do
    # Creates a map of settings from a YAML file
    #
    # Parameters:
    #   - path: yaml file path

    Map.new(hd :yamerl_constr.file(path))
  end
end
