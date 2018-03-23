defmodule Pandoc do
  @moduledoc """
  Documentation for Pandoc.
  """

  def compile(files) do
    IO.puts(files)
    configure_flags()
    |> build_flags()
    |> build_command(files)
  end

  defp build_command(flags, files) do
    "pandoc"
    |> add_args(flags)
    |> add_args(files)
  end

  defp add_args(command, args) do
    command <> " " <> Enum.join(args, " ") |> String.trim
  end

  defp fetch_sys_env do
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
      },
    }
  end

  defp build_flags(flag_map) do
    env_map = fetch_sys_env()
    for {k, v} <- flag_map do
      env_map[k] |> v[:func].(v[:default])
    end
  end

  defp make_bool_flag(is_enabled, default) do
    if is_enabled, do: default, else: ""
  end
end

