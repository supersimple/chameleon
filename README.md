# Chameleon

![](https://i.imgur.com/KSOqoPx.png)

[![Build Status](https://semaphoreci.com/api/v1/supersimple/chameleon/branches/master/badge.svg)](https://semaphoreci.com/supersimple/chameleon)

Chameleon is a utility that converts colors from one model to another.
It currently supports: Hex, RGB, CMYK, HSL, Pantone, and Keywords.

## Use
Conversion requires an input color struct, and an output color model.
Example: `Chameleon.convert(Chameleon.Hex.new("FFFFFF"), Chameleon.Rgb) -> %Chameleon.Rgb{r: 255, g: 255, b: 255}`

If a translation cannot be made, the response will be an error tuple with
the input value returned.
Example: `Chameleon.Color.convert(Chameleon.Hex.new("F69292"), Chameleon.Pantone) -> {:error, "No keyword match could be found for that hex value."}`

In this example, there is no pantone value that matches that hex value, but
an error could also be caused by a bad input value;
Example: `Chameleon.convert(Chameleon.Keyword.new("Reddish-Blue", Chameleon.Hex)`

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
    {:chameleon, "~> 2.0.0"}
  ]
end
```
## Contribution
Contributions are welcomed. Please open a pull request or file an issue with your ideas.
Some ideas would be:
 * add a new color model for conversion
 * add functionality to generate complementary colors
 * handle errors for invalid input values
