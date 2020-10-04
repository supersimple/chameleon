defmodule Chameleon.RGB8 do
  alias Chameleon.RGB8

  @enforce_keys [:r, :g, :b]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{r: integer(), g: integer(), b: integer()}

  @doc """
  Creates a new color struct.

  ## Examples
      iex> _rgb8 = Chameleon.RGB8.new(25, 30, 80)
      %Chameleon.RGB8{r: 25, g: 30, b: 80}
  """
  @spec new(non_neg_integer(), non_neg_integer(), non_neg_integer()) ::
          Chameleon.RGB8.t()
  def new(r, g, b), do: %__MODULE__{r: r, g: g, b: b}

  defimpl Chameleon.Color.RGB do
    def from(rgb8), do: RGB8.to_rgb(rgb8)
  end

  #### / Conversion Functions / ########################################

  @doc false
  @spec to_rgb(Chameleon.RGB8.t()) :: Chameleon.RGB.t() | {:error, String.t()}
  def to_rgb(%{r: r, g: g, b: b}) do
    Chameleon.RGB.new(r, g, b)
  end
end
