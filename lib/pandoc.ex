defmodule Pandoc do
  @moduledoc """
  This module provides a simple interface to build and execute a complex
  pandoc command line according to the pandocker configurations.

  Functions:

    - `compile/1`: compiles a list of files
  """


  @doc """
  Compiles an ordered list of files according to pandocker configuration
  environment: YAML file > System Environment Variables > config.exs defaults

  ## Parameters

    - files: List of Strings with the file names to be compiled

  ## Examples

    iex> Pandoc.compile(["test.md])
    :ok

  """
  def compile(files) do
    configure_flags()
    |> build_flags()
    |> build_command(files)
    |> Executor.dispatch
  end

  defp build_command(flags, files) do
    "pandoc"
    |> add_args(flags)
    |> add_args(custom_flags())
    |> add_args(files)
  end

  defp add_args(command, nil), do: command
  defp add_args(command, args) when is_binary(args), do: "#{command} #{args}"
  defp add_args(command, args) when is_list(args) do
    command <> " " <> (Enum.join(args, " ") |> String.trim)
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

  defp custom_flags do
    ConfigManager.get_config(:pandoc, :custom_flags, &List.to_string/1)
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
