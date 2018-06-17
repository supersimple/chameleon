defmodule RGBTest do
  use ExUnit.Case
  use ChameleonTest.Case

  alias Chameleon.{Color, CMYK, Hex, HSL, HSV, Keyword, Pantone, RGB}

  doctest Chameleon.RGB

  describe "Pantone and RGB conversions" do
    test "converts from Pantone to RGB" do
      for %{rgb: [r, g, b], pantone: pantone} <- color_table(), not is_nil(pantone) do
        assert RGB.new(r, g, b) == Chameleon.convert(Pantone.new(pantone), Color.RGB)
      end
    end

    test "converts from RGB to RGB" do
      for %{rgb: [r, g, b], pantone: pantone} <- color_table(), not is_nil(pantone) do
        assert Pantone.new(pantone) == Chameleon.convert(RGB.new(r, g, b), Color.Pantone)
      end
    end
  end

  describe "CMYK and RGB conversions" do
    test "converts from CMYK to RGB" do
      for %{cmyk: [c, m, y, k], rgb: [r, g, b]} <- color_table() do
        assert RGB.new(r, g, b) == Chameleon.convert(CMYK.new(c, m, y, k), Color.RGB)
      end
    end

    test "converts from RGB to CMYK" do
      for %{cmyk: [c, m, y, k], rgb: [r, g, b]} <- color_table() do
        assert CMYK.new(c, m, y, k) == Chameleon.convert(RGB.new(r, g, b), Color.CMYK)
      end
    end
  end

  describe "Hex and RGB conversions" do
    test "converts from Hex to RGB" do
      for %{hex: hex, rgb: [r, g, b]} <- color_table() do
        assert RGB.new(r, g, b) == Chameleon.convert(Hex.new(hex), Color.RGB)
      end
    end

    test "converts from RGB to Hex" do
      for %{hex: hex, rgb: [r, g, b]} <- color_table() do
        assert Hex.new(hex) == Chameleon.convert(RGB.new(r, g, b), Color.Hex)
      end
    end
  end

  describe "HSV and RGB conversions" do
    test "converts from HSV to RGB" do
      for %{hsv: [h, s, v], rgb: [r, g, b]} <- color_table() do
        assert RGB.new(r, g, b) == Chameleon.convert(HSV.new(h, s, v), Color.RGB)
      end
    end

    test "converts from RGB to HSV" do
      for %{hsv: [h, s, v], rgb: [r, g, b]} <- color_table() do
        assert HSV.new(h, s, v) == Chameleon.convert(RGB.new(r, g, b), Color.HSV)
      end
    end
  end

  describe "HSL and RGB conversions" do
    test "converts from HSL to RGB" do
      for %{hsl: [h, s, l], rgb: [r, g, b]} <- color_table() do
        assert RGB.new(r, g, b) == Chameleon.convert(HSL.new(h, s, l), Color.RGB)
      end
    end

    test "converts from RGB to RGB" do
      for %{hsl: [h, s, l], rgb: [r, g, b]} <- color_table() do
        assert HSL.new(h, s, l) == Chameleon.convert(RGB.new(r, g, b), Color.HSL)
      end
    end
  end

  describe "Keyword and RGB conversions" do
    test "converts from Keyword to RGB" do
      for %{keyword: keyword, rgb: [r, g, b]} <- color_table() do
        assert RGB.new(r, g, b) == Chameleon.convert(Keyword.new(keyword), Color.RGB)
      end
    end

    test "converts from RGB to Keyword" do
      for %{keyword: keyword, rgb: [r, g, b]} <- color_table() do
        assert Keyword.new(keyword) == Chameleon.convert(RGB.new(r, g, b), Color.Keyword)
      end
    end
  end

  test "recognizes strings as inputs" do
    assert RGB.new(255, 0, 0) == Chameleon.convert("red", Color.RGB)
  end

  test "supports legacy API" do
    for %{keyword: keyword, rgb: [r, g, b]} <- color_table() do
      assert Keyword.new(keyword) == Chameleon.convert(RGB.new(r, g, b), Keyword)
    end
  end
end
