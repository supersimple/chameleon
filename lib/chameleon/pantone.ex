defmodule Chameleon.Pantone.Chameleon.Hex do
  defstruct [:from]

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: pantone}) do
      Chameleon.Pantone.to_hex(pantone)
    end
  end
end

defmodule Chameleon.Pantone.Chameleon.RGB do
  defstruct [:from]

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: pantone}) do
      Chameleon.Pantone.to_rgb(pantone)
    end
  end
end

defmodule Chameleon.Pantone do
  @enforce_keys [:pantone]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{pantone: String.t()}

  def new(pantone), do: %__MODULE__{pantone: pantone}

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
