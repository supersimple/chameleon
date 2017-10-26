defmodule ChameleonTest do
  use ExUnit.Case
  doctest Chameleon

  test "greets the world" do
    assert Chameleon.hello() == :world
  end
end
