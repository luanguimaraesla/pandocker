defmodule Pandoc do
  @moduledoc """
  Documentation for Pandoc.
  """

  def compile(files) do
    configure_flags()
    |> build_flags()
    |> build_command(files)
    |> Executor.execute
  end

  defp build_command(flags, files) do
    "pandoc"
    |> add_args(flags)
    |> add_args(files)
  end

  defp add_args(command, args) do
    command <> " " <> Enum.join(args, " ") |> String.trim
  end

  defp configure_flags do
    %{
      toc: %{token: "--toc", func: &make_flag/2},
      filters: %{token: "--filter", func: &make_some_flags/2},
      output_file: %{token: "-o", func: &make_flag/2},
      template_file: %{token: "--template", func: &make_flag/2},
    }
  end

  defp build_flags(flag_map) do
    for {k, v} <- flag_map do
      ConfigManager.get_config(:pandoc, k) |> v[:func].(v[:token])
    end
  end

  defp make_some_flags(values, option) do
    flags = for v <- values, do: make_flag(v, option)
    Enum.join(flags, " ")
  end

  defp make_flag(value, option) do
    case {value, option} do
      {true,_} -> option
      {false,_} -> ""
      {nil,_} -> ""
      {"", _} -> ""
      {[], _} -> ""
      _ -> option <> " " <> List.to_string(value)
    end
  end
end
