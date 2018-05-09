defmodule ConfigurationManagerTest do
  use ExUnit.Case
  doctest Configuration.Manager

  setup_all do
    System.put_env("PANDOCKER_CONFIG_YAML", "test.yml")
    System.put_env("PANDOCKER_PATH", "test")
  end

  test "retrieve yaml section" do
    assert is_list(Configuration.Manager.get_yaml_section(:pandoc))
  end
end
