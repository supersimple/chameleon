defmodule Chameleon.MixProject do
  use Mix.Project

  @source_url "https://github.com/supersimple/chameleon"
  @version "2.3.0"

  def project do
    [
      app: :chameleon,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      docs: docs(),
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
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
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      extras: [
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      assets: "assets",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
