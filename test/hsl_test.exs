defmodule HSLTest do
  use ExUnit.Case
  use ChameleonTest.Case

  alias Chameleon.{CMYK, Hex, HSL, HSV, Keyword, Pantone, RGB}

  doctest Chameleon.HSL

  describe "RGB and HSL conversions" do
    test "converts from RGB to HSL" do
      for %{rgb: [r, g, b], hsl: [h, s, l]} <- color_table() do
        assert HSL.new(h, s, l) == Chameleon.convert(RGB.new(r, g, b), HSL)
      end
    end

    test "converts from HSL to RGB" do
      for %{rgb: [r, g, b], hsl: [h, s, l]} <- color_table() do
        assert RGB.new(r, g, b) == Chameleon.convert(HSL.new(h, s, l), RGB)
      end
    end
  end

  describe "CMYK and HSL conversions" do
    test "converts from CMYK to HSL" do
      for %{cmyk: [c, m, y, k], hsl: [h, s, l]} <- color_table() do
        assert HSL.new(h, s, l) == Chameleon.convert(CMYK.new(c, m, y, k), HSL)
      end
    end

    test "converts from HSL to CMYK" do
      for %{cmyk: [c, m, y, k], hsl: [h, s, l]} <- color_table() do
        assert CMYK.new(c, m, y, k) == Chameleon.convert(HSL.new(h, s, l), CMYK)
      end
    end
  end

  describe "Hex and HSL conversions" do
    test "converts from Hex to HSL" do
      for %{hex: hex, hsl: [h, s, l]} <- color_table() do
        assert HSL.new(h, s, l) == Chameleon.convert(Hex.new(hex), HSL)
      end
    end

    test "converts from HSL to Hex" do
      for %{hex: hex, hsl: [h, s, l]} <- color_table() do
        assert Hex.new(hex) == Chameleon.convert(HSL.new(h, s, l), Hex)
      end
    end
  end

  describe "HSV and HSL conversions" do
    test "converts from HSV to CMYK" do
      for %{hsv: [h, s, v], hsl: [h, s, l]} <- color_table() do
        assert HSL.new(h, s, l) == Chameleon.convert(HSV.new(h, s, v), HSL)
      end
    end

    test "converts from HSL to HSV" do
      for %{hsv: [h, s, v], hsl: [h, s, l]} <- color_table() do
        assert HSV.new(h, s, v) == Chameleon.convert(HSL.new(h, s, l), HSV)
      end
    end
  end

  describe "Keyword and HSL conversions" do
    test "converts from Keyword to HSL" do
      for %{keyword: keyword, hsl: [h, s, l]} <- color_table() do
        assert HSL.new(h, s, l) == Chameleon.convert(Keyword.new(keyword), HSL)
      end
    end

    test "converts from HSL to Keyword" do
      for %{keyword: keyword, hsl: [h, s, l]} <- color_table() do
        assert Keyword.new(keyword) == Chameleon.convert(HSL.new(h, s, l), Keyword)
      end
    end
  end

  describe "Pantone and HSL conversions" do
    test "converts from Pantone to HSL" do
      for %{pantone: pantone, hsl: [h, s, l]} <- color_table(), not is_nil(pantone) do
        assert HSL.new(h, s, l) == Chameleon.convert(Pantone.new(pantone), HSL)
      end
    end

    test "converts from HSL to Pantone" do
      for %{pantone: pantone, hsl: [h, s, l]} <- color_table(), not is_nil(pantone) do
        assert Pantone.new(pantone) == Chameleon.convert(HSL.new(h, s, l), Pantone)
      end
    end
  end
end
