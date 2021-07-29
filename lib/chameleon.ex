defmodule Chameleon do
  @external_resource "README.md"
  @moduledoc File.read!("README.md")
             |> String.split(~r/<!-- MDOC !-->/)
             |> Enum.fetch!(1)

  @doc """
  Handles conversion from the input color struct to the requested output color model.

  ## Examples

      iex> input = Chameleon.Hex.new("000000")
      iex> Chameleon.convert(input, Chameleon.Color.Keyword)
      %Chameleon.Keyword{keyword: "black"}

      iex> input = Chameleon.Keyword.new("black")
      iex> Chameleon.convert(input, Chameleon.Color.CMYK)
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
    output_module(output).from(input_color)
  end

  defp output_module(output) do
    # legacy API expects Chameleon.RGB format
    case Module.split(output) do
      ["Chameleon", "Color", _color] -> output
      ["Chameleon", color] -> Module.safe_concat(Chameleon.Color, color)
      _ -> output
    end
  end
end
