defprotocol Chameleon.Color do
  @moduledoc """
  Performs the conversions from one color model to another.
  """
  @spec convert(struct()) :: struct()
  def convert(conversion)
end
