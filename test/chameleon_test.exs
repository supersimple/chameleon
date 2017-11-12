defmodule ChameleonTest do
  use ExUnit.Case
  doctest Chameleon

  test "converts from rgb to hex" do
    assert "D82C45" == Chameleon.convert(Rgb, :to_hex, [216, 44, 69])
  end
end
