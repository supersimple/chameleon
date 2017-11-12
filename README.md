# Chameleon

Chameleon is a utility that converts colors from one model to another.
It currently supports: Hex, RGB, CMYK, HSL, Pantone, and Keywords.

## Use
Conversion requires a color value, an input color model, and an output
color model.
Example: `Chameleon.convert("FFFFFF", :hex, :rgb) -> {:ok, %{r: 255, g: 255, b: 255}}`

If a translation cannot be made, the response will be an error tuple with
the input value returned.
Example: `Chameleon.convert("F69292", :hex, :pantone) -> {:error, "F69292"}`

In this example, there is no pantone value that matches that hex value, but
an error could also be caused by a bad input value;
Example: `Chameleon.convert("Reddish-Blue", :keyword, :hex)`

## Installation

The package can be installed by adding `chameleon` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:chameleon, "~> 1.0.0"}
  ]
end
```
## Contribution
Contributions are welcomed. Please open a pull request or file an issue with your ideas.
Some ideas would be:
 * add a new color model for conversion
 * add functionality to generate complementary colors
 * handle errors for invalid input values
