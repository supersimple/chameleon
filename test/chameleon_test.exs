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
  test "converts from keyword to rgb" do
    assert {:ok, %{r: 255, g: 0, b: 0}} == Chameleon.convert("red", :keyword, :rgb)
  end
  test "converts from hex to pantone" do
    assert {:ok, "30"} == Chameleon.convert("000000", :hex, :pantone)
    assert {:ok, "30"} == Chameleon.convert("000", :hex, :pantone)
  end
end
