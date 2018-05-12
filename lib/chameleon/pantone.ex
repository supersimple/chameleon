defmodule Chameleon.Pantone do
  @enforce_keys [:pantone]
  defstruct @enforce_keys

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
    |> Chameleon.Converter.convert(:rgb)
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
    |> Chameleon.Converter.convert(:cmyk)
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
    |> Chameleon.Converter.convert(:hsl)
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
    |> Chameleon.Converter.convert(:keyword)
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
      {_pantone, hex} -> Chameleon.Color.new(%{hex: hex})
      _ -> {:error, "No keyword match could be found for that hex value."}
    end
  end

  #### Helper Functions #######################################################################

  def pantone_to_hex_map do
    Code.eval_file("lib/chameleon/pantone_to_hex.exs")
    |> Tuple.to_list()
    |> Enum.at(0)
  end
end

defimpl Chameleon.Converter, for: Chameleon.Pantone do
  def convert(pantone, :cmyk), do: Chameleon.Pantone.to_cmyk(pantone)
  def convert(pantone, :hsl), do: Chameleon.Pantone.to_hsl(pantone)
  def convert(pantone, :hex), do: Chameleon.Pantone.to_hex(pantone)
  def convert(pantone, :rgb), do: Chameleon.Pantone.to_rgb(pantone)
  def convert(pantone, :keyword), do: Chameleon.Pantone.to_keyword(pantone)
  def convert(pantone, :pantone), do: pantone
end
