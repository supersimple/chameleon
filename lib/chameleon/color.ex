defprotocol Chameleon.Color do
  @moduledoc """
  Performs the conversions from one color model to another.
  """
  @spec convert(struct(), atom()) :: struct()
  def convert(from_color_struct, to_color_module)
end
