defmodule RingCentral.MixProject do
  use Mix.Project

  @version "0.1.0"
  @url "https://github.com/linjunpop/ringcentral_elixir"

  def project do
    [
      app: :ringcentral,
      version: @version,
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      name: "RingCentral",
      description: "A thin RingCentral API Wrapper in Elixir",
      source_url: @url,
      homepage_url: @url,
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:oauth2, "~> 0.9"},
      {:poison, "~> 4.0"},
      {:bypass, "~> 0.8", only: :test},
      {:ex_doc, "~> 0.14", only: [:dev, :docs]}
    ]
  end

  defp package do
    [
      name: :ringcentral,
      files: ["lib", "mix.exs", "README*", "LICENSE"],
      maintainers: ["Jun Lin"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/linjunpop/ringcentral_elixir"
      }
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md"
      ]
    ]
  end
end
