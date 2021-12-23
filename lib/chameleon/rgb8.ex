defmodule Chameleon.RGB888 do
  alias Chameleon.RGB888

  @enforce_keys [:r, :g, :b]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{r: integer(), g: integer(), b: integer()}

  @doc """
  Creates a new color struct.

  ## Examples

      iex> _rgb888 = Chameleon.RGB888.new(25, 30, 80)
      %Chameleon.RGB888{r: 25, g: 30, b: 80}

  """
  @spec new(non_neg_integer(), non_neg_integer(), non_neg_integer()) ::
          Chameleon.RGB888.t()
  def new(r, g, b), do: %__MODULE__{r: r, g: g, b: b}

  defimpl Chameleon.Color.RGB do
    def from(rgb888), do: RGB888.to_rgb(rgb888)
  end

  #### / Conversion Functions / ########################################

  @doc false
  @spec to_rgb(Chameleon.RGB888.t()) :: Chameleon.RGB.t() | {:error, String.t()}
  def to_rgb(%{r: r, g: g, b: b}) do
    Chameleon.RGB.new(r, g, b)
  end
end
