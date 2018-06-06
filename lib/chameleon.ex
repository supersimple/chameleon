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

  def convert(input, output) when is_binary(input) do
    # try to discern the input module based on the string
    case Chameleon.Util.derive_input_struct(input) do
      {:ok, input_struct} -> convert(input_struct, output)
      {:error, msg} -> {:error, msg}
    end
  end

  def convert(input_color, output) do
    convert_struct = Module.concat(input_color.__struct__, output)

    cond do
      Code.ensure_compiled?(convert_struct) ->
        Chameleon.Color.convert(convert_struct, input_color)

      output_transform_available_via_rgb?(input_color) ->
        transform_output_via_rgb(input_color, output)

      true ->
        {:error, "No conversion was available from #{input_color.__struct__} to #{output}"}
    end
  end

  defp output_transform_available_via_rgb?(input_color) do
    input_color.__struct__
    |> Module.concat(Chameleon.RGB)
    |> Code.ensure_compiled?()
  end

  defp transform_output_via_rgb(input_color, output) do
    output_replacement = Module.concat(input_color.__struct__, Chameleon.RGB)
    rgb = Chameleon.Color.convert(output_replacement, input_color)
    Chameleon.Color.convert(Module.concat(rgb.__struct__, output), rgb)
  end
end
