defmodule ChameleonTest.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      import unquote(__MODULE__)
      alias ChameleonTest.Case
    end
  end

  def color_table do
    [
      %{
        keyword: "red",
        rgb: [255, 0, 0],
        hex: "FF0000",
        hsl: [0, 100, 50],
        cmyk: [0, 100, 100, 0],
        pantone: nil,
        hsv: [0, 100, 100]
      },
      %{
        keyword: "blue",
        rgb: [0, 0, 255],
        hex: "0000FF",
        hsl: [240, 100, 50],
        cmyk: [100, 100, 0, 0],
        pantone: nil,
        hsv: [240, 100, 100]
      },
      %{
        keyword: "lime",
        rgb: [0, 255, 0],
        hex: "00FF00",
        hsl: [120, 100, 50],
        cmyk: [100, 0, 100, 0],
        pantone: nil,
        hsv: [120, 100, 100]
      },
      %{
        keyword: "black",
        rgb: [0, 0, 0],
        hex: "000000",
        hsl: [0, 0, 0],
        cmyk: [0, 0, 0, 100],
        pantone: "30",
        hsv: [0, 0, 0]
      },
      %{
        keyword: "white",
        rgb: [255, 255, 255],
        hex: "FFFFFF",
        hsl: [0, 0, 100],
        cmyk: [0, 0, 0, 0],
        pantone: "white",
        hsv: [0, 0, 100]
      }
    ]
  end
end
