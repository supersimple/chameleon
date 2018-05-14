defmodule Chameleon.Keyword.Chameleon.Hex do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: keyword}) do
      Chameleon.Keyword.to_hex(keyword)
    end
  end
end

defmodule Chameleon.Keyword.Chameleon.Cmyk do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: keyword}) do
      Chameleon.Keyword.to_cmyk(keyword)
    end
  end
end

defmodule Chameleon.Keyword.Chameleon.Hsl do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: keyword}) do
      Chameleon.Keyword.to_hsl(keyword)
    end
  end
end

defmodule Chameleon.Keyword.Chameleon.Rgb do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: keyword}) do
      Chameleon.Keyword.to_rgb(keyword)
    end
  end
end

defmodule Chameleon.Keyword.Chameleon.Pantone do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: keyword}) do
      Chameleon.Keyword.to_pantone(keyword)
    end
  end
end

defmodule Chameleon.Keyword do
  @enforce_keys [:keyword]
  defstruct @enforce_keys

  def new(keyword), do: %__MODULE__{keyword: keyword}

  @doc """
  Converts a keyword color to its rgb value.

  ## Examples
      iex> Chameleon.Keyword.to_rgb(%Chameleon.Keyword{keyword: "Red"})
      %Chameleon.Rgb{r: 255, g: 0, b: 0}
  """
  @spec to_rgb(struct()) :: struct()
  def to_rgb(keyword) do
    keyword_to_rgb_map()
    |> Enum.find(fn {k, _v} -> k == String.downcase(keyword.keyword) end)
    |> case do
      {_keyword, [r, g, b]} -> Chameleon.Rgb.new(r, g, b)
      _ -> {:error, "No keyword match could be found for that rgb value."}
    end
  end

  @doc """
  Converts a keyword color to its cmyk value.

  ## Examples
      iex> Chameleon.Keyword.to_cmyk(%Chameleon.Keyword{keyword: "Red"})
      %Chameleon.Cmyk{c: 0, m: 100, y: 100, k: 0}
  """
  @spec to_cmyk(struct()) :: struct()
  def to_cmyk(keyword) do
    keyword
    |> to_rgb()
    |> Chameleon.convert(Chameleon.Cmyk)
  end

  @doc """
  Converts a keyword color to its hsl value.

  ## Examples
      iex> Chameleon.Keyword.to_hsl(%Chameleon.Keyword{keyword: "Red"})
      %Chameleon.Hsl{h: 0, s: 100, l: 50}
  """
  @spec to_hsl(struct()) :: struct()
  def to_hsl(keyword) do
    keyword
    |> to_rgb()
    |> Chameleon.convert(Chameleon.Hsl)
  end

  @doc """
  Converts a keyword color to its pantone value.

  ## Examples
      iex> Chameleon.Keyword.to_pantone(%Chameleon.Keyword{keyword: "Black"})
      %Chameleon.Pantone{pantone: "30"}
  """
  @spec to_pantone(struct()) :: struct()
  def to_pantone(keyword) do
    keyword
    |> to_rgb()
    |> Chameleon.convert(Chameleon.Pantone)
  end

  @doc """
  Converts a keyword color to its hex value.

  ## Examples
      iex> Chameleon.Keyword.to_hex(%Chameleon.Keyword{keyword: "Black"})
      %Chameleon.Hex{hex: "000000"}
  """
  @spec to_hex(struct()) :: struct()
  def to_hex(keyword) do
    keyword_to_hex_map()
    |> Enum.find(fn {k, _v} -> k == String.downcase(keyword.keyword) end)
    |> case do
      {_keyword, hex} -> Chameleon.Hex.new(hex)
      _ -> {:error, "No keyword match could be found for that hex value."}
    end
  end

  #### Helper Functions #######################################################################

  defdelegate keyword_to_rgb_map, to: Chameleon.Util
  defdelegate keyword_to_hex_map, to: Chameleon.Util
end
