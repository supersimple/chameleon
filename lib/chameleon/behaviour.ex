defmodule Chameleon.Behaviour do
  @callback can_convert_directly?(color_module :: atom()) :: struct()
  @callback convert(from_color_struct :: struct(), to_module :: atom()) :: struct()
end
