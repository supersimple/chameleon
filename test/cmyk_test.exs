defmodule CMYKTest do
  use ExUnit.Case
  use ChameleonTest.Case

  alias Chameleon.{CMYK, Hex, HSL, HSV, Keyword, Pantone, RGB}

  doctest Chameleon.CMYK

  describe "RGB and CMYK conversions" do
    test "converts from RGB to CMYK" do
      for %{rgb: [r, g, b], cmyk: [c, m, y, k]} <- color_table() do
        assert CMYK.new(c, m, y, k) == Chameleon.convert(RGB.new(r, g, b), CMYK)
      end
    end

    test "converts from CMYK to RGB" do
      for %{rgb: [r, g, b], cmyk: [c, m, y, k]} <- color_table() do
        assert RGB.new(r, g, b) == Chameleon.convert(CMYK.new(c, m, y, k), RGB)
      end
    end
  end

  describe "Hex and CMYK conversions" do
    test "converts from HEX to CMYK" do
      for %{hex: hex, cmyk: [c, m, y, k]} <- color_table() do
        assert CMYK.new(c, m, y, k) == Chameleon.convert(Hex.new(hex), CMYK)
      end
    end

    test "converts from CMYK to HEX" do
      for %{hex: hex, cmyk: [c, m, y, k]} <- color_table() do
        assert Hex.new(hex) == Chameleon.convert(CMYK.new(c, m, y, k), Hex)
      end
    end
  end

  describe "HSL and CMYK conversions" do
    test "converts from HSL to CMYK" do
      for %{hsl: [h, s, l], cmyk: [c, m, y, k]} <- color_table() do
        assert CMYK.new(c, m, y, k) == Chameleon.convert(HSL.new(h, s, l), CMYK)
      end
    end

    test "converts from CMYK to HSL" do
      for %{hsl: [h, s, l], cmyk: [c, m, y, k]} <- color_table() do
        assert HSL.new(h, s, l) == Chameleon.convert(CMYK.new(c, m, y, k), HSL)
      end
    end
  end

  describe "HSV and CMYK conversions" do
    test "converts from HSV to CMYK" do
      for %{hsv: [h, s, v], cmyk: [c, m, y, k]} <- color_table() do
        assert CMYK.new(c, m, y, k) == Chameleon.convert(HSV.new(h, s, v), CMYK)
      end
    end

    test "converts from CMYK to HSV" do
      for %{hsv: [h, s, v], cmyk: [c, m, y, k]} <- color_table() do
        assert HSV.new(h, s, v) == Chameleon.convert(CMYK.new(c, m, y, k), HSV)
      end
    end
  end

  describe "Keyword and CMYK conversions" do
    test "converts from Keyword to CMYK" do
      for %{keyword: keyword, cmyk: [c, m, y, k]} <- color_table() do
        assert CMYK.new(c, m, y, k) == Chameleon.convert(Keyword.new(keyword), CMYK)
      end
    end

    test "converts from CMYK to Keyword" do
      for %{keyword: keyword, cmyk: [c, m, y, k]} <- color_table() do
        assert Keyword.new(keyword) == Chameleon.convert(CMYK.new(c, m, y, k), Keyword)
      end
    end
  end

  describe "Pantone and CMYK conversions" do
    test "converts from Pantone to CMYK" do
      for %{pantone: pantone, cmyk: [c, m, y, k]} <- color_table(), not is_nil(pantone) do
        assert CMYK.new(c, m, y, k) == Chameleon.convert(Pantone.new(pantone), CMYK)
      end
    end

    test "converts from CMYK to Pantone" do
      for %{pantone: pantone, cmyk: [c, m, y, k]} <- color_table(), not is_nil(pantone) do
        assert Pantone.new(pantone) == Chameleon.convert(CMYK.new(c, m, y, k), Pantone)
      end
    end
  end
end
