defmodule ConfigManagerTest do
  use ExUnit.Case
  doctest ConfigManager

  test "retrieve default environment variables" do
    assert ConfigManager.get_env(:output_file) == \
           Application.get_env(:pandocker, :defaults)
           |> Map.get(:output_file)
  end
end
