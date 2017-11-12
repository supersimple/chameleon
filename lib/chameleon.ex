defmodule Chameleon do
  alias Chameleon.{Hex, Rgb, Cmyk, Pantone, Keyword, Hsl}
  @moduledoc """
  Chameleon
  --------------------------------------------------------------------------
  Chameleon is a utility that converts colors from one model to another.
  It currently supports: Hex, RGB, CMYK, HSL, Pantone, and Keywords.
  ## Use
  Conversion requires a color value, an input color model, and an output
  color model.
  Example: `Chameleon.convert("FFFFFF", :hex, :rgb) -> {:ok, %{r: 255, g: 255, b: 255}}`

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
    {:ok, "black"}

    iex> Chameleon.convert("black", :keyword, :cmyk)
    {:ok, %{c: 0, m: 0, y: 0, k: 255}}

    iex> Chameleon.convert([0, 0, 0], :hex, :pantone)
    {:error, [0, 0, 0]}
  """
  def convert(value, input_model, output_model) do
    Kernel.apply(input_module(input_model), convert_function(output_model), [value])
  end

  defp input_module(input_model) do
    case input_model do
      :rgb -> Chameleon.Rgb
      :cmyk -> Chameleon.Cmyk
      :hex -> Chameleon.Hex
      :pantone -> Chameleon.Pantone
      :keyword -> Chameleon.Keyword
      :hsl -> Chameleon.Hsl
      _ -> {:error, "Please pass in the input model as an atom."}
    end
  end

  defp convert_function(output_model) do
    "to_" <> Atom.to_string(output_model)
    |> String.to_atom()
  end
end
