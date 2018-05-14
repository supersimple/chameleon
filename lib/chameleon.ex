defmodule Chameleon do
  @moduledoc """
  Chameleon
  --------------------------------------------------------------------------
  Chameleon is a utility that converts colors from one model to another.
  It currently supports: Hex, RGB, CMYK, HSL, Pantone, and Keywords.
  ## Use
  Conversion requires an input color struct, and an output color model.
  Example: `Chameleon.convert(Chameleon.Hex.new("FFFFFF"), Chameleon.RGB) -> %Chameleon.RGB{r: 255, g: 255, b: 255}`

  If a translation cannot be made, the response will be an error tuple with
  the input value returned.
  Example: `Chameleon.Color.convert(Chameleon.Hex.new("F69292"), Chameleon.Pantone) -> {:error, "No keyword match could be found for that hex value."}`

  In this example, there is no pantone value that matches that hex value, but
  an error could also be caused by a bad input value;
  Example: `Chameleon.convert(Chameleon.Keyword.new("Reddish-Blue", Chameleon.Hex)`
  """

  @doc """
  Handles conversion from the input color struct to the requested output color model.

  ## Examples
      iex> input = Chameleon.Hex.new("000000")
      iex> Chameleon.convert(input, Chameleon.Keyword)
      %Chameleon.Keyword{keyword: "black"}

      iex> input = Chameleon.Keyword.new("black")
      iex> Chameleon.convert(input, Chameleon.CMYK)
      %Chameleon.CMYK{c: 0, m: 0, y: 0, k: 100}
  """

  def convert(%{__struct__: color_model} = c, color_model), do: c

  def convert(input_color, output) do
    convert_struct = Module.concat(input_color.__struct__, output)
    conversion = %{__struct__: convert_struct, from: input_color}
    Chameleon.Color.convert(conversion)
  end
end
