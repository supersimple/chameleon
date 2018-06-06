defmodule RGBTest do
  use ExUnit.Case
  use ChameleonTest.Case

  alias Chameleon.{CMYK, Hex, HSL, HSV, Keyword, Pantone, RGB}

  doctest Chameleon.RGB

  describe "Pantone and RGB conversions" do
    test "converts from Pantone to RGB" do
      for %{rgb: [r, g, b], pantone: pantone} <- color_table(), not is_nil(pantone) do
        assert RGB.new(r, g, b) == Chameleon.convert(Pantone.new(pantone), RGB)
      end
    end

    test "converts from RGB to RGB" do
      for %{rgb: [r, g, b], pantone: pantone} <- color_table(), not is_nil(pantone) do
        assert Pantone.new(pantone) == Chameleon.convert(RGB.new(r, g, b), Pantone)
      end
    end
  end

  describe "CMYK and RGB conversions" do
    test "converts from CMYK to RGB" do
      for %{cmyk: [c, m, y, k], rgb: [r, g, b]} <- color_table() do
        assert RGB.new(r, g, b) == Chameleon.convert(CMYK.new(c, m, y, k), RGB)
      end
    end

    test "converts from RGB to CMYK" do
      for %{cmyk: [c, m, y, k], rgb: [r, g, b]} <- color_table() do
        assert CMYK.new(c, m, y, k) == Chameleon.convert(RGB.new(r, g, b), CMYK)
      end
    end
  end

  describe "Hex and RGB conversions" do
    test "converts from Hex to RGB" do
      for %{hex: hex, rgb: [r, g, b]} <- color_table() do
        assert RGB.new(r, g, b) == Chameleon.convert(Hex.new(hex), RGB)
      end
    end

    test "converts from RGB to Hex" do
      for %{hex: hex, rgb: [r, g, b]} <- color_table() do
        assert Hex.new(hex) == Chameleon.convert(RGB.new(r, g, b), Hex)
      end
    end
  end

  describe "HSV and RGB conversions" do
    test "converts from HSV to RGB" do
      for %{hsv: [h, s, v], rgb: [r, g, b]} <- color_table() do
        assert RGB.new(r, g, b) == Chameleon.convert(HSV.new(h, s, v), RGB)
      end
    end

    test "converts from RGB to HSV" do
      for %{hsv: [h, s, v], rgb: [r, g, b]} <- color_table() do
        assert HSV.new(h, s, v) == Chameleon.convert(RGB.new(r, g, b), HSV)
      end
    end
  end

  describe "HSL and RGB conversions" do
    test "converts from HSL to RGB" do
      for %{hsl: [h, s, l], rgb: [r, g, b]} <- color_table() do
        assert RGB.new(r, g, b) == Chameleon.convert(HSL.new(h, s, l), RGB)
      end
    end

    test "converts from RGB to RGB" do
      for %{hsl: [h, s, l], rgb: [r, g, b]} <- color_table() do
        assert HSL.new(h, s, l) == Chameleon.convert(RGB.new(r, g, b), HSL)
      end
    end
  end

  describe "Keyword and RGB conversions" do
    test "converts from Keyword to RGB" do
      for %{keyword: keyword, rgb: [r, g, b]} <- color_table() do
        assert RGB.new(r, g, b) == Chameleon.convert(Keyword.new(keyword), RGB)
      end
    end

    test "converts from RGB to Keyword" do
      for %{keyword: keyword, rgb: [r, g, b]} <- color_table() do
        assert Keyword.new(keyword) == Chameleon.convert(RGB.new(r, g, b), Keyword)
      end
    end
  end

  test "recognizes strings as inputs" do
    assert RGB.new(255, 0, 0) == Chameleon.convert("red", RGB)
  end

  describe "allows RGB8 and RGB888 aliases" do
    test "converts from Hex to RGB8" do
      for %{hex: hex, rgb: [r, g, b]} <- color_table() do
        assert RGB8.new(r, g, b) == Chameleon.convert(Hex.new(hex), RGB8)
      end
    end

    test "converts from RGB8 to Hex" do
      for %{hex: hex, rgb: [r, g, b]} <- color_table() do
        assert Hex.new(hex) == Chameleon.convert(RGB8.new(r, g, b), Hex)
      end
    end

    test "converts from Hex to RGB888" do
      for %{hex: hex, rgb: [r, g, b]} <- color_table() do
        assert RGB888.new(r, g, b) == Chameleon.convert(Hex.new(hex), RGB888)
      end
    end

    test "converts from RGB888 to Hex" do
      for %{hex: hex, rgb: [r, g, b]} <- color_table() do
        assert Hex.new(hex) == Chameleon.convert(RGB888.new(r, g, b), Hex)
      end
    end
  end
end
