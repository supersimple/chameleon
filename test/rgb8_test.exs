defmodule RGB8Test do
  use ExUnit.Case
  use ChameleonTest.Case

  alias Chameleon.{Color, Hex, HSL, HSV, Keyword, Pantone, RGB, RGB8}

  doctest Chameleon.RGB8

  describe "RGB and RGB8 conversions" do
    test "converts from RGB to RGB8" do
      for %{rgb: [r, g, b]} <- color_table() do
        assert RGB8.new(r, g, b) == Chameleon.convert(RGB.new(r, g, b), Color.RGB8)
      end
    end

    test "converts from RGB8 to RGB" do
      for %{rgb: [r, g, b]} <- color_table() do
        assert RGB.new(r, g, b) == Chameleon.convert(RGB8.new(r, g, b), Color.RGB)
      end
    end
  end

  describe "Hex and RGB8 conversions" do
    test "converts from HEX to RGB8" do
      for %{hex: hex, rgb: [r, g, b]} <- color_table() do
        assert RGB8.new(r, g, b) == Chameleon.convert(Hex.new(hex), Color.RGB8)
      end
    end

    test "converts from RGB8 to HEX" do
      for %{hex: hex, rgb: [r, g, b]} <- color_table() do
        assert Hex.new(hex) == Chameleon.convert(RGB8.new(r, g, b), Color.Hex)
      end
    end
  end

  describe "HSL and RGB8 conversions" do
    test "converts from HSL to RGB8" do
      for %{hsl: [h, s, l], rgb: [r, g, b]} <- color_table() do
        assert RGB8.new(r, g, b) == Chameleon.convert(HSL.new(h, s, l), Color.RGB8)
      end
    end

    test "converts from CMYK to HSL" do
      for %{hsl: [h, s, l], rgb: [r, g, b]} <- color_table() do
        assert HSL.new(h, s, l) == Chameleon.convert(RGB8.new(r, g, b), Color.HSL)
      end
    end
  end

  describe "HSV and RGB8 conversions" do
    test "converts from HSV to RGB8" do
      for %{hsv: [h, s, v], rgb: [r, g, b]} <- color_table() do
        assert RGB8.new(r, g, b) == Chameleon.convert(HSV.new(h, s, v), Color.RGB8)
      end
    end

    test "converts from RGB8 to HSV" do
      for %{hsv: [h, s, v], rgb: [r, g, b]} <- color_table() do
        assert HSV.new(h, s, v) == Chameleon.convert(RGB8.new(r, g, b), Color.HSV)
      end
    end
  end

  describe "Keyword and RGB8 conversions" do
    test "converts from Keyword to RGB8" do
      for %{keyword: keyword, rgb: [r, g, b]} <- color_table() do
        assert RGB8.new(r, g, b) == Chameleon.convert(Keyword.new(keyword), Color.RGB8)
      end
    end

    test "converts from CMYK to Keyword" do
      for %{keyword: keyword,  rgb: [r, g, b]} <- color_table() do
        assert Keyword.new(keyword) == Chameleon.convert(RGB8.new(r, g, b), Color.Keyword)
      end
    end
  end

  describe "Pantone and CMYK conversions" do
    test "converts from Pantone to CMYK" do
      for %{pantone: pantone,  rgb: [r, g, b]} <- color_table(), not is_nil(pantone) do
        assert RGB8.new(r, g, b) == Chameleon.convert(Pantone.new(pantone), Color.RGB8)
      end
    end

    test "converts from CMYK to Pantone" do
      for %{pantone: pantone,  rgb: [r, g, b]} <- color_table(), not is_nil(pantone) do
        assert Pantone.new(pantone) == Chameleon.convert(RGB8.new(r, g, b), Color.Pantone)
      end
    end
  end
end
