defmodule ElixirTodoxTest do
  use ExUnit.Case
  doctest ElixirTodox

  test "greets the world" do
    assert ElixirTodox.hello() == :world
  end
end
