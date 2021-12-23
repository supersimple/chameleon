defmodule Chameleon.RGB do
  alias Chameleon.RGB

  @enforce_keys [:r, :g, :b]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{r: integer(), g: integer(), b: integer()}

  @doc """
  Creates a new color struct.

  ## Examples

      iex> _rgb = Chameleon.RGB.new(25, 30, 80)
      %Chameleon.RGB{r: 25, g: 30, b: 80}

  """
  @spec new(non_neg_integer(), non_neg_integer(), non_neg_integer()) :: Chameleon.RGB.t()
  def new(r, g, b), do: %__MODULE__{r: r, g: g, b: b}

  defimpl Chameleon.Color.RGB do
    def from(rgb), do: rgb
  end

  defimpl Chameleon.Color.RGB888 do
    def from(rgb), do: RGB.to_rgb888(rgb)
  end

  defimpl Chameleon.Color.CMYK do
    def from(rgb), do: RGB.to_cmyk(rgb)
  end

  defimpl Chameleon.Color.Hex do
    def from(rgb), do: RGB.to_hex(rgb)
  end

  defimpl Chameleon.Color.HSL do
    def from(rgb), do: RGB.to_hsl(rgb)
  end

  defimpl Chameleon.Color.HSV do
    def from(rgb), do: RGB.to_hsv(rgb)
  end

  defimpl Chameleon.Color.Keyword do
    def from(rgb), do: RGB.to_keyword(rgb)
  end

  defimpl Chameleon.Color.Pantone do
    def from(rgb), do: RGB.to_pantone(rgb)
  end

  #### / Conversion Functions / ########################################

  @doc false
  @spec to_rgb888(Chameleon.RGB.t()) :: Chameleon.RGB888.t() | {:error, String.t()}
  def to_rgb888(rgb) do
    Chameleon.RGB888.new(rgb.r, rgb.g, rgb.b)
  end

  @doc false
  @spec to_hex(Chameleon.RGB.t()) :: Chameleon.Hex.t() | {:error, String.t()}
  def to_hex(rgb) do
    hex =
      [rgb.r, rgb.g, rgb.b]
      |> Enum.map(fn dec -> Integer.to_string(dec, 16) |> String.pad_leading(2, "0") end)
      |> Enum.join()

    Chameleon.Hex.new(hex)
  end

  @doc false
  @spec to_cmyk(Chameleon.RGB.t()) :: Chameleon.CMYK.t() | {:error, String.t()}
  def to_cmyk(rgb) do
    adjusted_rgb = Enum.map([rgb.r, rgb.g, rgb.b], fn v -> v / 255.0 end)
    k = calculate_black_level(adjusted_rgb)
    [c, m, y] = calculate_cmy(adjusted_rgb, k)

    Chameleon.CMYK.new(
      round(c * 100),
      round(m * 100),
      round(y * 100),
      round(k * 100)
    )
  end

  @doc false
  @spec to_hsl(Chameleon.RGB.t()) :: Chameleon.HSL.t() | {:error, String.t()}
  def to_hsl(rgb) do
    adjusted_rgb = Enum.map([rgb.r, rgb.g, rgb.b], fn v -> v / 255.0 end)
    {rgb_min, rgb_max} = Enum.min_max(adjusted_rgb)
    delta = rgb_max - rgb_min
    h = calculate_hue(delta, rgb_max, adjusted_rgb)
    l = calculate_lightness(rgb_max, rgb_min)
    s = calculate_saturation(rgb_max, rgb_min)
    Chameleon.HSL.new(round(h), round(s), round(l))
  end

  @doc false
  @spec to_hsv(Chameleon.RGB.t()) :: Chameleon.HSV.t() | {:error, String.t()}
  def to_hsv(rgb) do
    r = rgb.r / 255
    g = rgb.g / 255
    b = rgb.b / 255

    c_max = max(r, max(g, b))
    c_min = min(r, min(g, b))
    delta = c_max - c_min

    h = hue(delta, c_max, r, g, b) |> normalize_degrees() |> round()
    s = round(saturation(delta, c_max) * 100)
    v = round(c_max * 100)

    Chameleon.HSV.new(h, s, v)
  end

  @doc false
  @spec to_keyword(Chameleon.RGB.t()) :: Chameleon.Keyword.t() | {:error, String.t()}
  def to_keyword(rgb) do
    Chameleon.Util.keyword_to_rgb_map()
    |> Enum.find(fn {_k, v} -> v == [rgb.r, rgb.g, rgb.b] end)
    |> case do
      {keyword, _rgb} -> Chameleon.Keyword.new(keyword)
      _ -> {:error, "No keyword match could be found for that rgb value."}
    end
  end

  @doc false
  @spec to_pantone(Chameleon.RGB.t()) :: Chameleon.Pantone.t() | {:error, String.t()}
  def to_pantone(rgb) do
    rgb
    |> to_hex()
    |> Chameleon.convert(Chameleon.Color.Pantone)
  end

  defp calculate_black_level(rgb) do
    1.0 - Enum.max(rgb)
  end

  defp calculate_cmy(_rgb, 1.0) do
    [0.0, 0.0, 0.0]
  end

  defp calculate_cmy(rgb, black) do
    c = (1.0 - Enum.at(rgb, 0) - black) / (1.0 - black)
    m = (1.0 - Enum.at(rgb, 1) - black) / (1.0 - black)
    y = (1.0 - Enum.at(rgb, 2) - black) / (1.0 - black)
    [c, m, y]
  end

  defp calculate_hue(0, _rgb_max, _rgb), do: 0
  defp calculate_hue(0.0, _rgb_max, _rgb), do: 0

  defp calculate_hue(delta, rgb_max, rgb) do
    [r, g, b] = rgb

    cond do
      rgb_max == r ->
        offset = if g < b, do: 6, else: 0
        60.0 * ((g - b) / delta + offset)

      rgb_max == g ->
        60.0 * ((b - r) / delta + 2)

      rgb_max == b ->
        60.0 * ((r - g) / delta + 4)

      true ->
        0
    end
  end

  defp calculate_lightness(rgb_max, rgb_min) do
    (rgb_max + rgb_min) / 2 * 100
  end

  defp calculate_saturation(rgb_max, rgb_min) when rgb_max - rgb_min == 0, do: 0

  defp calculate_saturation(rgb_max, rgb_min) do
    l = (rgb_max + rgb_min) / 2
    (rgb_max - rgb_min) / (1 - :erlang.abs(2 * l - 1)) * 100.0
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
