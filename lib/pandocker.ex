defmodule Pandocker do
  @moduledoc """
  Documentation for Pandocker.
  """

  def run do
    ConfigManager.get_section('sections')
    |> Pandoc.compile
  end
end
