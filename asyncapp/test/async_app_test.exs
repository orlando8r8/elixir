defmodule AsyncAppTest do
  use ExUnit.Case
  doctest AsyncApp

  test "greets the world" do
    assert AsyncApp.hello() == :world
  end
end
