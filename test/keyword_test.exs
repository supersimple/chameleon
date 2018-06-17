defmodule KeywordTest do
  use ExUnit.Case
  use ChameleonTest.Case

  alias Chameleon.{Color, CMYK, Hex, HSL, HSV, Keyword, Pantone, RGB}

  doctest Chameleon.Keyword

  describe "RGB and Keyword conversions" do
    test "converts from RGB to Keyword" do
      for %{rgb: [r, g, b], keyword: keyword} <- color_table() do
        assert Keyword.new(keyword) == Chameleon.convert(RGB.new(r, g, b), Color.Keyword)
      end
    end

    test "converts from Keyword to RGB" do
      for %{rgb: [r, g, b], keyword: keyword} <- color_table() do
        assert RGB.new(r, g, b) == Chameleon.convert(Keyword.new(keyword), Color.RGB)
      end
    end
  end

  describe "CMYK and Keyword conversions" do
    test "converts from CMYK to Keyword" do
      for %{cmyk: [c, m, y, k], keyword: keyword} <- color_table() do
        assert Keyword.new(keyword) == Chameleon.convert(CMYK.new(c, m, y, k), Color.Keyword)
      end
    end

    test "converts from Keyword to CMYK" do
      for %{cmyk: [c, m, y, k], keyword: keyword} <- color_table() do
        assert CMYK.new(c, m, y, k) == Chameleon.convert(Keyword.new(keyword), Color.CMYK)
      end
    end
  end

  describe "Hex and Keyword conversions" do
    test "converts from Hex to Keyword" do
      for %{hex: hex, keyword: keyword} <- color_table() do
        assert Keyword.new(keyword) == Chameleon.convert(Hex.new(hex), Color.Keyword)
      end
    end

    test "converts from Keyword to Hex" do
      for %{hex: hex, keyword: keyword} <- color_table() do
        assert Hex.new(hex) == Chameleon.convert(Keyword.new(keyword), Color.Hex)
      end
    end
  end

  describe "HSV and Keyword conversions" do
    test "converts from HSV to Keyword" do
      for %{hsv: [h, s, v], keyword: keyword} <- color_table() do
        assert Keyword.new(keyword) == Chameleon.convert(HSV.new(h, s, v), Color.Keyword)
      end
    end

    test "converts from Keyword to HSV" do
      for %{hsv: [h, s, v], keyword: keyword} <- color_table() do
        assert HSV.new(h, s, v) == Chameleon.convert(Keyword.new(keyword), Color.HSV)
      end
    end
  end

  describe "HSL and Keyword conversions" do
    test "converts from HSL to Keyword" do
      for %{hsl: [h, s, l], keyword: keyword} <- color_table() do
        assert Keyword.new(keyword) == Chameleon.convert(HSL.new(h, s, l), Color.Keyword)
      end
    end

    test "converts from Keyword to Keyword" do
      for %{hsl: [h, s, l], keyword: keyword} <- color_table() do
        assert HSL.new(h, s, l) == Chameleon.convert(Keyword.new(keyword), Color.HSL)
      end
    end
  end

  describe "Pantone and Keyword conversions" do
    test "converts from Pantone to Keyword" do
      for %{pantone: pantone, keyword: keyword} <- color_table(), not is_nil(pantone) do
        assert Keyword.new(keyword) == Chameleon.convert(Pantone.new(pantone), Color.Keyword)
      end
    end

    test "converts from Keyword to Pantone" do
      for %{pantone: pantone, keyword: keyword} <- color_table(), not is_nil(pantone) do
        assert Pantone.new(pantone) == Chameleon.convert(Keyword.new(keyword), Color.Pantone)
      end
    end
  end
end
