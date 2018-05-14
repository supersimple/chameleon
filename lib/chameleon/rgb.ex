defmodule Chameleon.RGB.Chameleon.Hex do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: rgb}) do
      Chameleon.RGB.to_hex(rgb)
    end
  end
end

defmodule Chameleon.RGB.Chameleon.CMYK do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: rgb}) do
      Chameleon.RGB.to_cmyk(rgb)
    end
  end
end

defmodule Chameleon.RGB.Chameleon.HSL do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: rgb}) do
      Chameleon.RGB.to_hsl(rgb)
    end
  end
end

defmodule Chameleon.RGB.Chameleon.Keyword do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: rgb}) do
      Chameleon.RGB.to_keyword(rgb)
    end
  end
end

defmodule Chameleon.RGB.Chameleon.Pantone do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: rgb}) do
      Chameleon.RGB.to_pantone(rgb)
    end
  end
end

defmodule Chameleon.RGB do
  @enforce_keys [:r, :g, :b]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{r: integer(), g: integer(), b: integer()}

  def new(r, g, b), do: %__MODULE__{r: r, g: g, b: b}

  @doc """
  Converts an rgb color to its hex value.

  ## Examples
      iex> Chameleon.RGB.to_hex(%Chameleon.RGB{r: 255, g: 0, b: 0})
      %Chameleon.Hex{hex: "FF0000"}
  """
  @spec to_hex(Chameleon.RGB.t()) :: Chameleon.Hex.t()
  def to_hex(rgb) do
    hex =
      [rgb.r, rgb.g, rgb.b]
      |> Enum.map(fn dec -> Integer.to_string(dec, 16) |> String.pad_leading(2, "0") end)
      |> Enum.join()

    Chameleon.Hex.new(hex)
  end

  @doc """
  Converts an rgb color to its cmyk value.

  ## Examples
      iex> Chameleon.RGB.to_cmyk(%Chameleon.RGB{r: 255, g: 0, b: 0})
      %Chameleon.CMYK{c: 0, m: 100, y: 100, k: 0}
  """
  @spec to_cmyk(Chameleon.RGB.t()) :: Chameleon.CMYK.t()
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

  @doc """
  Converts an rgb color to its hsl value.

  ## Examples
      iex> Chameleon.RGB.to_hsl(%Chameleon.RGB{r: 255, g: 0, b: 0})
      %Chameleon.HSL{h: 0, s: 100, l: 50}
  """
  @spec to_hsl(Chameleon.RGB.t()) :: Chameleon.HSL.t()
  def to_hsl(rgb) do
    adjusted_rgb = Enum.map([rgb.r, rgb.g, rgb.b], fn v -> v / 255.0 end)
    {rgb_min, rgb_max} = Enum.min_max(adjusted_rgb)
    delta = rgb_max - rgb_min
    h = calculate_hue(delta, rgb_max, adjusted_rgb)
    l = calculate_lightness(rgb_max, rgb_min)
    s = calculate_saturation(rgb_max, rgb_min)
    Chameleon.HSL.new(round(h), round(s), round(l))
  end

  @doc """
  Converts an rgb color to its keyword value.

  ## Examples
      iex> Chameleon.RGB.to_keyword(%Chameleon.RGB{r: 255, g: 0, b: 0})
      %Chameleon.Keyword{keyword: "red"}

      iex> Chameleon.RGB.to_keyword(%Chameleon.RGB{r: 255, g: 75, b: 42})
      {:error, "No keyword match could be found for that rgb value."}
  """
  @spec to_keyword(Chameleon.RGB.t()) :: Chameleon.Keyword.t()
  def to_keyword(rgb) do
    keyword_to_rgb_map()
    |> Enum.find(fn {_k, v} -> v == [rgb.r, rgb.g, rgb.b] end)
    |> case do
      {keyword, _rgb} -> Chameleon.Keyword.new(keyword)
      _ -> {:error, "No keyword match could be found for that rgb value."}
    end
  end

  @doc """
  Converts an rgb color to its pantone value.

  ## Examples
      iex> Chameleon.RGB.to_pantone(%Chameleon.RGB{r: 0, g: 0, b: 0})
      %Chameleon.Pantone{pantone: "30"}
  """
  @spec to_pantone(Chameleon.RGB.t()) :: Chameleon.Pantone.t()
  def to_pantone(rgb) do
    rgb
    |> to_hex()
    |> Chameleon.convert(Chameleon.Pantone)
  end

  #### Helper Functions #######################################################################

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

    h =
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

    Float.round(h)
  end

  defp calculate_lightness(rgb_max, rgb_min) do
    ((rgb_max + rgb_min) / 2 * 100)
    |> Float.round()
  end

  defp calculate_saturation(rgb_max, rgb_min) when rgb_max - rgb_min == 0, do: 0

  defp calculate_saturation(rgb_max, rgb_min) do
    l = (rgb_max + rgb_min) / 2
    (rgb_max - rgb_min) / (1 - :erlang.abs(2 * l - 1)) * 100.0
  end

  defdelegate keyword_to_rgb_map, to: Chameleon.Util
end
