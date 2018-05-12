defmodule ChameleonTest do
  use ExUnit.Case
  doctest Chameleon
  doctest Chameleon.Color
  doctest Chameleon.Converter
  doctest Chameleon.Rgb
  doctest Chameleon.Cmyk
  doctest Chameleon.Hex
  doctest Chameleon.Hsl
  doctest Chameleon.Keyword
  doctest Chameleon.Pantone

  test "converts from rgb to hex" do
    assert %Chameleon.Hex{hex: "D82C45"} ==
             Chameleon.Converter.convert(%Chameleon.Rgb{r: 216, g: 44, b: 69}, :hex)
  end

  test "converts from rgb to cmyk" do
    assert %Chameleon.Cmyk{c: 0, m: 80, y: 68, k: 15} ==
             Chameleon.Converter.convert(%Chameleon.Rgb{r: 216, g: 44, b: 69}, :cmyk)
  end

  test "converts from rgb to hsl" do
    assert %Chameleon.Hsl{h: 351, s: 69, l: 51} ==
             Chameleon.Converter.convert(%Chameleon.Rgb{r: 216, g: 44, b: 69}, :hsl)
  end

  test "converts from rgb to keyword" do
    assert %Chameleon.Keyword{keyword: "bisque"} ==
             Chameleon.Converter.convert(%Chameleon.Rgb{r: 255, g: 228, b: 196}, :keyword)
  end

  test "converts from rgb to pantone" do
    assert %Chameleon.Pantone{pantone: "30"} ==
             Chameleon.Converter.convert(%Chameleon.Rgb{r: 0, g: 0, b: 0}, :pantone)
  end

  test "converts from keyword to rgb" do
    assert %Chameleon.Rgb{r: 255, g: 0, b: 0} ==
             Chameleon.Converter.convert(%Chameleon.Keyword{keyword: "red"}, :rgb)
  end

  test "converts from hex to pantone" do
    assert %Chameleon.Pantone{pantone: "30"} ==
             Chameleon.Converter.convert(%Chameleon.Hex{hex: "000000"}, :pantone)

    assert %Chameleon.Pantone{pantone: "30"} ==
             Chameleon.Converter.convert(%Chameleon.Hex{hex: "000"}, :pantone)
  end
end
