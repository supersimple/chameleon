defprotocol Chameleon.Converter do
  @moduledoc """
  Performs the conversions from one color model to another.
  """
  @spec convert(struct(), atom()) :: struct()
  def convert(base, to)
end
