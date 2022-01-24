defmodule HSLTest do
  use ExUnit.Case
  use ChameleonTest.Case

  alias Chameleon.{Color, CMYK, Hex, HSL, HSV, Keyword, Pantone, RGB}

  doctest Chameleon.HSL

  describe "RGB and HSL conversions" do
    test "converts from RGB to HSL" do
      for %{rgb: [r, g, b], hsl: [h, s, l]} <- color_table() do
        assert HSL.new(h, s, l) == Chameleon.convert(RGB.new(r, g, b), Color.HSL)
      end
    end

    test "verifies RGB to HSL conversions" do
      assert HSL.new(99, 91, 57) == Chameleon.convert(RGB.new(115, 245, 46), Color.HSL)
      assert HSL.new(100, 32, 64) == Chameleon.convert(RGB.new(154, 193, 134), Color.HSL)
      assert HSL.new(255, 32, 64) == Chameleon.convert(RGB.new(149, 134, 193), Color.HSL)
    end

    test "converts from HSL to RGB" do
      for %{rgb: [r, g, b], hsl: [h, s, l]} <- color_table() do
        assert RGB.new(r, g, b) == Chameleon.convert(HSL.new(h, s, l), Color.RGB)
      end
    end
  end

  describe "CMYK and HSL conversions" do
    test "converts from CMYK to HSL" do
      for %{cmyk: [c, m, y, k], hsl: [h, s, l]} <- color_table() do
        assert HSL.new(h, s, l) == Chameleon.convert(CMYK.new(c, m, y, k), Color.HSL)
      end
    end

    test "converts from HSL to CMYK" do
      for %{cmyk: [c, m, y, k], hsl: [h, s, l]} <- color_table() do
        assert CMYK.new(c, m, y, k) == Chameleon.convert(HSL.new(h, s, l), Color.CMYK)
      end
    end
  end

  describe "Hex and HSL conversions" do
    test "converts from Hex to HSL" do
      for %{hex: hex, hsl: [h, s, l]} <- color_table() do
        assert HSL.new(h, s, l) == Chameleon.convert(Hex.new(hex), Color.HSL)
      end
    end

    test "converts from HSL to Hex" do
      for %{hex: hex, hsl: [h, s, l]} <- color_table() do
        assert Hex.new(hex) == Chameleon.convert(HSL.new(h, s, l), Color.Hex)
      end
    end
  end

  describe "HSV and HSL conversions" do
    test "converts from HSV to CMYK" do
      for %{hsv: [h, s, v], hsl: [h, s, l]} <- color_table() do
        assert HSL.new(h, s, l) == Chameleon.convert(HSV.new(h, s, v), Color.HSL)
      end
    end

    test "converts from HSL to HSV" do
      for %{hsv: [h, s, v], hsl: [h, s, l]} <- color_table() do
        assert HSV.new(h, s, v) == Chameleon.convert(HSL.new(h, s, l), Color.HSV)
      end
    end
  end

  describe "Keyword and HSL conversions" do
    test "converts from Keyword to HSL" do
      for %{keyword: keyword, hsl: [h, s, l]} <- color_table() do
        assert HSL.new(h, s, l) == Chameleon.convert(Keyword.new(keyword), Color.HSL)
      end
    end

    test "converts from HSL to Keyword" do
      for %{keyword: keyword, hsl: [h, s, l]} <- color_table() do
        assert Keyword.new(keyword) == Chameleon.convert(HSL.new(h, s, l), Color.Keyword)
      end
    end
  end

  describe "Pantone and HSL conversions" do
    test "converts from Pantone to HSL" do
      for %{pantone: pantone, hsl: [h, s, l]} <- color_table(), not is_nil(pantone) do
        assert HSL.new(h, s, l) == Chameleon.convert(Pantone.new(pantone), Color.HSL)
      end
    end

    test "converts from HSL to Pantone" do
      for %{pantone: pantone, hsl: [h, s, l]} <- color_table(), not is_nil(pantone) do
        assert Pantone.new(pantone) == Chameleon.convert(HSL.new(h, s, l), Color.Pantone)
      end
    end
  end
end
