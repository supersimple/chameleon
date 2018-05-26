defmodule KeywordTest do
  use ExUnit.Case
  use ChameleonTest.Case

  alias Chameleon.{CMYK, Hex, HSL, HSV, Keyword, Pantone, RGB}

  doctest Chameleon.Keyword

  describe "RGB and Keyword conversions" do
    test "converts from RGB to Keyword" do
      for %{rgb: [r, g, b], keyword: keyword} <- color_table() do
        assert Keyword.new(keyword) == Chameleon.convert(RGB.new(r, g, b), Keyword)
      end
    end

    test "converts from Keyword to RGB" do
      for %{rgb: [r, g, b], keyword: keyword} <- color_table() do
        assert RGB.new(r, g, b) == Chameleon.convert(Keyword.new(keyword), RGB)
      end
    end
  end

  describe "CMYK and Keyword conversions" do
    test "converts from CMYK to Keyword" do
      for %{cmyk: [c, m, y, k], keyword: keyword} <- color_table() do
        assert Keyword.new(keyword) == Chameleon.convert(CMYK.new(c, m, y, k), Keyword)
      end
    end

    test "converts from Keyword to CMYK" do
      for %{cmyk: [c, m, y, k], keyword: keyword} <- color_table() do
        assert CMYK.new(c, m, y, k) == Chameleon.convert(Keyword.new(keyword), CMYK)
      end
    end
  end

  describe "Hex and Keyword conversions" do
    test "converts from Hex to Keyword" do
      for %{hex: hex, keyword: keyword} <- color_table() do
        assert Keyword.new(keyword) == Chameleon.convert(Hex.new(hex), Keyword)
      end
    end

    test "converts from Keyword to Hex" do
      for %{hex: hex, keyword: keyword} <- color_table() do
        assert Hex.new(hex) == Chameleon.convert(Keyword.new(keyword), Hex)
      end
    end
  end

  describe "HSV and Keyword conversions" do
    test "converts from HSV to Keyword" do
      for %{hsv: [h, s, v], keyword: keyword} <- color_table() do
        assert Keyword.new(keyword) == Chameleon.convert(HSV.new(h, s, v), Keyword)
      end
    end

    test "converts from Keyword to HSV" do
      for %{hsv: [h, s, v], keyword: keyword} <- color_table() do
        assert HSV.new(h, s, v) == Chameleon.convert(Keyword.new(keyword), HSV)
      end
    end
  end

  describe "HSL and Keyword conversions" do
    test "converts from HSL to Keyword" do
      for %{hsl: [h, s, l], keyword: keyword} <- color_table() do
        assert Keyword.new(keyword) == Chameleon.convert(HSL.new(h, s, l), Keyword)
      end
    end

    test "converts from Keyword to Keyword" do
      for %{hsl: [h, s, l], keyword: keyword} <- color_table() do
        assert HSL.new(h, s, l) == Chameleon.convert(Keyword.new(keyword), HSL)
      end
    end
  end

  describe "Pantone and Keyword conversions" do
    test "converts from Pantone to Keyword" do
      for %{pantone: pantone, keyword: keyword} <- color_table(), not is_nil(pantone) do
        assert Keyword.new(keyword) == Chameleon.convert(Pantone.new(pantone), Keyword)
      end
    end

    test "converts from Keyword to Pantone" do
      for %{pantone: pantone, keyword: keyword} <- color_table(), not is_nil(pantone) do
        assert Pantone.new(pantone) == Chameleon.convert(Keyword.new(keyword), Pantone)
      end
    end
  end
end
