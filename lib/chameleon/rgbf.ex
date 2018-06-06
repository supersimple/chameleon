defmodule Chameleon.RGBf.Chameleon.Hex do
  defstruct [:from]

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: rgb}) do
      Chameleon.RGBf.to_hex(rgb)
    end
  end
end

defmodule Chameleon.RGBf.Chameleon.CMYK do
  defstruct [:from]

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: rgb}) do
      Chameleon.RGBf.to_cmyk(rgb)
    end
  end
end

defmodule Chameleon.RGBf.Chameleon.HSL do
  defstruct [:from]

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: rgb}) do
      Chameleon.RGBf.to_hsl(rgb)
    end
  end
end

defmodule Chameleon.RGBf.Chameleon.Keyword do
  defstruct [:from]

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: rgb}) do
      Chameleon.RGBf.to_keyword(rgb)
    end
  end
end

defmodule Chameleon.RGBf.Chameleon.Pantone do
  defstruct [:from]

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: rgb}) do
      Chameleon.RGBf.to_pantone(rgb)
    end
  end
end

defmodule Chameleon.RGBf do
  @enforce_keys [:r, :g, :b]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{r: float(), g: float(), b: float()}

  def new(r, g, b), do: %__MODULE__{r: r, g: g, b: b}

  @doc """
  Converts an rgb color to its hex value.

  ## Examples
      iex> Chameleon.RGBf.to_hex(%Chameleon.RGBf{r: 1.0, g: 0.0, b: 0.0})
      %Chameleon.Hex{hex: "FF0000"}
  """
  @spec to_hex(Chameleon.RGB.t()) :: Chameleon.Hex.t() | {:error, String.t()}
  def to_hex(rgb) do
    hex =
      [rgb.r, rgb.g, rgb.b]
      |> Enum.map(fn dec ->
        round(dec * 255.0) |> Integer.to_string(16) |> String.pad_leading(2, "0")
      end)
      |> Enum.join()

    Chameleon.Hex.new(hex)
  end

  @doc """
  Converts an rgb color to its cmyk value.

  ## Examples
      iex> Chameleon.RGB.to_cmyk(%Chameleon.RGB{r: 255, g: 0, b: 0})
      %Chameleon.CMYK{c: 0, m: 100, y: 100, k: 0}
  """
  @spec to_cmyk(Chameleon.RGB.t()) :: Chameleon.CMYK.t() | {:error, String.t()}
  def to_cmyk(rgb) do
    k = calculate_black_level(rgb)
    [c, m, y] = calculate_cmy(rgb, k)

    Chameleon.CMYK.new(
      c * 100,
      m * 100,
      y * 100,
      k * 100
    )
  end

  @doc """
  Converts an rgb color to its hsl value.

  ## Examples
      iex> Chameleon.RGBf.to_hsl(%Chameleon.RGBf{r: 1.0, g: 0.0, b: 0.0})
      %Chameleon.HSL{h: 0.0, s: 100.0, l: 50.0}
  """
  @spec to_hsl(Chameleon.RGB.t()) :: Chameleon.HSL.t() | {:error, String.t()}
  def to_hsl(rgb) do
    {rgb_min, rgb_max} = Enum.min_max([rgb.r, rgb.g, rgb.b])
    delta = rgb_max - rgb_min
    h = calculate_hue(delta, rgb_max, rgb)
    l = calculate_lightness(rgb_max, rgb_min)
    s = calculate_saturation(rgb_max, rgb_min)
    Chameleon.HSL.new(h, s, l)
  end

  @doc """
  Converts an rgb color to its keyword value.

  ## Examples
      iex> Chameleon.RGBf.to_keyword(%Chameleon.RGBf{r: 1.0, g: 0.0, b: 0.0})
      %Chameleon.Keyword{keyword: "red"}

      iex> Chameleon.RGBf.to_keyword(%Chameleon.RGBf{r: 1.0, g: 0.2941176471, b: 0.1647058824})
      {:error, "No keyword match could be found for that rgb value."}
  """
  @spec to_keyword(Chameleon.RGB.t()) :: Chameleon.Keyword.t() | {:error, String.t()}
  def to_keyword(rgb) do
    keyword_to_rgb_map()
    |> Enum.find(fn {_k, v} ->
      v == [round(rgb.r * 255), round(rgb.g * 255), round(rgb.b * 255)]
    end)
    |> case do
      {keyword, _rgb} -> Chameleon.Keyword.new(keyword)
      _ -> {:error, "No keyword match could be found for that rgb value."}
    end
  end

  @doc """
  Converts an rgb color to its pantone value.

  ## Examples
      iex> Chameleon.RGBf.to_pantone(%Chameleon.RGBf{r: 0.0, g: 0.0, b: 0.0})
      %Chameleon.Pantone{pantone: "30"}
  """
  @spec to_pantone(Chameleon.RGB.t()) :: Chameleon.Pantone.t() | {:error, String.t()}
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
    [r, g, b] = [rgb.r, rgb.g, rgb.b]

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
