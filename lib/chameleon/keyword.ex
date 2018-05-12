defmodule Chameleon.Keyword do
  @enforce_keys [:keyword]
  defstruct @enforce_keys

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
      {_keyword, [r, g, b]} -> Chameleon.Color.new(%{r: r, g: g, b: b})
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
    |> Chameleon.Converter.convert(:cmyk)
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
    |> Chameleon.Converter.convert(:hsl)
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
    |> Chameleon.Converter.convert(:pantone)
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
      {_keyword, hex} -> Chameleon.Color.new(%{hex: hex})
      _ -> {:error, "No keyword match could be found for that hex value."}
    end
  end

  #### Helper Functions #######################################################################

  defp keyword_to_rgb_map do
    Code.eval_file("lib/chameleon/keyword_to_rgb.exs")
    |> Tuple.to_list()
    |> Enum.at(0)
  end

  def keyword_to_hex_map do
    Code.eval_file("lib/chameleon/keyword_to_hex.exs")
    |> Tuple.to_list()
    |> Enum.at(0)
  end
end

defimpl Chameleon.Converter, for: Chameleon.Keyword do
  def convert(keyword, :cmyk), do: Chameleon.Keyword.to_cmyk(keyword)
  def convert(keyword, :hsl), do: Chameleon.Keyword.to_hsl(keyword)
  def convert(keyword, :hex), do: Chameleon.Keyword.to_hex(keyword)
  def convert(keyword, :pantone), do: Chameleon.Keyword.to_pantone(keyword)
  def convert(keyword, :rgb), do: Chameleon.Keyword.to_rgb(keyword)
  def convert(keyword, :keyword), do: keyword
end
