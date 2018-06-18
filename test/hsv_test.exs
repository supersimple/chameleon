defmodule HSVTest do
  use ExUnit.Case
  alias Chameleon.{Color, RGB, HSV}

  doctest Chameleon.HSV

  def rgb_to_hsv_pairs() do
    [
      {RGB.new(0, 0, 0), HSV.new(0, 0, 0)},
      {RGB.new(255, 255, 255), HSV.new(0, 0, 100)},
      {RGB.new(255, 0, 0), HSV.new(0, 100, 100)},
      {RGB.new(0, 255, 0), HSV.new(120, 100, 100)},
      {RGB.new(0, 0, 255), HSV.new(240, 100, 100)},
      {RGB.new(255, 255, 0), HSV.new(60, 100, 100)},
      {RGB.new(0, 255, 255), HSV.new(180, 100, 100)},
      {RGB.new(255, 0, 255), HSV.new(300, 100, 100)},
      {RGB.new(191, 191, 191), HSV.new(0, 0, 75)},
      {RGB.new(128, 128, 128), HSV.new(0, 0, 50)},
      {RGB.new(128, 0, 0), HSV.new(0, 100, 50)},
      {RGB.new(128, 128, 0), HSV.new(60, 100, 50)},
      {RGB.new(0, 128, 0), HSV.new(120, 100, 50)},
      {RGB.new(128, 0, 128), HSV.new(300, 100, 50)},
      {RGB.new(0, 128, 128), HSV.new(180, 100, 50)},
      {RGB.new(0, 0, 128), HSV.new(240, 100, 50)}
    ]
  end

  test "converts from HSV to RGB" do
    for {rgb, hsv} <- rgb_to_hsv_pairs() do
      assert rgb == Chameleon.convert(hsv, Color.RGB)
    end
  end

  test "converts from RGB to HSV" do
    for {rgb, hsv} <- rgb_to_hsv_pairs() do
      assert hsv == Chameleon.convert(rgb, Color.HSV)
    end
  end

  test "converts from keyword to HSV" do
    assert HSV.new(0, 0, 0) == Chameleon.convert("black", Color.HSV)
    assert HSV.new(0, 100, 100) == Chameleon.convert("red", Color.HSV)
    assert HSV.new(120, 100, 100) == Chameleon.convert("lime", Color.HSV)
    assert HSV.new(240, 100, 100) == Chameleon.convert("blue", Color.HSV)
  end
end
