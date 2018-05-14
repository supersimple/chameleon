defmodule Chameleon.Mixfile do
  use Mix.Project

  def project do
    [
      app: :chameleon,
      version: "2.0.1-pre1",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    Chameleon is a utility for converting colors from one color model to another.
    Conversions can be made to/from RGB, CMYK, Hex, HSL, Pantone, and even Keywords.

    For example:
      "FFFFFF" -> %{c: 0, m: 0, y: 0, k: 0}
    """
  end

  defp package do
    [
      name: :chameleon,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Todd Resudek"],
      licenses: ["APACHE 2.0"],
      links: %{"GitHub" => "https://github.com/supersimple/chameleon"}
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.18.1", only: :dev}
    ]
  end
end
