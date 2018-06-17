defmodule Chameleon.Keyword do
  alias Chameleon.Keyword

  @enforce_keys [:keyword]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{keyword: String.t()}

  @doc """
  Creates a new color struct.

  ## Examples
      iex> _keyword = Chameleon.Keyword.new("lime")
      %Chameleon.Keyword{keyword: "lime"}
  """
  @spec new(String.t()) :: Chameleon.Keyword.t()
  def new(keyword), do: %__MODULE__{keyword: keyword}

  defimpl Chameleon.Color.RGB do
    def from(keyword), do: Keyword.to_rgb(keyword)
  end

  defimpl Chameleon.Color.Hex do
    def from(keyword), do: Keyword.to_hex(keyword)
  end

  #### / Conversion Functions / ########################################

  @doc false
  @spec to_rgb(Chameleon.Keyword.t()) :: Chameleon.RGB.t() | {:error, String.t()}
  def to_rgb(keyword) do
    Chameleon.Util.keyword_to_rgb_map()
    |> Enum.find(fn {k, _v} -> k == String.downcase(keyword.keyword) end)
    |> case do
      {_keyword, [r, g, b]} -> Chameleon.RGB.new(r, g, b)
      _ -> {:error, "No keyword match could be found for that rgb value."}
    end
  end

  @doc false
  @spec to_hex(Chameleon.Keyword.t()) :: Chameleon.Hex.t() | {:error, String.t()}
  def to_hex(keyword) do
    Chameleon.Util.keyword_to_hex_map()
    |> Enum.find(fn {k, _v} -> k == String.downcase(keyword.keyword) end)
    |> case do
      {_keyword, hex} -> Chameleon.Hex.new(hex)
      _ -> {:error, "No keyword match could be found for that hex value."}
    end
  end
end
