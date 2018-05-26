defmodule Chameleon.Util do
  def keyword_to_rgb_map do
    Chameleon.KeywordToRGB.load()
  end

  def keyword_to_hex_map do
    Chameleon.KeywordToHex.load()
  end

  def pantone_to_hex_map do
    Chameleon.PantoneToHex.load()
  end

  def derive_input_struct(string) do
    cond do
      match = Regex.named_captures(~r/^#?(?<val>[0-9A-Fa-f]{6})$/, string) ->
        {:ok, Chameleon.Hex.new(match["val"])}

      match = Regex.named_captures(~r/^#?(?<val>[0-9A-Fa-f]{3})$/, string) ->
        {:ok, Chameleon.Hex.new(match["val"])}

      string in Map.keys(keyword_to_hex_map()) ->
        {:ok, Chameleon.Keyword.new(string)}

      string in Map.keys(pantone_to_hex_map()) ->
        {:ok, Chameleon.Pantone.new(string)}

      true ->
        {:error, "The input could not be translated"}
    end
  end
end
