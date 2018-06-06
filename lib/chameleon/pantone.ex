defmodule Chameleon.Pantone do
  @behaviour Chameleon.Behaviour

  @enforce_keys [:pantone]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{pantone: String.t()}

  defimpl Chameleon.Color do
    def convert(pantone, Chameleon.RGB), do: Chameleon.Pantone.to_rgb(pantone)
    def convert(pantone, Chameleon.Hex), do: Chameleon.Pantone.to_hex(pantone)

    def convert(pantone, output) do
      pantone
      |> Chameleon.Pantone.to_rgb()
      |> Chameleon.Color.convert(output)
    end
  end

  def new(pantone), do: %__MODULE__{pantone: pantone}

  def can_convert_directly?(Chameleon.RGB), do: true
  def can_convert_directly?(Chameleon.Hex), do: true
  def can_convert_directly?(_other), do: false

  @doc """
  Converts a pantone color to its rgb value.

  ## Examples
      iex> Chameleon.Pantone.to_rgb(%Chameleon.Pantone{pantone: "30"})
      %Chameleon.RGB{r: 0, g: 0, b: 0}
  """
  @spec to_rgb(Chameleon.Pantone.t()) :: Chameleon.RGB.t() | {:error, String.t()}
  def to_rgb(pantone) do
    pantone
    |> to_hex()
    |> Chameleon.convert(Chameleon.RGB)
  end

  @doc """
  Converts a pantone color to its hex value.

  ## Examples
      iex> Chameleon.Pantone.to_hex(%Chameleon.Pantone{pantone: "30"})
      %Chameleon.Hex{hex: "000000"}
  """
  @spec to_hex(Chameleon.Pantone.t()) :: Chameleon.Hex.t() | {:error, String.t()}
  def to_hex(pantone) do
    pantone_to_hex_map()
    |> Enum.find(fn {k, _v} -> k == String.downcase(pantone.pantone) end)
    |> case do
      {_pantone, hex} -> Chameleon.Hex.new(hex)
      _ -> {:error, "No keyword match could be found for that hex value."}
    end
  end

  #### Helper Functions #######################################################################

  defdelegate pantone_to_hex_map, to: Chameleon.Util
end
