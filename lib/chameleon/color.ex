defprotocol Chameleon.Color.RGB do
  def from(color)
end

for protocol <- [
      Chameleon.Color.CMYK,
      Chameleon.Color.Hex,
      Chameleon.Color.HSL,
      Chameleon.Color.HSV,
      Chameleon.Color.Keyword,
      Chameleon.Color.Pantone,
      Chameleon.Color.RGB8
    ] do
  defprotocol protocol do
    @fallback_to_any true
    def from(color)
  end

  defimpl protocol, for: Any do
    def from(color) do
      rgb = Chameleon.Color.RGB.from(color)
      @protocol.from(rgb)
    end
  end
end
