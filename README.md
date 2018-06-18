# Chameleon

![Chameleon](https://i.imgur.com/KSOqoPx.png)

[![Build Status](https://semaphoreci.com/api/v1/supersimple/chameleon/branches/master/badge.svg)](https://semaphoreci.com/supersimple/chameleon)

Chameleon is a utility that converts colors from one model to another.
It currently supports: Hex, RGB, CMYK, HSL, HSV, Pantone, and Keywords.

## Use

Chameleon represents colors using Elixir structs. Create a color using one
of the provided structs:

```elixir
iex> mycolor = Chameleon.RGB.new(255, 0, 0)
%Chameleon.RGB{b: 0, g: 0, r: 255}
```

Once you have a color, Chameleon can convert that color to another colorspace or
format:

```elixir
iex> Chameleon.convert(mycolor, Chameleon.HSV)
%Chameleon.HSV{h: 0, s: 100, v: 100}

iex> Chameleon.convert(mycolor, Chameleon.Hex)
%Chameleon.Hex{hex: "FF0000"}
```

Chameleon can also convert strings:

```elixir
iex> Chameleon.convert("#ff0000", Chameleon.RGB)
%Chameleon.RGB{b: 0, g: 0, r: 255}

iex> Chameleon.convert("red", Chameleon.CMYK)
%Chameleon.CMYK{c: 0, k: 0, m: 100, y: 100}
```

If Chameleon doesn't know how to convert the color, you'll get an error:

```elixir
iex> Chameleon.convert("#112233", Chameleon.Pantone)
{:error, "No pantone match could be found for that color value."}
```

## Adding color types

Chameleon uses Elixir protocols internally to perform the conversions. This
makes it possible to add support for new colorspaces and formats in your own
code. To do this, first create a struct for your color:

```elixir
defmodule MyApp.FancyColor do
  @enforce_keys [:c1, :c2, :c3]
  defstruct @enforce_keys

  def new(c1, c2, c3), do: %__MODULE__{c1: c1, c2: c2, c3: c3}
end
```

Next, implement the color protocol. Your color can implement as many or as few color space protocols as you need.
For example:

```elixir
defimpl Chameleon.Color.RGB do
  def from(your_color_struct), do: MyApp.FancyColor.to_rgb(your_color_struct)
end
```
When Chameleon doesn't find a direct conversion from one color to another, it will attempt to convert through RGB. By supporting RGB conversions, your color type will be convertible between many color types. Of course, color conversion is frequently a lossy operation and you may want to implement more conversion modules.

## Caveat(s)

Pantone is designed to be used on printed work only. As such, it is disingenuous to say a
pantone value can be translated to a hex value since hex values will look different depending
on the device displaying them. However, if you have a pantone value and want to find a
device-displayable analog, this library will work.

## Installation

The package can be installed by adding `chameleon` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:chameleon, "~> 2.2.0"}
  ]
end
```

## Contribution

Contributions are welcomed. Please open a pull request or file an issue with your ideas.
Some ideas would be:

* Add a new color model for conversion
* Add functionality to generate complementary colors
* Handle errors for invalid input values
