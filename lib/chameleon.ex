defmodule Chameleon do
  @moduledoc """
  Chameleon
  --------------------------------------------------------------------------
  Chameleon is a utility that converts colors from one model to another.
  It currently supports: Hex, RGB, CMYK, HSL, Pantone, and Keywords.
  ## Use
  Conversion requires an input color struct, and an output color model.
  Example: `Chameleon.Converter.convert(%Chameleon.Color.new(%{hex: "FFFFFF"}), :rgb) -> %Chameleon.Rgb{r: 255, g: 255, b: 255}`

  If a translation cannot be made, the response will be an error tuple with
  the input value returned.
  Example: `Chameleon.Converter.convert(%Chameleon.Color.new(%{hex: "F69292"}), :pantone) -> {:error, "F69292"}`

  In this example, there is no pantone value that matches that hex value, but
  an error could also be caused by a bad input value;
  Example: `Chameleon.Convert.convert(%Chameleon.Color.new(%{keyword: "Reddish-Blue"}, :hex)`
  """

  @doc """
  This is the only public interface available.

  ## Examples
      iex> input = Chameleon.Color.new(%{hex: "000000"})
      iex> Chameleon.Converter.convert(input, :keyword)
      %Chameleon.Keyword{keyword: "black"}

      iex> input = Chameleon.Color.new(%{keyword: "black"})
      iex> Chameleon.Converter.convert(input, :cmyk)
      %Chameleon.Cmyk{c: 0, m: 0, y: 0, k: 100}
  """
  @spec convert(any, atom, atom) :: tuple()
  def convert(value, input_model, output_model) do
    Kernel.apply(input_module(input_model), convert_function(output_model), [value])
    |> response(value)
  end

  defp response(output, input_value) when is_tuple(output) do
    {:error, input_value}
  end

  defp response(output, _input_value) do
    {:ok, output}
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
    ("to_" <> Atom.to_string(output_model))
    |> String.to_atom()
  end
end
