defmodule ChameleonTest do
  use ExUnit.Case
  doctest Chameleon
  doctest Chameleon.Rgb
  doctest Chameleon.Cmyk
  doctest Chameleon.Hex
  doctest Chameleon.Hsl
  doctest Chameleon.Keyword
  doctest Chameleon.Pantone

  test "converts from rgb to hex" do
    assert {:ok, "D82C45"} == Chameleon.convert([216, 44, 69], :rgb, :hex)
  end
end
