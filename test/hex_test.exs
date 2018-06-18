defmodule HexTest do
  use ExUnit.Case
  use ChameleonTest.Case

  alias Chameleon.{Color, CMYK, Hex, HSL, HSV, Keyword, Pantone, RGB}

  doctest Chameleon.Hex

  test "recognizes strings as inputs" do
    assert Hex.new("000000") == Chameleon.convert("30", Color.Hex)
  end

  describe "RGB and Hex conversions" do
    test "converts from RGB to Hex" do
      for %{rgb: [r, g, b], hex: hex} <- color_table() do
        assert Hex.new(hex) == Chameleon.convert(RGB.new(r, g, b), Color.Hex)
      end
    end

    test "converts from Hex to RGB" do
      for %{rgb: [r, g, b], hex: hex} <- color_table() do
        assert RGB.new(r, g, b) == Chameleon.convert(Hex.new(hex), Color.RGB)
      end
    end
  end

  describe "CMYK and Hex conversions" do
    test "converts from CMYK to Hex" do
      for %{cmyk: [c, m, y, k], hex: hex} <- color_table() do
        assert Hex.new(hex) == Chameleon.convert(CMYK.new(c, m, y, k), Color.Hex)
      end
    end

    test "converts from Hex to CMYK" do
      for %{cmyk: [c, m, y, k], hex: hex} <- color_table() do
        assert CMYK.new(c, m, y, k) == Chameleon.convert(Hex.new(hex), Color.CMYK)
      end
    end
  end

  describe "HSL and Hex conversions" do
    test "converts from HSL to Hex" do
      for %{hsl: [h, s, l], hex: hex} <- color_table() do
        assert Hex.new(hex) == Chameleon.convert(HSL.new(h, s, l), Color.Hex)
      end
    end

    test "converts from Hex to HSL" do
      for %{hsl: [h, s, l], hex: hex} <- color_table() do
        assert HSL.new(h, s, l) == Chameleon.convert(Hex.new(hex), Color.HSL)
      end
    end
  end

  describe "HSV and Hex conversions" do
    test "converts from HSV to CMYK" do
      for %{hsv: [h, s, v], hex: hex} <- color_table() do
        assert Hex.new(hex) == Chameleon.convert(HSV.new(h, s, v), Color.Hex)
      end
    end

    test "converts from Hex to HSV" do
      for %{hsv: [h, s, v], hex: hex} <- color_table() do
        assert HSV.new(h, s, v) == Chameleon.convert(Hex.new(hex), Color.HSV)
      end
    end
  end

  describe "Keyword and Hex conversions" do
    test "converts from Keyword to Hex" do
      for %{keyword: keyword, hex: hex} <- color_table() do
        assert Hex.new(hex) == Chameleon.convert(Keyword.new(keyword), Color.Hex)
      end
    end

    test "converts from Hex to Keyword" do
      for %{keyword: keyword, hex: hex} <- color_table() do
        assert Keyword.new(keyword) == Chameleon.convert(Hex.new(hex), Color.Keyword)
      end
    end
  end

  describe "Pantone and Hex conversions" do
    test "converts from Pantone to Hex" do
      for %{pantone: pantone, hex: hex} <- color_table(), not is_nil(pantone) do
        assert Hex.new(hex) == Chameleon.convert(Pantone.new(pantone), Color.Hex)
      end
    end

    test "converts from CMYK to Pantone" do
      for %{pantone: pantone, hex: hex} <- color_table(), not is_nil(pantone) do
        assert Pantone.new(pantone) == Chameleon.convert(Hex.new(hex), Color.Pantone)
      end
    end
  end
end
