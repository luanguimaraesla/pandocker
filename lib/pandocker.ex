defmodule Pandocker do
  @moduledoc """
  Documentation for Pandocker.
  """
  use Application

  def run do
    ConfigManager.get_section('sections')
    |> Pandoc.compile
  end

  def start(_, _) do
    run()
  end
end
