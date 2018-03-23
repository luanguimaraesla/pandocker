defmodule Pandocker do
  @moduledoc """
  Documentation for Pandocker.
  """
  
  defp load_configurations(path) do
    Map.new(hd :yamerl_constr.file(path))
  end

  def get_sections(path) do
    load_configurations(path)
    |> Map.get('sections')
  end

  def run(path \\ "pandocker.yml") do
    get_sections(path)
    |> Pandoc.compile
  end
end
