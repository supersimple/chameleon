defmodule Chameleon.Keyword do
  @behaviour Chameleon.Behaviour

  @enforce_keys [:keyword]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{keyword: String.t()}

  defimpl Chameleon.Color do
    def convert(keyword, Chameleon.RGB), do: Chameleon.Keyword.to_rgb(keyword)
    def convert(keyword, Chameleon.Hex), do: Chameleon.Keyword.to_hex(keyword)

    def convert(keyword, output) do
      keyword
      |> Chameleon.Keyword.to_rgb()
      |> Chameleon.Color.convert(output)
    end
  end

  def new(keyword), do: %__MODULE__{keyword: keyword}

  def can_convert_directly?(Chameleon.RGB), do: true
  def can_convert_directly?(Chameleon.Hex), do: true
  def can_convert_directly?(_other), do: false

  @doc """
  Converts a keyword color to its rgb value.

  ## Examples
      iex> Chameleon.Keyword.to_rgb(%Chameleon.Keyword{keyword: "Red"})
      %Chameleon.RGB{r: 255, g: 0, b: 0}
  """
  @spec to_rgb(Chameleon.Keyword.t()) :: Chameleon.RGB.t() | {:error, String.t()}
  def to_rgb(keyword) do
    keyword_to_rgb_map()
    |> Enum.find(fn {k, _v} -> k == String.downcase(keyword.keyword) end)
    |> case do
      {_keyword, [r, g, b]} -> Chameleon.RGB.new(r, g, b)
      _ -> {:error, "No keyword match could be found for that rgb value."}
    end
  end

  @doc """
  Converts a keyword color to its hex value.

  ## Examples
      iex> Chameleon.Keyword.to_hex(%Chameleon.Keyword{keyword: "Black"})
      %Chameleon.Hex{hex: "000000"}
  """
  @spec to_hex(Chameleon.Keyword.t()) :: Chameleon.Hex.t() | {:error, String.t()}
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
