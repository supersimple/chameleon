defmodule Chameleon.HSV do
  @enforce_keys [:h, :s, :v]
  defstruct @enforce_keys

  @moduledoc """
  HSV (hue, saturation, value) represents colors using a cylinder where colors
  are sorted by angles and then adjusted via the saturation and value
  parameters.

  See Chameleon.HSL for a related, but different colorspace.
  """

  @type degrees() :: 0..360
  @type percent() :: 0..100

  @type t() :: %__MODULE__{h: degrees(), s: percent(), v: percent()}

  @doc """
  Create a new HSV color.
  """
  def new(h, s, v), do: %__MODULE__{h: h, s: s, v: v}
end

defmodule Chameleon.HSV.Chameleon.RGB do
  defstruct [:from]

  alias Chameleon.RGB

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: hsv}) do
      hsv_to_rgb(hsv.h, hsv.s, hsv.v)
    end

    defp hsv_to_rgb(_h, s, v) when s <= 0 do
      a = round(255 * v / 100)
      RGB.new(a, a, a)
    end

    defp hsv_to_rgb(h, s, v) do
      h_sixths = h / 60
      h_sector = round(:math.floor(h_sixths))
      h_offset = h_sixths - h_sector

      s = s / 100
      v = v / 100

      x = round(255 * v * (1 - s))
      y = round(255 * v * (1 - s * h_offset))
      z = round(255 * v * (1 - s * (1 - h_offset)))
      w = round(255 * v)

      hsv_sector_to_rgb(h_sector, x, y, z, w)
    end

    defp hsv_sector_to_rgb(0, x, _y, z, w), do: RGB.new(w, z, x)
    defp hsv_sector_to_rgb(1, x, y, _z, w), do: RGB.new(y, w, x)
    defp hsv_sector_to_rgb(2, x, _y, z, w), do: RGB.new(x, w, z)
    defp hsv_sector_to_rgb(3, x, y, _z, w), do: RGB.new(x, y, w)
    defp hsv_sector_to_rgb(4, x, _y, z, w), do: RGB.new(z, x, w)
    defp hsv_sector_to_rgb(5, x, y, _z, w), do: RGB.new(w, x, y)
  end
end

defmodule Chameleon.RGB.Chameleon.HSV do
  defstruct [:from]

  alias Chameleon.HSV

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: rgb}) do
      r = rgb.r / 255
      g = rgb.g / 255
      b = rgb.b / 255

      c_max = max(r, max(g, b))
      c_min = min(r, min(g, b))
      delta = c_max - c_min

      h = hue(delta, c_max, r, g, b) |> normalize_degrees() |> round()
      s = round(saturation(delta, c_max) * 100)
      v = round(c_max * 100)

      HSV.new(h, s, v)
    end

    defp hue(delta, _, _, _, _) when delta <= 0, do: 0
    defp hue(delta, r, r, g, b), do: 60 * rem(round((g - b) / delta), 6)
    defp hue(delta, g, r, g, b), do: 60 * ((b - r) / delta + 2)
    defp hue(delta, b, r, g, b), do: 60 * ((r - g) / delta + 4)

    defp saturation(_delta, c_max) when c_max <= 0, do: 0
    defp saturation(delta, c_max), do: delta / c_max

    defp normalize_degrees(degrees) when degrees < 0, do: degrees + 360
    defp normalize_degrees(degrees), do: degrees
  end
end
