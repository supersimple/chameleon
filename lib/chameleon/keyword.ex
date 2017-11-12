defmodule Chameleon.Keyword do
  alias Chameleon.Rgb

  @doc """
  Converts a keyword color to its rgb value.

  ## Examples
    iex> Chameleon.Keyword.to_rgb("Red")
    %{r: 255, g: 0, b: 0}
  """
  @spec to_rgb(charlist) :: list(integer)
  def to_rgb(value) do
    keyword_to_rgb_map()
    |> Enum.find(fn {k, _v} -> k == String.downcase(value) end)
    |> case do
         {_keyword, [r, g, b]} -> %{r: r, g: g, b: b}
         _ -> {:error, "No keyword match could be found for that rgb value."}
    end
  end

  @doc """
  Converts a keyword color to its cmyk value.

  ## Examples
    iex> Chameleon.Keyword.to_cmyk("Red")
    %{c: 0, m: 100, y: 100, k: 0}
  """
  @spec to_cmyk(charlist) :: list(integer)
  def to_cmyk(keyword) do
    keyword
    |> to_rgb()
    |> rgb_values()
    |> Rgb.to_cmyk()
  end

  @doc """
  Converts a keyword color to its hsl value.

  ## Examples
    iex> Chameleon.Keyword.to_hsl("Red")
    %{h: 0, s: 100, l: 50}
  """
  @spec to_hsl(charlist) :: list(integer)
  def to_hsl(keyword) do
    keyword
    |> to_rgb()
    |> rgb_values()
    |> Rgb.to_hsl()
  end

  @doc """
  Converts a keyword color to its pantone value.

  ## Examples
    iex> Chameleon.Keyword.to_pantone("Black")
    "30"
  """
  @spec to_pantone(charlist) :: charlist
  def to_pantone(keyword) do
    keyword
    |> to_rgb()
    |> rgb_values()
    |> Rgb.to_pantone()
  end

  @doc """
  Converts a keyword color to its hex value.

  ## Examples
    iex> Chameleon.Keyword.to_hex("Black")
    "000000"
  """
  @spec to_hex(charlist) :: charlist
  def to_hex(keyword) do
    keyword_to_hex_map()
    |> Enum.find(fn {k, _v} -> k == String.downcase(keyword) end)
    |> case do
         {_keyword, hex} -> hex
         _ -> {:error, "No keyword match could be found for that hex value."}
    end
  end

  #### Helper Functions #######################################################################

  defp keyword_to_rgb_map do
    Code.eval_file("lib/chameleon/keyword_to_rgb.exs")
    |> Tuple.to_list
    |> Enum.at(0)
  end

  defp keyword_to_hex_map do
    Code.eval_file("lib/chameleon/keyword_to_hex.exs")
    |> Tuple.to_list
    |> Enum.at(0)
  end

  defp rgb_values(rgb_map) do
    [Map.get(rgb_map, :r),
     Map.get(rgb_map, :g),
     Map.get(rgb_map, :b)]
  end
end
