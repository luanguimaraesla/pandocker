defmodule Pandocker do
  @moduledoc """
  Documentation for Pandocker.
  """
  def run do
    configure_flags()
    |> build_command
  end

  def build_command(flags_map) do
    fetch_sys_env()
    |> add_flags(flags_map)
    |> create_command
  end

  def create_command(flags) do
    "pandoc " <> (Enum.join(flags, " ") |> String.trim)
  end

  def fetch_sys_env do
    varnames_map = Application.get_env(:pandocker, :sys_env)
    Map.new(for {k, v} <- varnames_map, do: {k, System.get_env(v)})
  end

  defp configure_flags do
    %{
      :tof => %{default: "--tof", func: &make_bool_flag/2},
      :toc => %{default: "--toc", func: &make_bool_flag/2},
      :tot => %{default: "--tot", func: &make_bool_flag/2},
      :citeproc => %{default: "--filter pandoc-citeproc", func: &make_bool_flag/2},
      :crossref => %{default: "--filter pandoc-crossref", func: &make_bool_flag/2},
      :template_path => %{
        default: "-o out.pdf",
        func: fn path, default -> if path, do: "-o" <> path, else: default end
      }
    }
  end

  defp add_flags(env_map, flag_map) do
    for {k, v} <- flag_map do
      env_map[k] |> v[:func].(v[:default])
    end
  end

  defp make_bool_flag(is_enabled, default) do
    if is_enabled, do: default, else: ""
  end
end

