defmodule Chameleon do
  @moduledoc """
  Chameleon
  --------------------------------------------------------------------------
  Chameleon is a utility that converts colors from one model to another.
  It currently supports: Hex, RGB, CMYK, HSL, Pantone, and Keywords.
  ## Use
  Conversion requires a color value, an input color model, and an output
  color model.
  Example: `Chameleon.convert("FFFFFF", :hex, :rgb) -> {255, 255, 255}`

  If a translation cannot be made, the response will be an error tuple with
  the input value returned.
  Example: `Chameleon.convert("F69292", :hex, :pantone) -> {:error, "F69292"}`

  In this example, there is no pantone value that matches that hex value, but
  an error could also be caused by a bad input value;
  Example: `Chameleon.convert("Reddish-Blue", :keyword, :hex)`

  or an input color model that does not conform with the value passed in:
  Example: `Chameleon.convert({42, 42, 42}, :cmyk, :hex)`
  """

  @doc """
  This is the only public interface available.

  ## Examples
    iex> Chameleon.convert("000000", :hex, :keyword)
    "black"

    iex> Chameleon.convert("black", :keyword, :cmyk)
    {0, 0, 0, 255}

    iex> Chameleon.convert({0, 0, 0}, :hex, :pantone)
    {:error, {0, 0, 0}}
  """
  def convert(value, input_model, output_model) do

  end
end
