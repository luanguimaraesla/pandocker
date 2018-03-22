defmodule PandockerTest do
  use ExUnit.Case
  doctest Pandocker

  test "greets the world" do
    assert Pandocker.hello() == :world
  end
end
