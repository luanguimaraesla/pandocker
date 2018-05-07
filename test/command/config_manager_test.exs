defmodule Configuration.Manager do
  use ExUnit.Case
  doctest Configuration.Manager

  test "retrieve default environment variables" do
    assert ConfigManager.get_env(:output_file) == \
           Application.get_env(:pandocker, :defaults)
           |> Map.get(:output_file)
  end
end
