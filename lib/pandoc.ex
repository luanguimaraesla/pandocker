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
      lof: %{token: "--lof", func: &make_flag/2},
      lot: %{token: "--lot", func: &make_flag/2},
      filters: %{token: "--filter", func: &make_some_flags/2},
      output: %{token: ["-o", "out.pdf"], func: &make_flag/2},
      template_path: %{token: ["--template", nil], func: &make_flag/2},
    }
  end

  defp build_flags(flag_map) do
    env_map = Map.new(ConfigManager.get_section('pandoc'))
    for {k, v} <- flag_map do
      env_map[Atom.to_charlist(k)] |> v[:func].(v[:token])
    end
  end

  defp make_some_flags(values, option) do
    flags = for v <- values, do: make_flag(v, [option, nil])
    Enum.join(flags, " ")
  end

  defp make_flag(nil, option) when not is_list(option), do: ""
  defp make_flag(false, _), do: ""
  defp make_flag(true, option), do: option
  defp make_flag(value, [option, default]) do
    case {value, option, default} do
      {nil,_, nil} -> ""
      {"", _, nil} -> ""
      {[], _, nil} -> ""
      {nil,_, _} -> option <> " " <> default
      {"", _, _} -> option <> " " <> default
      {[], _, _} -> option <> " " <> default
      _ -> option <> " " <> List.to_string(value)
    end
  end
end
