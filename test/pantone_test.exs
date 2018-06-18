defmodule PantoneTest do
  use ExUnit.Case
  use ChameleonTest.Case

  alias Chameleon.{Color, CMYK, Hex, HSL, HSV, Keyword, Pantone, RGB}

  doctest Chameleon.Pantone

  describe "RGB and Pantone conversions" do
    test "converts from RGB to Pantone" do
      for %{rgb: [r, g, b], pantone: pantone} <- color_table(), not is_nil(pantone) do
        assert Pantone.new(pantone) == Chameleon.convert(RGB.new(r, g, b), Color.Pantone)
      end
    end

    test "converts from Pantone to RGB" do
      for %{rgb: [r, g, b], pantone: pantone} <- color_table(), not is_nil(pantone) do
        assert RGB.new(r, g, b) == Chameleon.convert(Pantone.new(pantone), Color.RGB)
      end
    end
  end

  describe "CMYK and Pantone conversions" do
    test "converts from CMYK to Pantone" do
      for %{cmyk: [c, m, y, k], pantone: pantone} <- color_table(), not is_nil(pantone) do
        assert Pantone.new(pantone) == Chameleon.convert(CMYK.new(c, m, y, k), Color.Pantone)
      end
    end

    test "converts from Pantone to CMYK" do
      for %{cmyk: [c, m, y, k], pantone: pantone} <- color_table(), not is_nil(pantone) do
        assert CMYK.new(c, m, y, k) == Chameleon.convert(Pantone.new(pantone), Color.CMYK)
      end
    end
  end

  describe "Hex and Pantone conversions" do
    test "converts from Hex to Pantone" do
      for %{hex: hex, pantone: pantone} <- color_table(), not is_nil(pantone) do
        assert Pantone.new(pantone) == Chameleon.convert(Hex.new(hex), Color.Pantone)
      end
    end

    test "converts from Pantone to Hex" do
      for %{hex: hex, pantone: pantone} <- color_table(), not is_nil(pantone) do
        assert Hex.new(hex) == Chameleon.convert(Pantone.new(pantone), Color.Hex)
      end
    end
  end

  describe "HSV and Pantone conversions" do
    test "converts from HSV to Pantone" do
      for %{hsv: [h, s, v], pantone: pantone} <- color_table(), not is_nil(pantone) do
        assert Pantone.new(pantone) == Chameleon.convert(HSV.new(h, s, v), Color.Pantone)
      end
    end

    test "converts from Pantone to HSV" do
      for %{hsv: [h, s, v], pantone: pantone} <- color_table(), not is_nil(pantone) do
        assert HSV.new(h, s, v) == Chameleon.convert(Pantone.new(pantone), Color.HSV)
      end
    end
  end

  describe "HSL and Pantone conversions" do
    test "converts from HSL to Pantone" do
      for %{hsl: [h, s, l], pantone: pantone} <- color_table(), not is_nil(pantone) do
        assert Pantone.new(pantone) == Chameleon.convert(HSL.new(h, s, l), Color.Pantone)
      end
    end

    test "converts from Pantone to Pantone" do
      for %{hsl: [h, s, l], pantone: pantone} <- color_table(), not is_nil(pantone) do
        assert HSL.new(h, s, l) == Chameleon.convert(Pantone.new(pantone), Color.HSL)
      end
    end
  end

  describe "Keyword and Pantone conversions" do
    test "converts from Keyword to Pantone" do
      for %{keyword: keyword, pantone: pantone} <- color_table(), not is_nil(pantone) do
        assert Pantone.new(pantone) == Chameleon.convert(Keyword.new(keyword), Color.Pantone)
      end
    end

    test "converts from Pantone to Keyword" do
      for %{keyword: keyword, pantone: pantone} <- color_table(), not is_nil(pantone) do
        assert Keyword.new(keyword) == Chameleon.convert(Pantone.new(pantone), Color.Keyword)
      end
    end
  end

  test "recognizes strings as inputs" do
    assert Pantone.new("30") == Chameleon.convert("000000", Color.Pantone)
    assert Pantone.new("30") == Chameleon.convert("000", Color.Pantone)
    assert Pantone.new("30") == Chameleon.convert("#000000", Color.Pantone)
    assert Pantone.new("30") == Chameleon.convert("#000", Color.Pantone)
  end
end
