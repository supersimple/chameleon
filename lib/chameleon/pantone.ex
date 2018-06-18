defmodule Chameleon.Pantone do
  alias Chameleon.Pantone

  @enforce_keys [:pantone]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{pantone: String.t()}

  @doc """
  Creates a new color struct.

  ## Examples
      iex> _pantone = Chameleon.Pantone.new("30")
      %Chameleon.Pantone{pantone: "30"}
  """
  @spec new(String.t()) :: Chameleon.Pantone.t()
  def new(pantone), do: %__MODULE__{pantone: pantone}

  defimpl Chameleon.Color.RGB do
    def from(pantone), do: Pantone.to_rgb(pantone)
  end

  defimpl Chameleon.Color.Hex do
    def from(pantone), do: Pantone.to_hex(pantone)
  end

  #### / Conversion Functions / ########################################

  @doc false
  @spec to_rgb(Chameleon.Pantone.t()) :: Chameleon.RGB.t() | {:error, String.t()}
  def to_rgb(pantone) do
    pantone
    |> to_hex()
    |> Chameleon.Color.RGB.from()
  end

  @doc false
  @spec to_hex(Chameleon.Pantone.t()) :: Chameleon.Hex.t() | {:error, String.t()}
  def to_hex(pantone) do
    Chameleon.Util.pantone_to_hex_map()
    |> Enum.find(fn {k, _v} -> k == String.downcase(pantone.pantone) end)
    |> case do
      {_pantone, hex} -> Chameleon.Hex.new(hex)
      _ -> {:error, "No keyword match could be found for that hex value."}
    end
  end
end
