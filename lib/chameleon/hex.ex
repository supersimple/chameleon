defmodule Chameleon.Hex.Chameleon.RGB do
  defstruct [:from]

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: hex}) do
      Chameleon.Hex.to_rgb(hex)
    end
  end
end

defmodule Chameleon.Hex.Chameleon.CMYK do
  defstruct [:from]

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: hex}) do
      Chameleon.Hex.to_cmyk(hex)
    end
  end
end

defmodule Chameleon.Hex.Chameleon.HSL do
  defstruct [:from]

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: hex}) do
      Chameleon.Hex.to_hsl(hex)
    end
  end
end

defmodule Chameleon.Hex.Chameleon.Keyword do
  defstruct [:from]

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: hex}) do
      Chameleon.Hex.to_keyword(hex)
    end
  end
end

defmodule Chameleon.Hex.Chameleon.Pantone do
  defstruct [:from]

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: hex}) do
      Chameleon.Hex.to_pantone(hex)
    end
  end
end

defmodule Chameleon.Hex do
  @enforce_keys [:hex]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{hex: String.t()}

  def new(hex), do: %__MODULE__{hex: String.upcase(hex)}

  @doc """
  Converts a hex color to its rgb value.

  ## Examples
      iex> Chameleon.Hex.to_rgb(%Chameleon.Hex{hex: "FF0000"})
      %Chameleon.RGB{r: 255, g: 0, b: 0}

      iex> Chameleon.Hex.to_rgb(%Chameleon.Hex{hex: "F00"})
      %Chameleon.RGB{r: 255, g: 0, b: 0}
  """
  @spec to_rgb(Chameleon.Hex.t()) :: Chameleon.RGB.t() | {:error, String.t()}
  def to_rgb(hex) do
    convert_short_hex_to_long_hex(hex)
    |> String.split("", trim: true)
    |> do_to_rgb
  end

  @doc """
  Converts a hex color to its keyword value.

  ## Examples
      iex> Chameleon.Hex.to_keyword(%Chameleon.Hex{hex: "FF00FF"})
      %Chameleon.Keyword{keyword: "fuchsia"}

      iex> Chameleon.Hex.to_keyword(%Chameleon.Hex{hex: "6789FE"})
      {:error, "No keyword match could be found for that hex value."}
  """
  @spec to_keyword(Chameleon.Hex.t()) :: Chameleon.Keyword.t() | {:error, String.t()}
  def to_keyword(hex) do
    long_hex = convert_short_hex_to_long_hex(hex)

    keyword_to_hex_map()
    |> Enum.find(fn {_k, v} -> v == String.downcase(long_hex) end)
    |> case do
      {keyword, _hex} -> Chameleon.Keyword.new(keyword)
      _ -> {:error, "No keyword match could be found for that hex value."}
    end
  end

  @doc """
  Converts a hex color to its hsl value.

  ## Examples
      iex> Chameleon.Hex.to_hsl(%Chameleon.Hex{hex: "FF0000"})
      %Chameleon.HSL{h: 0, s: 100, l: 50}
  """
  @spec to_hsl(Chameleon.Hex.t()) :: Chameleon.HSL.t() | {:error, String.t()}
  def to_hsl(hex) do
    hex
    |> to_rgb()
    |> Chameleon.convert(Chameleon.HSL)
  end

  @doc """
  Converts a hex color to its pantone value.

  ## Examples
      iex> Chameleon.Hex.to_pantone(%Chameleon.Hex{hex: "D8CBEB"})
      %Chameleon.Pantone{pantone: "263"}
  """
  @spec to_pantone(Chameleon.Hex.t()) :: Chameleon.Pantone.t() | {:error, String.t()}
  def to_pantone(hex) do
    long_hex = convert_short_hex_to_long_hex(hex)

    pantone_to_hex_map()
    |> Enum.find(fn {_k, v} -> v == String.upcase(long_hex) end)
    |> case do
      {pantone, _hex} -> Chameleon.Pantone.new(pantone)
      _ -> {:error, "No pantone match could be found for that color value."}
    end
  end

  @doc """
  Converts a hex color to its cmyk value.

  ## Examples
      iex> Chameleon.Hex.to_cmyk(%Chameleon.Hex{hex: "FF0000"})
      %Chameleon.CMYK{c: 0, m: 100, y: 100, k: 0}
  """
  @spec to_cmyk(Chameleon.Hex.t()) :: Chameleon.CMYK.t() | {:error, String.t()}
  def to_cmyk(hex) do
    hex
    |> to_rgb()
    |> Chameleon.convert(Chameleon.CMYK)
  end

  #### Helper Functions #######################################################################

  defp do_to_rgb(list) when length(list) == 6 do
    [r, g, b] =
      list
      |> Enum.chunk_every(2)
      |> Enum.map(fn grp -> Enum.join(grp) |> String.to_integer(16) end)

    Chameleon.RGB.new(r, g, b)
  end

  defp do_to_rgb(_list) do
    {:error, "A hex value must be provided as 3 or 6 characters."}
  end

  defp convert_short_hex_to_long_hex(hex) do
    case String.length(hex.hex) do
      3 ->
        hex.hex
        |> String.split("", trim: true)
        |> Enum.map(fn grp -> String.duplicate(grp, 2) end)
        |> Enum.join()

      _ ->
        hex.hex
    end
  end

  defdelegate pantone_to_hex_map, to: Chameleon.Util
  defdelegate keyword_to_hex_map, to: Chameleon.Util
end
