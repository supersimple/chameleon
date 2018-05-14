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
end
