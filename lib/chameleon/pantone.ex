defmodule Chameleon.Pantone.Chameleon.Hex do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: pantone}) do
      Chameleon.Pantone.to_hex(pantone)
    end
  end
end

defmodule Chameleon.Pantone.Chameleon.Cmyk do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: pantone}) do
      Chameleon.Pantone.to_cmyk(pantone)
    end
  end
end

defmodule Chameleon.Pantone.Chameleon.Hsl do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: pantone}) do
      Chameleon.Pantone.to_hsl(pantone)
    end
  end
end

defmodule Chameleon.Pantone.Chameleon.Keyword do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: pantone}) do
      Chameleon.Pantone.to_keyword(pantone)
    end
  end
end

defmodule Chameleon.Pantone.Chameleon.Rgb do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: pantone}) do
      Chameleon.Pantone.to_rgb(pantone)
    end
  end
end

defmodule Chameleon.Pantone do
  @enforce_keys [:pantone]
  defstruct @enforce_keys

  def new(pantone), do: %__MODULE__{pantone: pantone}

  @doc """
  Converts a pantone color to its rgb value.

  ## Examples
      iex> Chameleon.Pantone.to_rgb(%Chameleon.Pantone{pantone: "30"})
      %Chameleon.Rgb{r: 0, g: 0, b: 0}
  """
  @spec to_rgb(struct()) :: struct()
  def to_rgb(pantone) do
    pantone
    |> to_hex()
    |> Chameleon.convert(Chameleon.Rgb)
  end

  @doc """
  Converts a pantone color to its cmyk value.

  ## Examples
      iex> Chameleon.Pantone.to_cmyk(%Chameleon.Pantone{pantone: "30"})
      %Chameleon.Cmyk{c: 0, m: 0, y: 0, k: 100}
  """
  @spec to_cmyk(struct()) :: struct()
  def to_cmyk(pantone) do
    pantone
    |> to_hex()
    |> Chameleon.convert(Chameleon.Cmyk)
  end

  @doc """
  Converts a pantone color to its hsl value.

  ## Examples
      iex> Chameleon.Pantone.to_hsl(%Chameleon.Pantone{pantone: "30"})
      %Chameleon.Hsl{h: 0, s: 0, l: 0}
  """
  @spec to_hsl(struct()) :: struct()
  def to_hsl(pantone) do
    pantone
    |> to_hex()
    |> Chameleon.convert(Chameleon.Hsl)
  end

  @doc """
  Converts a pantone color to its keyword value.

  ## Examples
      iex> Chameleon.Pantone.to_keyword(%Chameleon.Pantone{pantone: "30"})
      %Chameleon.Keyword{keyword: "black"}
  """
  @spec to_keyword(struct()) :: struct()
  def to_keyword(pantone) do
    pantone
    |> to_hex()
    |> Chameleon.convert(Chameleon.Keyword)
  end

  @doc """
  Converts a pantone color to its hex value.

  ## Examples
      iex> Chameleon.Pantone.to_hex(%Chameleon.Pantone{pantone: "30"})
      %Chameleon.Hex{hex: "000000"}
  """
  @spec to_hex(struct()) :: struct()
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
