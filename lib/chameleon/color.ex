defmodule Chameleon.Color do
  @moduledoc """
  Chameleon.Color
  Converts color inputs into supported structs.
  """

  @doc """
  Converts input into valid struct.

  ## Examples
      iex> Chameleon.Color.new(%{hex: "000000"})
      %Chameleon.Hex{hex: "000000"}

      iex> Chameleon.Color.new(%{c: 0, m: 0, y: 0, k: 100})
      %Chameleon.Cmyk{c: 0, m: 0, y: 0, k: 100}
  """
  @spec new(map()) :: struct()
  def new(%{c: c, m: m, y: y, k: k}), do: %Chameleon.Cmyk{c: c, m: m, y: y, k: k}
  def new(%{r: r, g: g, b: b}), do: %Chameleon.Rgb{r: r, g: g, b: b}
  def new(%{h: h, s: s, l: l}), do: %Chameleon.Hsl{h: h, s: s, l: l}
  def new(%{hex: hex}), do: %Chameleon.Hex{hex: hex}
  def new(%{pantone: pantone}), do: %Chameleon.Pantone{pantone: pantone}
  def new(%{keyword: keyword}), do: %Chameleon.Keyword{keyword: keyword}
  def new(_other), do: argument_error()
  def new(), do: argument_error()

  defp argument_error do
    message = """
    A color argument must be included in one of the following formats:

    %{c: 0, m: 0, y: 0, k: 0}
    %{r: 0, g: 0, b: 0}
    %{h: 0, s: 0, l: 0}
    %{hex: "000000"}
    %{pantone: "30"}
    %{keyword: "black"}
    """

    Mix.raise(message)
  end
end
